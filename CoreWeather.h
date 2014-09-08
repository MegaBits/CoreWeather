//
//  CoreWeather.h
//  CoreWeather
//
//  Created by Patrick Perini on 11/19/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#pragma mark - Imports
#import "CWForecast.h"
#import "CWDailyForecast.h"
#import "CWHourlyForecast.h"
#import "CWForecaster.h"

#import "NSDate+CWSeasons.h"
#import "NSString+CWHashing.h"

#import "CLLocation+SunriseSunset.h"
#import "PCHTTP.h"

#pragma mark - Functions
/*!
    Returns the fahrenheit temperature for the given celcius temperature.
    @param celciusTemperature A temperature in celcius.
    @return The fahrenheit temperature for the given celcius temperature.
 */
static CGFloat CWFahrenheitForCelciusTemperature(CGFloat celciusTemperature)
{
    return ((celciusTemperature * 9.0) / 5.0) + 32.0;
}

/*!
    Returns the celcius temperature for the given fahrenheit temperature.
    @param fahrenheitTemperature A temperature in fahrenheit.
    @return The celcius temperature for the given fahrenheit temperature.
 */
static CGFloat CWCelciusForFahrenheitTemperature(CGFloat fahrenheitTemperature)
{
    return ((fahrenheitTemperature - 32.0) * 5.0) / 9.0;
}

/*!
 Returns the km/h speed for the given mps speed.
 @param mpsSpeed A speed in mps.
 @return The km/h speed for the given mps speed.
 */
static CGFloat CWKPHSpeedForMPSSpeed(CGFloat mpsSpeed) {
    return mpsSpeed * (3600.0) * (1.0 / 1000.0);
}