//
//  CWDailyForecast.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 11/20/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWDailyForecast.h"
#import "CoreWeather.h"

@interface CWDailyForecast ()

#pragma mark - Properties
@property (nonatomic) CGFloat fahrenheitHighTemperature;
@property (nonatomic) CGFloat fahrenheitLowTemperature;

@end

@implementation CWDailyForecast

#pragma mark - Properties
@synthesize fahrenheitHighTemperature;
@synthesize fahrenheitLowTemperature;

#pragma mark - Initializers
- (id)initWithCondition:(CWForecastCondition)condition fahrenheitHighTemperature:(CGFloat)highTemperature andLowTemperature:(CGFloat)lowTemperature forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate
{
    self = [super initWithCondition: condition
                        forLocation: location
                        onStartDate: startDate
                     throughEndDate: endDate];
    if (!self)
        return nil;
    
    fahrenheitHighTemperature = highTemperature;
    fahrenheitLowTemperature = lowTemperature;
    
    return self;
}

- (id)initWithCondition:(CWForecastCondition)condition celciusHighTemperature:(CGFloat)highTemperature andLowTemperature:(CGFloat)lowTemperature forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate
{
    highTemperature = CWFahrenheitForCelciusTemperature(highTemperature);
    lowTemperature = CWFahrenheitForCelciusTemperature(lowTemperature);
    
    self = [self initWithCondition: condition
         fahrenheitHighTemperature: highTemperature
                 andLowTemperature: lowTemperature
                       forLocation: location
                       onStartDate: startDate
                    throughEndDate: endDate];
    return self;
}

#pragma mark - Accessors
- (CGFloat)celciusHighTemperature
{
    return [self highTemperatureInScale: CWForecastCelciusTemperatureScale];
}

- (CGFloat)celciusLowTemperature
{
    return [self lowTemperatureInScale: CWForecastCelciusTemperatureScale];
}

- (CGFloat)highTemperatureInScale:(CWForecastTemperatureScale)scale
{
    switch (scale)
    {
        case CWForecastFahrenheitTemperatureScale:
            return fahrenheitHighTemperature;
            
        case CWForecastCelciusTemperatureScale:
            return CWCelciusForFahrenheitTemperature(fahrenheitHighTemperature);
    }
}

- (CGFloat)lowTemperatureInScale:(CWForecastTemperatureScale)scale
{
    switch (scale)
    {
        case CWForecastFahrenheitTemperatureScale:
            return fahrenheitLowTemperature;
            
        case CWForecastCelciusTemperatureScale:
            return CWCelciusForFahrenheitTemperature(fahrenheitLowTemperature);
    }
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat: @"%@ to %@: High: %f. Low: %f. Condition: %@.",
        [self startDate],
        [self endDate],
        [self fahrenheitHighTemperature],
        [self fahrenheitLowTemperature],
        NSStringFromCWForecastCondition([self condition])
    ];
    
    return description;
}

@end
