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
 *  DOCME
 */
- (NSDate *)sunriseTimeAtLocation:(CLLocation *)location;

/*!
 *  DOCME
 */
- (NSDate *)sunsetTimeAtLocation:(CLLocation *)location;

@end
