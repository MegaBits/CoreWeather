//
//  PCHTTPSerializer.h
//
//  Created by Patrick Perini on 4/30/12.
//  Licensing information available in README.md
//

#import <Foundation/Foundation.h>

/*!
 Objects should conform to this protocol if they want to be used as payload objects in POST and PUT requests.
 */
@protocol PCHTTPSerializableObject <NSObject>

@required
/*!
 The custom NSData representing this object.
 @return An NSData instance that is suitable for transfer in POST and PUT requests.
 */
- (NSData *)serializedData;

@end

/*!
 A simple interface for doing miscellaneous serialization and deserialization within PCHTTP.
 */
@interface PCHTTPSerializer : NSObject

/*!
 Turns {"key1": "val1", "key2": "val2"} into "key1=val1&key2=val2".
 @param  dictionary The dictionary to convert.
 @return The query string evaluated from the given dictionary.
 */
+ (NSString *)keyValueEvaluateDictionary: (NSDictionary *)dictionary;

@end
