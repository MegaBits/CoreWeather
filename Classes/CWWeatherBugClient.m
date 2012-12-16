//
//  CWWeatherBugClient.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 12/16/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWWeatherBugClient.h"
#import "CoreWeather.h"
#import "NSString+CWHashing.h"

#pragma mark - Internal Constants
NSString *const CWWeatherBugClientURL = @"http://i.wxbug.net/REST/Direct/GetForecast.ashx";

#pragma mark - - Request Constants
NSString *const CWWeatherBugClientRequestValueDescriptionValue = @"d";
NSString *const CWWeatherBugClientRequestValueTemperatureValue = @"t";
NSString *const CWWeatherBugClientRequestValueKey = @"ht";
NSString *const CWWeatherBugClientRequestLatitudeKey = @"la";
NSString *const CWWeatherBugClientRequestLongitudeKey = @"lo";
NSString *const CWWeatherBugClientRequestNumberOfDaysKey = @"nf";
NSString *const CWWeatherBugClientRequestNumberOfHoursKey = @"CWNumberOfHours";
NSString *const CWWeatherBugClientRequestHourlyKey = @"ih";
NSString *const CWWeatherBugClientRequestAPIKeyKey = @"api_key";
NSString *const CWWeatherBugClientRequestHashKey = @"CWHash";

#pragma mark - - Response Constants
NSString *const CWWeatherBugClientResponseForecastListKey = @"forecastList";
NSString *const CWWeatherBugClientResponseHourlyForecastKey = @"hourly";
NSString *const CWWeatherBugClientResponseDescriptionKey = @"desc";
NSString *const CWWeatherBugClientResponseFahrenheitTemperatureKey = @"temperature";
NSString *const CWWeatherBugClientResponseFahrenheitHighTemperatureKey = @"high";
NSString *const CWWeatherBugClientResponseFahrenheitLowTemperatureKey = @"low";

#pragma mark - Globals
static NSDictionary *CWWeatherBugClientConditionsByDescription;

#pragma mark - Internal Functions
static NSString *CWWeatherBugClientStringForRequestValues(CWForecasterRequestValue requestValues)
{
    NSString *requestValueString = @"";
    
    if (requestValues & CWForecasterRequestValueDescription)
    {
        requestValueString = [requestValueString stringByAppendingFormat: @"%@&%@=",
            CWWeatherBugClientRequestValueDescriptionValue,
            CWWeatherBugClientRequestValueKey
        ];
    }
    
    if (requestValues & CWForecasterRequestValueTemperature)
    {
        requestValueString = [requestValueString stringByAppendingFormat: @"%@&%@=",
            CWWeatherBugClientRequestValueTemperatureValue,
            CWWeatherBugClientRequestValueKey
        ];
    }
    
    return requestValueString;
}

static CWForecastCondition CWWeatherBugClientConditionForDescription(NSString *description)
{
    if (!CWWeatherBugClientConditionsByDescription)
    {
        CWWeatherBugClientConditionsByDescription = @{
            @"Uknown":                          @(CWForecastUnknownCondition),
            @"Clear":                           @(CWForecastClearCondition),
            @"Cloudy":                          @(CWForecastCloudyCondition),
            @"Partly Cloudy":                   @(CWForecastPartlyCloudyCondition),
            @"Partly Sunny":                    @(CWForecastPartlyCloudyCondition),
            @"Rain":                            @(CWForecastRainyCondition),
            @"Thunderstorms":                   @(CWForecastThunderstormCondition),
            @"Sunny":                           @(CWForecastClearCondition),
            @"Snow":                            @(CWForecastSnowyCondition),
            @"Flurries":                        @(CWForecastSnowyCondition),
            @"Chance of Snow":                  @(CWForecastSnowyCondition),
            @"Chance of Rain":                  @(CWForecastRainyCondition),
            @"Fair":                            @(CWForecastClearCondition),
            @"Chance of Flurry":                @(CWForecastSnowyCondition),
            @"Chance of Sleet":                 @(CWForecastSleetingCondition),
            @"Chance of Storms":                @(CWForecastThunderstormCondition),
            @"Hazy":                            @(CWForecastPartlyCloudyCondition),
            @"Mostly Cloudy":                   @(CWForecastPartlyCloudyCondition),
            @"Sleet":                           @(CWForecastSleetingCondition),
            @"Mostly Sunny":                    @(CWForecastClearCondition),
            @"Chance of Rain Showers":          @(CWForecastRainyCondition),
            @"Chance of Snow Showers":          @(CWForecastSnowyCondition),
            @"Snow Showers":                    @(CWForecastSnowyCondition),
            @"Rain Showers":                    @(CWForecastRainyCondition),
            @"Freezing Rain":                   @(CWForecastSleetingCondition),
            @"Chance Freezing Rain":            @(CWForecastSleetingCondition),
            @"Windy":                           @(CWForecastClearCondition),
            @"Fog":                             @(CWForecastCloudyCondition),
            @"Scattered Showers":               @(CWForecastRainyCondition),
            @"Scattered Thunderstorms":         @(CWForecastThunderstormCondition),
            @"Light Snow":                      @(CWForecastSnowyCondition),
            @"Chance of Light Snow":            @(CWForecastSnowyCondition),
            @"Frozen Mix":                      @(CWForecastSleetingCondition),
            @"Chance of Frozen Mix":            @(CWForecastSleetingCondition),
            @"Chance of Freezing Drizzle":      @(CWForecastSleetingCondition),
            @"Heavy Snow":                      @(CWForecastSnowyCondition),
            @"Heavy Rain":                      @(CWForecastRainyCondition),
            @"Hot and Humid":                   @(CWForecastClearCondition),
            @"Very Hot":                        @(CWForecastClearCondition),
            @"Increasing Clouds":               @(CWForecastPartlyCloudyCondition),
            @"Clearing":                        @(CWForecastPartlyCloudyCondition),
            @"Mostly Cloudy":                   @(CWForecastCloudyCondition),
            @"Very Cold":                       @(CWForecastClearCondition),
            @"Warm and Humid":                  @(CWForecastClearCondition),
            @"Nowcast":                         @(CWForecastClearCondition),
            @"Headline":                        @(CWForecastClearCondition),
            @"30% Chance of Snow":              @(CWForecastSnowyCondition),
            @"40% Chance of Snow":              @(CWForecastSnowyCondition),
            @"50% Chance of Snow":              @(CWForecastSnowyCondition),
            @"30% Chance of Rain":              @(CWForecastRainyCondition),
            @"40% Chance of Rain":              @(CWForecastRainyCondition),
            @"50% Chance of Rain":              @(CWForecastRainyCondition),
            @"30% Chance of Sleet":             @(CWForecastSleetingCondition),
            @"40% Chance of Sleet":             @(CWForecastSleetingCondition),
            @"50% Chance of Sleet":             @(CWForecastSleetingCondition),
            @"30% Chance of Storms":            @(CWForecastThunderstormCondition),
            @"40% Chance of Storms":            @(CWForecastThunderstormCondition),
            @"50% Chance of Storms":            @(CWForecastThunderstormCondition),
            @"30% Chance of Rain Shower":       @(CWForecastRainyCondition),
            @"40% Chance of Rain Shower":       @(CWForecastRainyCondition),
            @"50% Chance of Rain Shower":       @(CWForecastRainyCondition),
            @"30% Chance of Freezing Rain":     @(CWForecastSleetingCondition),
            @"40% Chance of Freezing Rain":     @(CWForecastSleetingCondition),
            @"50% Chance of Freezing Rain":     @(CWForecastSleetingCondition),
            @"30% Chance of Light Snow":        @(CWForecastSnowyCondition),
            @"40% Chance of Light Snow":        @(CWForecastSnowyCondition),
            @"50% Chance of Light Snow":        @(CWForecastSnowyCondition),
            @"30% Chance of Frozen Mix":        @(CWForecastSleetingCondition),
            @"40% Chance of Frozen Mix":        @(CWForecastSleetingCondition),
            @"50% Chance of Frozen Mix":        @(CWForecastSleetingCondition),
            @"30% Chance of Drizzle":           @(CWForecastRainyCondition),
            @"40% Chance of Drizzle":           @(CWForecastRainyCondition),
            @"50% Chance of Drizzle":           @(CWForecastRainyCondition),
            @"Chance of Snow":                  @(CWForecastSnowyCondition),
            @"Chance of Rain":                  @(CWForecastRainyCondition),
            @"Chance of Flurry":                @(CWForecastSnowyCondition),
            @"Chance of Sleet":                 @(CWForecastSleetingCondition),
            @"Chance of Storms":                @(CWForecastThunderstormCondition),
            @"Chance Rain Shower":              @(CWForecastRainyCondition),
            @"Chance Snow Shower":              @(CWForecastSnowyCondition),
            @"Chance Freezing Rain":            @(CWForecastSleetingCondition),
            @"Chance of Light Snow":            @(CWForecastSnowyCondition),
            @"Chance of Frozen Mix":            @(CWForecastSleetingCondition),
            @"Chance of Drizzle":               @(CWForecastRainyCondition),
            @"Chance of Freezing Drizzle":      @(CWForecastSleetingCondition),
            @"Windy":                           @(CWForecastClearCondition),
            @"Foggy":                           @(CWForecastCloudyCondition)
        };
    }
    
    if ([CWWeatherBugClientConditionsByDescription objectForKey: description])
    {
        return (CWForecastCondition)[[CWWeatherBugClientConditionsByDescription objectForKey: description] integerValue];
    }
    
    return CWForecastUnknownCondition;
}

@interface CWWeatherBugClient ()

#pragma mark - Properties
@property NSMutableDictionary *requestParametersByHash;

#pragma mark - Accessors
- (NSDictionary *)requestParameterForHashInURL:(NSString *)requestURL;
- (void)removeRequestParameterForHashInURL:(NSString *)requestURL;

@end

@implementation CWWeatherBugClient

#pragma mark - Properties
@synthesize apiKey;
@synthesize requestParametersByHash;

#pragma mark - Initializers
- (id)initWithAPIKey:(NSString *)anAPIKey
{
    self = [super init];
    if (!self)
        return nil;
    
    apiKey = anAPIKey;
    requestParametersByHash = [NSMutableDictionary dictionary];
    
    return self;
}

#pragma mark - Accessors
- (NSString *)url
{
    return CWWeatherBugClientURL;
}

- (NSDictionary *)requestParameterForHashInURL:(NSString *)requestURL
{
    NSString *requestHash = [[requestURL componentsSeparatedByString: CWWeatherBugClientRequestHashKey] objectAtIndex: 1];
    requestHash = [requestHash stringByReplacingOccurrencesOfString: @"=" withString: @""];
    return [requestParametersByHash objectForKey: requestHash];
}

- (void)removeRequestParameterForHashInURL:(NSString *)requestURL
{
    NSString *requestHash = [[requestURL componentsSeparatedByString: CWWeatherBugClientRequestHashKey] objectAtIndex: 1];
    requestHash = [requestHash stringByReplacingOccurrencesOfString: @"=" withString: @""];
    [requestParametersByHash removeObjectForKey: requestHash];
}

- (NSDictionary *)parametersForForecastInLocation:(CLLocation *)location numberOfDays:(NSInteger)numberOfDays numberOfHours:(NSInteger)numberOfHours requestValues:(CWForecasterRequestValue)requestValues
{
    NSNumber *hourlyRequest = (numberOfHours == -1)? @(0) : @(1);
    NSString *requestValuesString = CWWeatherBugClientStringForRequestValues(requestValues);
    
    NSMutableDictionary *requestParameters = [@{
        CWWeatherBugClientRequestLatitudeKey:       @(location.coordinate.latitude),
        CWWeatherBugClientRequestLongitudeKey:      @(location.coordinate.longitude),
        CWWeatherBugClientRequestHourlyKey:         hourlyRequest,
        CWWeatherBugClientRequestNumberOfDaysKey:   @(numberOfDays),
        CWWeatherBugClientRequestNumberOfHoursKey:  @(numberOfHours),
        CWWeatherBugClientRequestValueKey:          requestValuesString,
        CWWeatherBugClientRequestAPIKeyKey:         apiKey
    } mutableCopy];
    [requestParameters setObject: [[requestParameters description] md5Hash]
                          forKey: CWWeatherBugClientRequestHashKey];
    
    [requestParametersByHash setObject: requestParameters
                                forKey: [requestParameters objectForKey: CWWeatherBugClientRequestHashKey]];
    
    return requestParameters;
}

- (NSArray *)dailyForecastsForResponse:(PCHTTPResponse *)response
{
    NSArray *responseForecasts = [[response object] objectForKey: CWWeatherBugClientResponseForecastListKey];
    NSDictionary *requestParameters = [self requestParameterForHashInURL: [response requestURL]];
    
    NSMutableArray *forecasts = [NSMutableArray array];
    for (NSDictionary *responseForecast in responseForecasts)
    {
        NSInteger numberOfDays = [[requestParameters objectForKey: CWWeatherBugClientRequestNumberOfDaysKey] integerValue];
        NSInteger dayIndex = [responseForecasts indexOfObject: responseForecast];
        if (dayIndex >= numberOfDays)
            break;
        
        NSString *description = [responseForecast objectForKey: CWWeatherBugClientResponseDescriptionKey];
        CWForecastCondition condition = CWWeatherBugClientConditionForDescription(description);
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude: [[requestParameters objectForKey: CWWeatherBugClientRequestLatitudeKey] floatValue]
                                                          longitude: [[requestParameters objectForKey: CWWeatherBugClientRequestLongitudeKey] floatValue]];
        
        CGFloat highTemperature = [[responseForecast objectForKey: CWWeatherBugClientResponseFahrenheitHighTemperatureKey] doubleValue];
        CGFloat lowTemperature = [[responseForecast objectForKey: CWWeatherBugClientResponseFahrenheitLowTemperatureKey] doubleValue];
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow: (60 * 60 * 24 * dayIndex)];
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow: (60 * 60 * 24 * (dayIndex + 1))];
        
        CWDailyForecast *forecast = [[CWDailyForecast alloc] initWithCondition: condition
                                                     fahrenheitHighTemperature: highTemperature
                                                             andLowTemperature: lowTemperature
                                                                   forLocation: location
                                                                   onStartDate: startDate
                                                                throughEndDate: endDate];
        
        [forecasts addObject: forecast];
    }
    
    [self removeRequestParameterForHashInURL: [response requestURL]];
    return forecasts;
}

- (NSArray *)hourlyForecastsForResponse:(PCHTTPResponse *)response
{
    NSArray *responseForecasts = [[[[response object] objectForKey: CWWeatherBugClientResponseForecastListKey] objectAtIndex: 0] objectForKey: CWWeatherBugClientResponseHourlyForecastKey];
    NSDictionary *requestParameters = [self requestParameterForHashInURL: [response requestURL]];
    
    NSMutableArray *forecasts = [NSMutableArray array];
    for (NSDictionary *responseForecast in responseForecasts)
    {
        NSInteger numberOfHours = [[requestParameters objectForKey: CWWeatherBugClientRequestNumberOfHoursKey] integerValue];
        NSInteger hourIndex = [responseForecasts indexOfObject: responseForecast];
        if (hourIndex >= numberOfHours)
            break;
        
        NSString *description = [responseForecast objectForKey: CWWeatherBugClientResponseDescriptionKey];
        CWForecastCondition condition = CWWeatherBugClientConditionForDescription(description);
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude: [[requestParameters objectForKey: CWWeatherBugClientRequestLatitudeKey] floatValue]
                                                          longitude: [[requestParameters objectForKey: CWWeatherBugClientRequestLongitudeKey] floatValue]];
        
        CGFloat temperature = [[responseForecast objectForKey: CWWeatherBugClientResponseFahrenheitTemperatureKey] doubleValue];
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow: (60 * 60 * hourIndex)];
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow: (60 * 60 * (hourIndex + 1))];
        
        CWHourlyForecast *forecast = [[CWHourlyForecast alloc] initWithCondition: condition
                                                           fahrenheitTemperature: temperature
                                                                     forLocation: location
                                                                     onStartDate: startDate
                                                                  throughEndDate: endDate];
        [forecasts addObject: forecast];
    }
    
    [self removeRequestParameterForHashInURL: [response requestURL]];
    return forecasts;
}

@end