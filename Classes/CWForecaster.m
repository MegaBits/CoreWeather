//
//  CWForecaster.m
//  CoreWeather
//
//  Created by Patrick Perini on 11/17/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWForecaster.h"
#import "CoreWeather.h"
#import "CWClient.h"
#import "CWOpenWeatherMapClient.h"
#import "PCHTTP.h"

#pragma mark - Globals
static CWClient *weatherClient;

@implementation CWForecaster

#pragma mark - Class Accessors
+ (NSString *)apiKey
{
    return [weatherClient apiKey];
}

#pragma mark - Class Mutators
+ (void)setAPIKey:(NSString *)key
{
    [weatherClient setAPIKey: key];
}

#pragma mark - Initializers
+ (void)initialize
{
    [super initialize];
    
    //weatherClient = [[CWWeatherBugClient alloc] initWithAPIKey: @""];
    weatherClient = [[CWOpenWeatherMapClient alloc] init];
}

#pragma mark - Forecasters
+ (void)dailyForecastsForLocation:(CLLocation *)location forNumberOfDays:(NSInteger)numberOfDays completion:(CWForecastCompletionBlock)completion
{
    NSDictionary *forecastRequestParameters = [weatherClient parametersForForecastInLocation: location
                                                                                   numberOfDays: numberOfDays
                                                                                  numberOfHours: -1
                                                                                  requestValues: CWForecasterRequestValueDescription | CWForecasterRequestValueTemperature];
    
    void (^forecastRequestResponseBlock)(PCHTTPResponse *) = ^(PCHTTPResponse *response)
    {
        if (completion)
        {
            completion([weatherClient dailyForecastsForResponse: response]);
        }
    };
    
    [PCHTTPClient get: [weatherClient url]
           parameters: forecastRequestParameters
      responseHandler: forecastRequestResponseBlock];
}

+ (void)hourlyForecastsForLocation:(CLLocation *)location forNumberOfHours:(NSInteger)numberOfHours completion:(CWForecastCompletionBlock)completion
{
    NSDictionary *forecastRequestParameters = [weatherClient parametersForForecastInLocation: location
                                                                                numberOfDays: 1
                                                                               numberOfHours: numberOfHours
                                                                               requestValues: CWForecasterRequestValueDescription | CWForecasterRequestValueTemperature];
    
    void(^forecastRequestResponseBlock)(PCHTTPResponse *) = ^(PCHTTPResponse *response)
    {
        if (completion)
        {
            completion([weatherClient hourlyForecastsForResponse: response]);
        }
    };
    
    [PCHTTPClient get: [weatherClient url]
           parameters: forecastRequestParameters
      responseHandler: forecastRequestResponseBlock];
}

@end
