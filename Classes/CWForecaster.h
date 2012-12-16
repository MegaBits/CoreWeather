//
//  CWForecaster.h
//  CoreWeather
//
//  Created by Patrick Perini on 11/17/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class CWForecast;

#pragma mark - External Constants
typedef void(^CWForecastCompletionBlock)(NSArray *forecasts);

/*!
    Values available for request. Used primarily by whatever private client is referenced by this class.
 */
typedef enum
{
    CWForecasterRequestValueDescription = 0b0001,
    CWForecasterRequestValueTemperature = 0b0010
} CWForecasterRequestValue;

@interface CWForecaster : NSObject

#pragma mark - Class Accessors
/*!
    Returns the API key used by whatever private client is referenced by this class.
    @return The API key used by whatever private client is referenced by this class.
    @discussion CWForecaster currently uses the WeatherBug API. To obtain an API key, register as a user ( http://developer.weatherbug.com/member/register ), then apply for an API key ( http://developer.weatherbug.com/apps/register ).
 */
+ (NSString *)apiKey;

#pragma mark - Class Mutators
/*!
    Sets the API key for whatever private client is referenced by this class.
    @param key The API key for whatever private client is referenced by this class.
 */
+ (void)setAPIKey:(NSString *)key;

#pragma mark - Forecasters
/*!
    Determines the daily forecasts for the given location for the give number of days. Returns this value in the completion block.
    @param location The location for which to determine a forecast.
    @param numberOfDays The number of days for which to determine a forecast.
    @param completion A CWForecastCompletionBlock containing the resultant forecasts.
 */
+ (void)dailyForecastsForLocation:(CLLocation *)location forNumberOfDays:(NSInteger)numberOfDays completion:(CWForecastCompletionBlock)completion;

/*!
    Determines the hourly forecasts for the given location for the give number of hours. Returns this value in the completion block.
    @param location The location for which to determine a forecast.
    @param numberOfHours The number of hours for which to determine a forecast.
    @param completion A CWForecastCompletionBlock containing the resultant forecasts.
 */
+ (void)hourlyForecastsForLocation:(CLLocation *)location forNumberOfHours:(NSInteger)numberOfHours completion:(CWForecastCompletionBlock)completion;

@end
