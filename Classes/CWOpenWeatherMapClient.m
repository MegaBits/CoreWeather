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
NSString *const CWOpenWeatherMapClientRequestURL = @"http://api.openweathermap.org/data/2.5/weather";

#pragma mark - - Request Constants
NSString *const CWOpenWeatherMapClientRequestLatitudeKey = @"lat";
NSString *const CWOpenWeatherMapClientRequestLongitudeKey = @"lon";
NSString *const CWOpenWeatherMapClientRequestUnitKey = @"units";
NSString *const CWOpenWeatherMapClientRequestUnitValue = @"imperial";

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
    if (weatherID >= 200 && weatherID < 300) {
        return  CWForecastThunderstormCondition;
    } else if (weatherID >= 300 && weatherID < 400) {
        return CWForecastPartlyRainyCondition;
    } else if (weatherID >= 500 && weatherID < 600) {
        return CWForecastRainyCondition;
    } else if (weatherID >= 600 && weatherID < 700) {
        return CWForecastSnowyCondition;
    } else if (weatherID >= 800 && weatherID < 900) {
        return CWForecastCloudyCondition;
    } else {
        return CWForecastClearCondition;
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
    return @{
        CWOpenWeatherMapClientRequestLatitudeKey:   @(location.coordinate.latitude),
        CWOpenWeatherMapClientRequestLongitudeKey:  @(location.coordinate.longitude),
        CWOpenWeatherMapClientRequestUnitKey:       CWOpenWeatherMapClientRequestUnitValue
    };
}

// Only tuned for current weather.
- (NSArray *)dailyForecastsForResponse:(PCHTTPResponse *)response
{
    return nil;
}

- (NSArray *)hourlyForecastsForResponse:(PCHTTPResponse *)response
{
    if (![response data])
        return nil;
    
    if (![response.object isKindOfClass: [NSDictionary class]]) {
        return @[];
    }
    
    // Grab coordinate
    if (![response.object valueForKey: @"coord"] || ![[response.object valueForKey: @"coord"] isKindOfClass: [NSDictionary class]]) {
        return @[];
    }
    
    NSDictionary *coord = [response.object objectForKey: @"coord"];
    if (![coord objectForKey: @"lat"] || ![coord objectForKey: @"lon"]) {
        return @[];
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude: [[coord objectForKey: @"lat"] doubleValue]
                                                      longitude: [[coord objectForKey: @"lon"] doubleValue]];
    
    // Grab weather
    if (![response.object valueForKey: @"weather"] || ![[response.object valueForKey: @"weather"] isKindOfClass: [NSArray class]]) {
        return @[];
    }
    
    NSArray *weather = [response.object objectForKey: @"weather"];
    if (![[weather firstObject] isKindOfClass: [NSDictionary class]] || ![[weather firstObject] objectForKey: @"id"]) {
        return @[];
    }
    
    CWForecastCondition forecastCondition = CWOpenWeatherMapClientConditionForID([[[weather firstObject] objectForKey: @"id"] intValue]);
    
    // Grab temperature
    if (![response.object valueForKey: @"main"] || ![[response.object valueForKey: @"main"] isKindOfClass: [NSDictionary class]]) {
        return @[];
    }
    
    NSDictionary *main = [response.object objectForKey: @"main"];
    if (![main objectForKey: @"temp"]) {
        return @[];
    }
    
    CGFloat temperature = [[main objectForKey: @"temp"] doubleValue];
    
    // Grab wind speed
    if (![response.object valueForKey: @"wind"] || ![[response.object valueForKey: @"wind"] isKindOfClass: [NSDictionary class]]) {
        return @[];
    }
    
    NSDictionary *wind = [response.object objectForKey: @"wind"];
    if (![wind objectForKey: @"speed"]) {
        return @[];
    }
    
    CGFloat speed = [[wind objectForKey: @"speed"] doubleValue];
    
    // Build forecast
    CWHourlyForecast *hourlyForecast = [[CWHourlyForecast alloc] initWithCondition: forecastCondition
                                                             fahrenheitTemperature: temperature
                                                                         windSpeed: speed
                                                                       forLocation: location
                                                                       onStartDate: [NSDate date]
                                                                    throughEndDate: [NSDate date]];
    
    return @[hourlyForecast];
}

@end
