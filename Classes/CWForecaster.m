//
//  CWForecaster.m
//  CoreWeather
//
//  Created by Patrick Perini on 11/17/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWForecaster.h"
#import "CoreWeather.h"
#import "CWWeatherBugClient.h"

#pragma mark - Globals
static CWWeatherBugClient *weatherBugClient;

@implementation CWForecaster

#pragma mark - Class Accessors
+ (NSString *)apiKey
{
    return [weatherBugClient apiKey];
}

#pragma mark - Class Mutators
+ (void)setAPIKey:(NSString *)key
{
    [weatherBugClient setAPIKey: key];
}

#pragma mark - Initializers
+ (void)initialize
{
    [super initialize];
    
    weatherBugClient = [[CWWeatherBugClient alloc] initWithAPIKey: @""];
}

#pragma mark - Forecasters
+ (void)dailyForecastsForLocation:(CLLocation *)location forNumberOfDays:(NSInteger)numberOfDays completion:(CWForecastCompletionBlock)completion
{
    NSDictionary *forecastRequestParameters = [weatherBugClient parametersForForecastInLocation: location
                                                                                   numberOfDays: numberOfDays
                                                                                  numberOfHours: -1
                                                                                  requestValues: CWForecasterRequestValueDescription | CWForecasterRequestValueTemperature];
    
    void (^forecastRequestResponseBlock)(PCHTTPResponse *) = ^(PCHTTPResponse *response)
    {
        if (completion)
        {
            completion([weatherBugClient dailyForecastsForResponse: response]);
        }
    };
    
    [PCHTTPClient get: [weatherBugClient url]
           parameters: forecastRequestParameters
      responseHandler: forecastRequestResponseBlock];
}

+ (void)hourlyForecastsForLocation:(CLLocation *)location forNumberOfHours:(NSInteger)numberOfHours completion:(CWForecastCompletionBlock)completion
{
    NSDictionary *forecastRequestParameters = [weatherBugClient parametersForForecastInLocation: location
                                                                                   numberOfDays: 1
                                                                                  numberOfHours: numberOfHours
                                                                                  requestValues: CWForecasterRequestValueDescription | CWForecasterRequestValueTemperature];
    
    void(^forecastRequestResponseBlock)(PCHTTPResponse *) = ^(PCHTTPResponse *response)
    {
        if (completion)
        {
            completion([weatherBugClient hourlyForecastsForResponse: response]);
        }
    };
    
    [PCHTTPClient get: [weatherBugClient url]
           parameters: forecastRequestParameters
      responseHandler: forecastRequestResponseBlock];
}

@end
