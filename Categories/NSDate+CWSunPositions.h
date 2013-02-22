//
//  NSDate+CWSunPositions.h
//  CoreWeatherTests
//
//  Created by Patrick Perini on 2/20/13.
//  Copyright (c) 2013 MegaBits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface NSDate (CWSunPositions)

#pragma mark - Accessor
/*!
 *  Returns the time, on this date, of the sunrise at the given location.
 *  @param location The location for which to calculate sunrise.
 *  @result The time, on thisdate, of the sunrise at the given location.
 */
- (NSDate *)sunriseTimeAtLocation:(CLLocation *)location;

/*!
 *  Returns the time, on this date, of the sunset at the given location.
 *  @param location The location for which to calculate sunset.
 *  @result The time, on thisdate, of the sunset at the given location.
 */
- (NSDate *)sunsetTimeAtLocation:(CLLocation *)location;

@end
