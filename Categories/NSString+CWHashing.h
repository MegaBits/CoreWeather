//
//  NSString+CWHashing.h
//  CoreWeatherTests
//
//  Created by Patrick Perini on 12/16/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CWHashing)

/*!
    Returns an MD5 hash of this string.
    @return An MD5 hash of this string.
 */
- (NSString *)md5Hash;

@end
