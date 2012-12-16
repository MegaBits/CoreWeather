//
//  NSDate+CWSeasons.m
//  CoreWeather
//
//  Created by Patrick Perini on 11/19/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "NSDate+CWSeasons.h"

#pragma mark - Internal Constants
NSInteger CWSeasonsAverageStartDayOfSeasons = 21;
typedef enum
{
    CWSeasonsStartMonthOfWinterSeason = 12,
    CWSeasonsStartMonthOfSpringSeason = 3,
    CWSeasonsStartMonthOfSummerSeason = 6,
    CWSeasonsStartMonthOfAutumnSeason = 9
} CWSeasonsStartMonthOfSeason;

@implementation NSDate (CWSeasons)

#pragma mark - Class Accessors
+ (NSDate *)averageStartDateOfSeason:(CWSeason)season
{
    CWSeasonsStartMonthOfSeason startMonth;
    switch (season)
    {
        case CWWinterSeason:
            startMonth = CWSeasonsStartMonthOfWinterSeason;
            
        case CWSpringSeason:
            startMonth = CWSeasonsStartMonthOfSpringSeason;
            
        case CWSummerSeason:
            startMonth = CWSeasonsStartMonthOfSummerSeason;
            
        case CWAutumnSeason:
            startMonth = CWSeasonsStartMonthOfAutumnSeason;
    }
    
    NSDateComponents *averageStartDateComponents = [[NSDateComponents alloc] init];
    [averageStartDateComponents setMonth: startMonth];
    [averageStartDateComponents setDay: CWSeasonsAverageStartDayOfSeasons];
    
    return [[NSCalendar currentCalendar] dateFromComponents: averageStartDateComponents];
}

+ (CWSeason)currentSeasonForLocation:(CLLocation *)location
{
    return [[NSDate date] seasonForLocation: location];
}

#pragma mark - Accessors
- (CWSeason)seasonForLocation:(CLLocation *)location
{
    NSInteger irrelevantMonth = -1;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components: NSMonthCalendarUnit | NSDayCalendarUnit
                                                                       fromDate: self];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    
    CWSeason season;
    if (month >= CWSeasonsStartMonthOfWinterSeason || month < CWSeasonsStartMonthOfSpringSeason) // CWWinterSeason
    {
        season = CWWinterSeason;
        if (month != CWSeasonsStartMonthOfWinterSeason)
        {
            // We only care about the season-starting months
            month = irrelevantMonth;
        }
    }
    else if (month >= CWSeasonsStartMonthOfSpringSeason && month < CWSeasonsStartMonthOfSummerSeason) // CWSpringSeason
    {
        season = CWSpringSeason;
        if (month != CWSeasonsStartMonthOfSpringSeason)
        {
            // We only care about the season-starting months
            month = irrelevantMonth;
        }
    }
    else if (month >= CWSeasonsStartMonthOfSummerSeason && month < CWSeasonsStartMonthOfAutumnSeason) // CWSummerSeason
    {
        season = CWSummerSeason;
        if (month != CWSeasonsStartMonthOfSummerSeason)
        {
            // We only care about the season-starting months
            month = irrelevantMonth;
        }
    }
    else // (month >= CWSeasonsStartMonthOfAutumnSeason && month < CWSeasonsStartMonthOfWinterSeason) // CWAutumnSeason
    {
        season = CWAutumnSeason;
        if (month != CWSeasonsStartMonthOfAutumnSeason)
        {
            // We only care about the season-starting months
            month = irrelevantMonth;
        }
    }
    
    if ((day < CWSeasonsAverageStartDayOfSeasons) && (month != irrelevantMonth))
    {
        season = season >> 1; // Step back a season
        if (season < CWWinterSeason)
        {
            // Loop back around the calendar
            season = CWAutumnSeason;
        }
    }
    
    // So far, all calculations have been for the norther hemisphere. Therefore:
    if (location.coordinate.latitude < 0) // Southern hemisphere
    {
        // Shift forward 2 seasons
        season = season << 1;
        if (season > CWAutumnSeason)
        {
            // Loop back around the calendar
            season = CWWinterSeason;
        }
        
        season = season << 1;
        if (season > CWAutumnSeason)
        {
            // Loop back around the calendar
            season = CWWinterSeason;
        }
    }
    
    return season;
}

@end
