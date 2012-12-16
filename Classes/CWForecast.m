//
//  CWForecast.m
//  CoreWeather
//
//  Created by Patrick Perini on 11/19/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWForecast.h"
#import "CoreWeather.h"

@interface CWForecast ()

#pragma mark - Properties
@property CLLocation *location;
@property NSDate *startDate;
@property NSDate *endDate;
@property CWForecastCondition condition;

@end

#pragma mark - Functions
NSString *NSStringFromCWForecastCondition(CWForecastCondition condition)
{    
    switch (condition)
    {
        case CWForecastUnknownCondition:
            return @"Unknown";
            
        // Simple Conditions
        case CWForecastClearCondition:
            return @"Clear";
            
        case CWForecastCloudyCondition:
            return @"Cloudy";
            
        case CWForecastRainyCondition:
            return @"Rainy";
            
        case CWForecastThunderstormCondition:
            return @"Thunderstorms";
            
        case CWForecastSnowyCondition:
            return @"Snowy";
            
        // Complex Conditions
        case CWForecastPartlyCloudyCondition:
            return @"Partly Cloudy";
        
        case CWForecastPartlyRainyCondition:
            return @"Partly Rainy";
            
        case CWForecastPartlySnowyCondition:
            return @"Partly Snowy";
            
        case CWForecastSleetingCondition:
            return @"Sleeting";
    }
}

@implementation CWForecast

#pragma mark - Properties
@synthesize location;
@synthesize startDate;
@synthesize endDate;
@synthesize condition;

#pragma mark - Initializers
- (id)initWithCondition:(CWForecastCondition)aCondition forLocation:(CLLocation *)aLocation onStartDate:(NSDate *)aStartDate throughEndDate:(NSDate *)anEndDate
{
    self = [super init];
    if (!self)
        return nil;
    
    location = [aLocation copy];
    startDate = [aStartDate copy];
    endDate = [anEndDate copy];
    condition = aCondition;
    
    return self;
}

@end
