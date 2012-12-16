//
//  NSDate+CWSeasons.h
//  CoreWeather
//
//  Created by Patrick Perini on 11/19/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#pragma mark - External Constants
/*!
    The four seasons.
 */
typedef enum
{
    CWWinterSeason = 0b0001,
    CWSpringSeason = 0b0010,
    CWSummerSeason = 0b0100,
    CWAutumnSeason = 0b1000
} CWSeason;

@interface NSDate (CWSeasons)

#pragma mark - Class Accessors
/*!
    Returns the most common start date of the given season.
    @param season A season.
    @return The most common start date of the given season.
 */
+ (NSDate *)averageStartDateOfSeason:(CWSeason)season;

/*!
    Returns the current season for the given location, assuming that the season begins on the average start date.
    @param location A location.
    @return The current season for the given location.
 */
+ (CWSeason)currentSeasonForLocation:(CLLocation *)location;

#pragma mark - Accessors
/*!
    Returns the season for the given location on this date.
    @param location A location.
    @return The season for the given location on this date.
 */
- (CWSeason)seasonForLocation:(CLLocation *)location;

@end
