//
//  CWHourlyForecast.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 11/20/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWHourlyForecast.h"
#import "CoreWeather.h"

@interface CWHourlyForecast ()

#pragma mark - Properties
@property (nonatomic) CGFloat fahrenheitTemperature;

@end

@implementation CWHourlyForecast

#pragma mark - Properties
@synthesize fahrenheitTemperature;

#pragma mark - Initializers
- (id)initWithCondition:(CWForecastCondition)condition fahrenheitTemperature:(CGFloat)temperature forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate
{
    self = [super initWithCondition: condition
                        forLocation: location
                        onStartDate: startDate
                     throughEndDate: endDate];
    if (!self)
        return nil;
    
    fahrenheitTemperature = temperature;
    
    return self;
}

- (id)initWithCondition:(CWForecastCondition)condition celciusTemperature:(CGFloat)temperature forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate
{
    temperature = CWFahrenheitForCelciusTemperature(temperature);
    
    self = [self initWithCondition: condition
             fahrenheitTemperature: temperature
                       forLocation: location
                       onStartDate: startDate
                    throughEndDate: endDate];
    return self;
}

#pragma mark - Accessors
- (CGFloat)celciusTemperature
{
    return [self temperatureInScale: CWForecastCelciusTemperatureScale];
}

- (CGFloat)temperatureInScale:(CWForecastTemperatureScale)scale
{
    switch (scale)
    {
        case CWForecastFahrenheitTemperatureScale:
            return fahrenheitTemperature;
            
        case CWForecastCelciusTemperatureScale:
            return CWCelciusForFahrenheitTemperature(fahrenheitTemperature);
    }
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat: @"%@ to %@: Temperature: %f. Condition: %@.",
        [self startDate],
        [self endDate],
        [self fahrenheitTemperature],
        NSStringFromCWForecastCondition([self condition])
    ];
    
    return description;
}

@end
