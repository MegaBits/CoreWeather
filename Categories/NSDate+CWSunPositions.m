//
//  NSDate+CWSunPositions.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 2/20/13.
//  Copyright (c) 2013 MegaBits. All rights reserved.
//

#import "NSDate+CWSunPositions.h"
#import <CoreLocation/CoreLocation.h>

#pragma mark - Internal Constants
typedef enum
{
    NSDateSunrisePosition,
    NSDateSolarNoonPosition,
    NSDateSunsetPosition
} NSDateSunPosition;

CGFloat const NSDateNumberOfHoursInDay = 24.0;
CGFloat const NSDateNumberOfSecondsInMinute = 60.0;
CGFloat const NSDateNumberOfMinutesInHour = 60.0;

CGFloat const CLLocationNumberOfRadiansInDegree = M_PI / 180.0;

#pragma mark - Internal Functions
static CGFloat NSDateJulianDayNumberFromDate(NSDate *date)
{
    // TimeZone conversion
    date = [NSDate dateWithTimeInterval: -[[NSTimeZone defaultTimeZone] secondsFromGMT]
                              sinceDate: date];
    
    // Extract date components
    NSInteger dateComponentFlags = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components: dateComponentFlags
                                                                       fromDate: date];
    
    // Mathemagical
    // - Date component
    CGFloat a = (14 - [dateComponents month]) / 12.0;
    
    CGFloat julianYear = [dateComponents year] + 4800 - a;
    CGFloat julianMonth = [dateComponents month] + (12 * a) - 3;
    
    CGFloat julianDay = [dateComponents day] + ((153 * julianMonth + 2) / 5.0) + (365 * julianYear) + (julianYear / 4.0) - (julianYear / 100.0) + (julianYear / 400.0) - 32045;
    
    return julianDay;
}

static NSDate *NSDateFromJulianDayNumber(CGFloat julianDayNumber)
{
    /*
     CGFloat dateNumber = floor(dayNumber + 0.5);
     CGFloat timeNumber = ((dayNumber + 0.5) - dateNumber) * 86400.0;
     
     CGFloat hour = timeNumber / (_NSDateNumberOfSecondsInMinute * _NSDateNumberOfMinutesInHour);
     timeNumber -= hour * (_NSDateNumberOfSecondsInMinute * _NSDateNumberOfMinutesInHour);
     
     CGFloat minute = timeNumber / _NSDateNumberOfSecondsInMinute;
     timeNumber -= minute * _NSDateNumberOfSecondsInMinute;
     
     CGFloat second = timeNumber;
     
     // Mathemagical
     NSInteger a = dateNumber + 32044;
     NSInteger b = floor((4 * a + 3) / 146097);
     NSInteger c = a - floor((b * 146097) / 4);
     NSInteger d = floor((4 * c + 3) / 1461);
     NSInteger e = c - floor((1461 * d) / 4);
     NSInteger m = floor((5 * e + 2) / 153);
     
     CGFloat day = e - floor((153 * m + 2) / 5) + 1;
     CGFloat month = m + 3 - 12 * floor(m / 10);
     CGFloat year = b * 100 + d - 4800 + floor(m / 10);
     
     NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
     [dateComponents setSecond: second];
     [dateComponents setMinute: minute];
     [dateComponents setHour: hour];
     [dateComponents setDay: day];
     [dateComponents setMonth: month];
     [dateComponents setYear: year];
     [dateComponents setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
     
     NSDate *utcDate = [[NSCalendar currentCalendar] dateFromComponents: dateComponents];
     NSDate *date = [NSDate dateWithTimeInterval: [[NSTimeZone defaultTimeZone] secondsFromGMT]
     sinceDate: utcDate];
     
     return date;
     */
    
    // Extract date components
    CGFloat dateComponent = floor(julianDayNumber + 0.5);
    CGFloat timeComponent = ((julianDayNumber + 0.5) - dateComponent) * (NSDateNumberOfHoursInDay * NSDateNumberOfMinutesInHour * NSDateNumberOfSecondsInMinute);
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    // Mathemagical
    // - Date component
    NSInteger a = dateComponent + 32044;
    NSInteger b = floor((4 * a + 3) / 146097);
    NSInteger c = a - floor((b * 146097) / 4);
    NSInteger d = floor((4 * c + 3) / 1461);
    NSInteger e = c - floor((1461 * d) / 4);
    NSInteger f = floor((5 * e + 2) / 153);
    
    CGFloat day = e - floor((153 * f + 2) / 5.0) + 1;
    [dateComponents setDay: day];
    
    CGFloat month = f + 3 - 12 * floor(f / 10.0);
    [dateComponents setMonth: month];
    
    CGFloat year = b * 100 + d - 4800 + floor(f / 10.0 );
    [dateComponents setYear: year];
    
    // - Time component
    CGFloat hour = timeComponent / (NSDateNumberOfMinutesInHour * NSDateNumberOfSecondsInMinute);
    timeComponent -= hour * (NSDateNumberOfMinutesInHour * NSDateNumberOfSecondsInMinute);
    [dateComponents setHour: hour];
    
    CGFloat minute = timeComponent / NSDateNumberOfMinutesInHour;
    timeComponent -= minute * NSDateNumberOfMinutesInHour;
    [dateComponents setMinute: minute];
    
    CGFloat second = timeComponent;
    [dateComponents setSecond: second];
    
    // TimeZone conversion
    [dateComponents setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 0]];
    
    NSDate *utcDate = [[NSCalendar currentCalendar] dateFromComponents: dateComponents];
    NSDate *date = [NSDate dateWithTimeInterval: [[NSTimeZone defaultTimeZone] secondsFromGMT]
                                      sinceDate: utcDate];
    
    return date;
}

@interface NSDate (CWPrivateSunPositions)

#pragma mark - Accessors
- (NSDate *)sunPosition:(NSDateSunPosition)position atLocation:(CLLocation *)location;

@end

@implementation NSDate (CWSunPositions)

#pragma mark - Accessors
- (NSDate *)sunriseTimeAtLocation:(CLLocation *)location
{
    return [self sunPosition: NSDateSunrisePosition
                  atLocation: location];
}

- (NSDate *)sunsetTimeAtLocation:(CLLocation *)location
{
    return [self sunPosition: NSDateSunsetPosition
                  atLocation: location];
}

- (NSDate *)sunPosition:(NSDateSunPosition)position atLocation:(CLLocation *)location
{
    if (![[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString: NSGregorianCalendar])
        return nil;
    
    CGFloat julianDay = NSDateJulianDayNumberFromDate(self);
    
    CGFloat julianCycle = julianDay - 2451545.0009 - (location.coordinate.longitude / 360.0) + 0.25;
    CGFloat approximateSolarNoon = 2451545.0009 + (location.coordinate.longitude / 360.0) + julianCycle;
    
    CGFloat solarMeanAnomaly = (int)(357.5291 + 0.98560028 * (approximateSolarNoon - 2451545.0)) % 360;
    CGFloat equationOfCenter = 1.9148 * sin(solarMeanAnomaly * CLLocationNumberOfRadiansInDegree) + 0.0200 * sin(2 * solarMeanAnomaly * CLLocationNumberOfRadiansInDegree) + 0.0003 * sin(3 * solarMeanAnomaly * CLLocationNumberOfRadiansInDegree);
    
    CGFloat eclipticLongitude = (int)(solarMeanAnomaly + 102.9372 + equationOfCenter + 180.0) % 360;
    CGFloat solarNoon = approximateSolarNoon + 0.0053 * sin(solarMeanAnomaly * CLLocationNumberOfRadiansInDegree) - 0.0069 * sin(2 * eclipticLongitude * CLLocationNumberOfRadiansInDegree);
    
    CGFloat sunDeclination = asin(sin(eclipticLongitude * CLLocationNumberOfRadiansInDegree) * sin(23.45 * CLLocationNumberOfRadiansInDegree)) / CLLocationNumberOfRadiansInDegree;
    CGFloat hourAngle = acos((sin(-0.83 * CLLocationNumberOfRadiansInDegree) - sin(location.coordinate.latitude * CLLocationNumberOfRadiansInDegree) * sin(sunDeclination * CLLocationNumberOfRadiansInDegree)) / (cos(location.coordinate.latitude * CLLocationNumberOfRadiansInDegree) * cos(sunDeclination * CLLocationNumberOfRadiansInDegree))) / CLLocationNumberOfRadiansInDegree;
    
    CGFloat sunsetJulianDate = 2451545.0009 + ((hourAngle + location.coordinate.longitude) / 360.0) + julianCycle + 0.0053 * sin(solarMeanAnomaly * CLLocationNumberOfRadiansInDegree) - 0.0069 * sin(2 * eclipticLongitude * CLLocationNumberOfRadiansInDegree);
    CGFloat sunriseJulianDate = solarNoon - (sunsetJulianDate - solarNoon);
    
    switch (position)
    {
        case NSDateSunrisePosition:
        {
            return NSDateFromJulianDayNumber(sunriseJulianDate);
        }
            
        case NSDateSolarNoonPosition:
        {
            return NSDateFromJulianDayNumber(solarNoon);
        }
            
        case NSDateSunsetPosition:
        {
            return NSDateFromJulianDayNumber(sunsetJulianDate);
        }
    }
}

@end
