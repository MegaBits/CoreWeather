//
//  CWDailyForecast.h
//  CoreWeatherTests
//
//  Created by Patrick Perini on 11/20/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "CWForecast.h"

@interface CWDailyForecast : CWForecast

#pragma mark - Properties
/*!
    This day's forecasted high temperature in fahrenheit.
 */
@property (nonatomic, readonly) CGFloat fahrenheitHighTemperature;

/*!
    This day's forecasted low temperature in fahrenheit.
 */
@property (nonatomic, readonly) CGFloat fahrenheitLowTemperature;

/*!
    This day's forecasted high temperature in celcius.
 */
@property (nonatomic, readonly) CGFloat celciusHighTemperature;

/*!
    This day's forecasted low temperature in celcius.
 */
@property (nonatomic, readonly) CGFloat celciusLowTemperature;

/*!
    This day's forecasted high wind speed in km/h
 */
@property (nonatomic, readonly) CGFloat windSpeedHigh;

/*!
 This day's forecasted low wind speed in km/h
 */
@property (nonatomic, readonly) CGFloat windSpeedLow;

#pragma mark - Initializers
/*!
    Returns a CWDailyForecast object initialized with the given parameters.
    @param fahrenheitHighTemperature The forecasted high temperature in fahrenheit.
    @param fahrenheitLowTemperature The forecasted low temperature in fahrenheit.
    @param condition A condition for the receiver.
    @param location A location for the receiver.
    @param startDate The date and time on which the receiver begins.
    @param endDate The date and time on which the receiver ends.
    @return A CWDailyForecast object initialized with the given parameters.
 */
- (id)initWithCondition:(CWForecastCondition)condition fahrenheitHighTemperature:(CGFloat)highTemperature andLowTemperature:(CGFloat)lowTemperature highWindSpeed:(CGFloat)windSpeedHigh lowWindSpeed:(CGFloat)windSpeedLow forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate;

/*!
    Returns a CWDailyForecast object initialized with the given parameters.
    @param celciusHighTemperature The forecasted high temperature in celcius.
    @param celciusLowTemperature The forecasted low temperature in celcius.
    @param condition A condition for the receiver.
    @param location A location for the receiver.
    @param startDate The date and time on which the receiver begins.
    @param endDate The date and time on which the receiver ends.
    @return A CWDailyForecast object initialized with the given parameters.
 */
- (id)initWithCondition:(CWForecastCondition)condition celciusHighTemperature:(CGFloat)highTemperature andLowTemperature:(CGFloat)lowTemperature highWindSpeed:(CGFloat)windSpeedHigh lowWindSpeed:(CGFloat)windSpeedLow forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate;

#pragma mark - Accessors
/*!
    Returns this forecast's high temperature in the given scale.
    @param scale A CWForecastTemperatureScale indicating either fahrenheit or celcius.
    @return This forecast's high temperature in the given scale.
 */
- (CGFloat)highTemperatureInScale:(CWForecastTemperatureScale)scale;
/*!
    Returns this forecast's low temperature in the given scale.
    @param scale A CWForecastTemperatureScale indicating either fahrenheit or celcius.
    @return This forecast's low temperature in the given scale.
 */
- (CGFloat)lowTemperatureInScale:(CWForecastTemperatureScale)scale;

@end
