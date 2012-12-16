//
//  NSString+CWHashing.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 12/16/12.
//  Copyright (c) 2012 pcperini. All rights reserved.
//

#import "NSString+CWHashing.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (CWHashing)

- (NSString *)md5Hash
{
    const char *utf8String = [self UTF8String];
    unsigned char hashResult[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(utf8String, strlen(utf8String), hashResult);
    
    NSMutableString *hashedString = [NSMutableString string];
    for (int byteIndex = 0; byteIndex < CC_MD5_DIGEST_LENGTH; byteIndex++)
    {
        [hashedString appendFormat: @"%02X", hashResult[byteIndex]];
    }
    
    return hashedString;
}

@end
