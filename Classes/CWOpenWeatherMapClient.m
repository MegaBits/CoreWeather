//
//  CWOpenWeatherMapClient.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 4/28/13.
//  Copyright (c) 2013 MegaBits. All rights reserved.
//

#import "CWOpenWeatherMapClient.h"
#import "CoreWeather.h"

#pragma mark - Internal Constants
NSString *const CWOpenWeatherMapClientRequestURL = @"http://api.openweathermap.org/data/2.5/forecast";
NSInteger const CWOpenWeatherMapClientMaximumNumberOfHours = 24;
NSInteger const CWOpenWeatherMapClientMaximumNumberOfDays = 5;

#pragma mark - - Request Constants
NSString *const CWOpenWeatherMapClientRequestLatitudeKey = @"lat";
NSString *const CWOpenWeatherMapClientRequestLongitudeKey = @"lon";
NSString *const CWOpenWeatherMapClientRequestCountKey = @"cnt";
NSString *const CWOpenWeatherMapClientRequestUnitKey = @"units";
NSString *const CWOpenWeatherMapClientRequestUnitValue = @"imperial";

#pragma mark - - Response Constants
NSString *const CWOpenWeatherMapClientResponseForecastListKey = @"list";
NSString *const CWOpenWeatherMapClientResponseForecastMainKey = @"main";
NSString *const CWOpenWeatherMapClientResponseForecastTemperatureKey = @"temp";
NSString *const CWOpenWeatherMapClientResponseForecastLowTemperatureKey = @"temp_min";
NSString *const CWOpenWeatherMapClientResponseForecastHighTemperatureKey = @"temp_max";
NSString *const CWOpenWeatherMapClientResponseForecastWeatherKey = @"weather";
NSString *const CWOpenWeatherMapClientResponseForecastWeatherIDKey = @"id";
NSString *const CWOpenWeatherMapClientResponseForecastDateTimeKey = @"dt";
NSString *const CWOpenWeatherMapClientResponseForecastWindKey = @"wind";
NSString *const CWOpenWeatherMapClientResponseForecastWindSpeedKey = @"speed";
NSInteger const CWOpenWeatherMapClientNumberOfHoursPerForecastListing = 3;

#pragma mark - Internal Functions
NSDictionary *CWOpenWeatherMapClientParameterDictionaryFromURL(NSString *url)
{
    NSString *paramString = [[url componentsSeparatedByString: @"?"] objectAtIndex: 1];
    NSArray *paramPairs = [paramString componentsSeparatedByString: @"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSString *paramPair in paramPairs)
    {
        NSArray *paramPieces = [paramPair componentsSeparatedByString: @"="];
        [parameters setObject: [paramPieces objectAtIndex: 1]
                       forKey: [paramPieces objectAtIndex: 0]];
    }
    
    return (NSDictionary *)parameters;
}

CWForecastCondition CWOpenWeatherMapClientConditionForID(NSInteger weatherID)
{
    switch (weatherID)
    {
        // Thunderstorm
        case 200:
        case 201:
        case 202:
        case 210:
        case 211:
        case 212:
        case 221:
        case 230:
        case 231:
        case 232:
        {
            return CWForecastThunderstormCondition;
        }
            
        // Drizzle
        case 300:
        case 301:
        case 302:
        case 310:
        case 311:
        case 312:
        case 321:
        {
            return CWForecastPartlyRainyCondition;
        }
            
        // Rain
        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
        case 520:
        case 521:
        case 522:
        {
            return CWForecastRainyCondition;
        }
            
        // Sleet
        case 511:
        case 611:
        {
            return CWForecastSleetingCondition;
        }
            
        // Snow
        case 600:
        case 601:
        case 602:
        case 621:
        {
            return CWForecastSnowyCondition;
        }
            
        // Clouds
        case 801:
        case 802:
        {
            return CWForecastPartlyCloudyCondition;
        }
            
        case 803:
        case 804:
        {
            return CWForecastCloudyCondition;
        }

        // Clear
        case 800:
        default:
        {
            return CWForecastClearCondition;
        }
    }
}

@implementation CWOpenWeatherMapClient

#pragma mark - Accessors
- (NSString *)url
{
    return CWOpenWeatherMapClientRequestURL;
}

- (NSDictionary *)parametersForForecastInLocation:(CLLocation *)location numberOfDays:(NSInteger)numberOfDays numberOfHours:(NSInteger)numberOfHours requestValues:(CWForecasterRequestValue)requestValues
{
    NSNumber *count;
    if (numberOfHours != -1)
    {
        count = @(MIN(numberOfHours, CWOpenWeatherMapClientMaximumNumberOfHours));
    }
    else
    {
        count = @(MIN(numberOfDays, CWOpenWeatherMapClientMaximumNumberOfDays));
    }
    
    return @{
        CWOpenWeatherMapClientRequestLatitudeKey:   @(location.coordinate.latitude),
        CWOpenWeatherMapClientRequestLongitudeKey:  @(location.coordinate.longitude),
        CWOpenWeatherMapClientRequestCountKey:      count,
        CWOpenWeatherMapClientRequestUnitKey:       CWOpenWeatherMapClientRequestUnitValue
    };
}

- (NSArray *)dailyForecastsForResponse:(PCHTTPResponse *)response
{
    if (![response data])
        return nil;
    
    NSMutableArray *responseForecasts = [[[response object] objectForKey: CWOpenWeatherMapClientResponseForecastListKey] mutableCopy];
    NSDictionary *requestParameters = CWOpenWeatherMapClientParameterDictionaryFromURL([response requestURL]);
    
    NSInteger numberOfDays = [[requestParameters objectForKey: CWOpenWeatherMapClientRequestCountKey] integerValue];
    NSMutableArray *dailyForecasts = [NSMutableArray array];
    
    NSDate *lastStartDate = [NSDate distantPast];
    while (([responseForecasts count] > 0) && ([dailyForecasts count] < numberOfDays))
    {
        NSDictionary *hourlyForecast = [responseForecasts objectAtIndex: 0];
        
        NSTimeInterval defaultTimeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
        NSNumber *startDateTimestamp = [hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastDateTimeKey];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: [startDateTimestamp floatValue] + defaultTimeZoneOffset];
        
        if ([startDate timeIntervalSinceDate: lastStartDate] >= (24 * 60 * 60)) // We've hit another day
        {
            lastStartDate = startDate;
            NSDate *endDate = [startDate dateByAddingTimeInterval: ((60 * 60 * 24) + defaultTimeZoneOffset)];
            
            NSNumber *dailyForecastHighTemperature = [[hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastMainKey] objectForKey: CWOpenWeatherMapClientResponseForecastHighTemperatureKey];
            NSNumber *dailyForecastLowTemperature = [[hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastMainKey] objectForKey: CWOpenWeatherMapClientResponseForecastLowTemperatureKey];
            
            CLLocation *dailyForecastLocation = [[CLLocation alloc] initWithLatitude: [[requestParameters objectForKey: CWOpenWeatherMapClientRequestLatitudeKey] floatValue]
                                                                            longitude: [[requestParameters objectForKey: CWOpenWeatherMapClientRequestLongitudeKey] floatValue]];

            NSNumber *dailyForecastWeatherID = [[[hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastWeatherKey] objectAtIndex: 0] objectForKey: CWOpenWeatherMapClientResponseForecastWeatherIDKey];
            CWForecastCondition forecastCondition = CWOpenWeatherMapClientConditionForID([dailyForecastWeatherID integerValue]);
            
            NSNumber *dailyForecastWindSpeed = [[hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastWindKey] objectForKey: CWOpenWeatherMapClientResponseForecastWindSpeedKey];
            
            CWDailyForecast *forecast = [[CWDailyForecast alloc] initWithCondition: forecastCondition
                                                         fahrenheitHighTemperature: [dailyForecastHighTemperature floatValue]
                                                                 andLowTemperature: [dailyForecastLowTemperature floatValue]
                                                                     highWindSpeed: [dailyForecastWindSpeed floatValue] // No wind speed variance given for OpenWeatherMap
                                                                      lowWindSpeed: [dailyForecastWindSpeed floatValue]
                                                                       forLocation: dailyForecastLocation
                                                                       onStartDate: startDate
                                                                    throughEndDate: endDate];
            [dailyForecasts addObject: forecast];
        }
        
        [responseForecasts removeObjectAtIndex: 0];
    }
    
    return dailyForecasts;
}

- (NSArray *)hourlyForecastsForResponse:(PCHTTPResponse *)response
{
    if (![response data])
        return nil;
    
    NSMutableArray *responseForecasts = [[[response object] objectForKey: CWOpenWeatherMapClientResponseForecastListKey] mutableCopy];
    NSDictionary *requestParameters = CWOpenWeatherMapClientParameterDictionaryFromURL([response requestURL]);
    
    NSInteger numberOfHours = [[requestParameters objectForKey: CWOpenWeatherMapClientRequestCountKey] integerValue];
    NSMutableArray *hourlyForecasts = [NSMutableArray array];
    
    while ([responseForecasts count] > 0)
    {
        for (NSInteger hourIndex = 0; (hourIndex < CWOpenWeatherMapClientNumberOfHoursPerForecastListing) && ([hourlyForecasts count] < numberOfHours); hourIndex++)
        {            
            NSDictionary *hourlyForecast = [responseForecasts objectAtIndex: 0];
            NSNumber *hourlyForecastTemperature = [[hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastMainKey] objectForKey: CWOpenWeatherMapClientResponseForecastTemperatureKey];
            
            CLLocation *hourlyForecastLocation = [[CLLocation alloc] initWithLatitude: [[requestParameters objectForKey: CWOpenWeatherMapClientRequestLatitudeKey] floatValue]
                                                                            longitude: [[requestParameters objectForKey: CWOpenWeatherMapClientRequestLongitudeKey] floatValue]];
            
            NSNumber *hourlyForecastWeatherID = [[[hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastWeatherKey] objectAtIndex: 0] objectForKey: CWOpenWeatherMapClientResponseForecastWeatherIDKey];
            CWForecastCondition forecastCondition = CWOpenWeatherMapClientConditionForID([hourlyForecastWeatherID integerValue]);
            
            NSTimeInterval defaultTimeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
            NSNumber *startDateTimestamp = [hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastDateTimeKey];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: [startDateTimestamp floatValue] + defaultTimeZoneOffset];
            NSDate *endDate = [startDate dateByAddingTimeInterval: ((60 * 60) + defaultTimeZoneOffset)];
            
            NSNumber *hourlyForecastWindSpeed = [[hourlyForecast objectForKey: CWOpenWeatherMapClientResponseForecastWindKey] objectForKey: CWOpenWeatherMapClientResponseForecastWindSpeedKey];
            
            CWHourlyForecast *forecast = [[CWHourlyForecast alloc] initWithCondition: forecastCondition
                                                               fahrenheitTemperature: [hourlyForecastTemperature floatValue]
                                                                           windSpeed: [hourlyForecastWindSpeed floatValue]
                                                                         forLocation: hourlyForecastLocation
                                                                         onStartDate: startDate
                                                                      throughEndDate: endDate];
            [hourlyForecasts addObject: forecast];
        }
        
        [responseForecasts removeObjectAtIndex: 0];
    }
    
    return (NSArray *)hourlyForecasts;
}

@end
