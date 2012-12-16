//
//  CWForecast.h
//  CoreWeather
//
//  Created by Patrick Perini on 11/19/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#pragma mark - External Constants
/*!
    Weather conditions.
 */
typedef enum
{
    CWForecastUnknownCondition      = 0b00000000,
    
    // Simple Conditions
    CWForecastClearCondition        = 0b00000001,
    CWForecastCloudyCondition       = 0b00000010,
    CWForecastRainyCondition        = 0b00000100,
    CWForecastThunderstormCondition = 0b00001000,
    CWForecastSnowyCondition        = 0b00010000,
    
    // Complex Conditions
    CWForecastPartlyCloudyCondition = 0b00000011,
    CWForecastPartlyRainyCondition  = 0b00000110,
    CWForecastPartlySnowyCondition  = 0b00010010,
    CWForecastSleetingCondition     = 0b00010100
} CWForecastCondition;

/*!
    Temperature scales.
 */
typedef enum
{
    CWForecastFahrenheitTemperatureScale,
    CWForecastCelciusTemperatureScale
} CWForecastTemperatureScale;

#pragma mark - External Functions
/*!
    Returns an NSString representation of the given condition.
    @param condition A CWForecastCondition.
    @return An NSString representing the given condition.
 */
extern NSString *NSStringFromCWForecastCondition(CWForecastCondition condition);

@interface CWForecast : NSObject

#pragma mark - Properties
/*!
    The location of this forecast.
 */
@property (readonly) CLLocation *location;

/*!
    The date and time on which this forecast begins.
 */
@property (readonly) NSDate *startDate;

/*!
    The date and time on which this forecast ends.
 */
@property (readonly) NSDate *endDate;

/*!
    The condition of this forecast.
 */
@property (readonly) CWForecastCondition condition;

#pragma mark - Initializers
/*!
    Returns a CWForecast object initialized with the given parameters.
    @param condition A condition for the receiver.
    @param location A location for the receiver.
    @param startDate The date and time on which the receiver begins.
    @param endDate The date and time on which the receiver ends.
    @return A CWForecast object initialized with the given parameters.
 */
- (id)initWithCondition:(CWForecastCondition)condition forLocation:(CLLocation *)location onStartDate:(NSDate *)startDate throughEndDate:(NSDate *)endDate;

@end
