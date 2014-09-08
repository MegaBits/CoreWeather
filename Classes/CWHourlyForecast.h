//
//  CWHourlyForecast.h
//  CoreWeatherTests
//
//  Created by Patrick Perini on 11/20/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWForecast.h"

@interface CWHourlyForecast : CWForecast

#pragma mark - Properties
/*!
    This hour's forecasted temperature in fahrenheit.
 */
@property (nonatomic, readonly) CGFloat fahrenheitTemperature;

/*!
    This hour's forecasted temperature in celcius.
 */
@property (nonatomic, readonly) CGFloat celciusTemperature;

/*!
    This hour's forecasted wind speed in km/h.
 */
@property (nonatomic, readonly) CGFloat windSpeed;

#pragma mark - Initializers
/*!
    Returns a CWHourlyForecast object initialized with the given parameters.
    @param fahrenheitTemperature The forecasted temperature in fahrenheit.
    @param condition A condition for the receiver.
    @param location A location for the receiver.
    @param startDate The date and time on which the receiver begins.
    @param endDate The date and time on which the receiver ends.
    @return A CWDailyForecast object initialized with the given parameters.
 */
- (id)initWithCondition:(CWForecastCondition)condition fahrenheitTemperature:(CGFloat)temperature windSpeed:(CGFloat)windSpeed forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate;

/*!
    Returns a CWHourlyForecast object initialized with the given parameters.
    @param celciusTemperature The forecasted temperature in celcius.
    @param condition A condition for the receiver.
    @param location A location for the receiver.
    @param startDate The date and time on which the receiver begins.
    @param endDate The date and time on which the receiver ends.
    @return A CWDailyForecast object initialized with the given parameters.
 */
- (id)initWithCondition:(CWForecastCondition)condition celciusTemperature:(CGFloat)temperature windSpeed:(CGFloat)windSpeed forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate;

#pragma mark - Accessors
/*!
    Returns this forecast's temperature in the given scale.
    @param scale A CWForecastTemperatureScale indicating either fahrenheit or celcius.
    @return This forecast's temperature in the given scale.
 */
- (CGFloat)temperatureInScale:(CWForecastTemperatureScale)scale;

@end
