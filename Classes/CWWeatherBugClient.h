//
//  CWWeatherBugClient.h
//  CoreWeatherTests
//
//  Created by Patrick Perini on 12/16/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CWForecaster.h"
@class CWDailyForecast;
@class CWHourlyForecast;
@class PCHTTPClient;
@class PCHTTPResponse;

@interface CWWeatherBugClient : NSObject

#pragma mark - Properties
@property (copy, setter = setAPIKey:) NSString *apiKey;
@property (nonatomic, readonly) NSString *url;

#pragma mark - Initalizers
- (id)initWithAPIKey:(NSString *)apiKey;

#pragma mark - Accessors
- (NSDictionary *)parametersForForecastInLocation:(CLLocation *)location numberOfDays:(NSInteger)numberOfDays numberOfHours:(NSInteger)numberOfHours requestValues:(CWForecasterRequestValue)requestValues;
- (NSArray *)dailyForecastsForResponse:(PCHTTPResponse *)response;
- (NSArray *)hourlyForecastsForResponse:(PCHTTPResponse *)response;

@end