//
//  CWClient.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 4/27/13.
//  Copyright (c) 2013 MegaBits. All rights reserved.
//

#import "CWClient.h"

@implementation CWClient

#pragma mark - Properties
@synthesize apiKey;

#pragma mark - Initializers
- (id)initWithAPIKey:(NSString *)apiKey
{
    @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                   reason: [NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo: nil];
}

#pragma mark - Accessors
- (NSDictionary *)parametersForForecastInLocation:(CLLocation *)location numberOfDays:(NSInteger)numberOfDays numberOfHours:(NSInteger)numberOfHours requestValues:(CWForecasterRequestValue)requestValues
{
    @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                   reason: [NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo: nil];
}

- (NSArray *)dailyForecastsForResponse:(PCHTTPResponse *)response
{
    @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                   reason: [NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo: nil];
}

- (NSArray *)hourlyForecastsForResponse:(PCHTTPResponse *)response
{
    @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                   reason: [NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo: nil];
}

@end
