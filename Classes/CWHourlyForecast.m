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
- (id)initWithCondition:(CWForecastCondition)condition fahrenheitTemperature:(CGFloat)temperature windSpeed:(CGFloat)windSpeed forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate
{
    self = [super initWithCondition: condition
                        forLocation: location
                        onStartDate: startDate
                     throughEndDate: endDate];
    if (!self)
        return nil;
    
    fahrenheitTemperature = temperature;
    _windSpeed = CWKPHSpeedForMPSSpeed(windSpeed);
    
    return self;
}

- (id)initWithCondition:(CWForecastCondition)condition celciusTemperature:(CGFloat)temperature windSpeed:(CGFloat)windSpeed forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate
{
    temperature = CWFahrenheitForCelciusTemperature(temperature);
    
    self = [self initWithCondition: condition
             fahrenheitTemperature: temperature
                         windSpeed: windSpeed
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
    NSString *description = [NSString stringWithFormat: @"%@ to %@: Temperature: %f F. Winds: %f km/h. Condition: %@.",
        [self startDate],
        [self endDate],
        [self fahrenheitTemperature],
        self.windSpeed,
        NSStringFromCWForecastCondition([self condition])
    ];
    
    return description;
}

@end
