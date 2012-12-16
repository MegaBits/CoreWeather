//
//  PCHTTPClient.h
//
//  Created by Patrick Perini on 4/29/12.
//  Licensing information available in README.md
//

#import <Foundation/Foundation.h>
#import "PCHTTPResponse.h"

/*!
 Allows users to make HTTP requests using a simple API.
 
 Requests can return response data inline and synchronously, or provide a callback block for asynchronous returns.
 */
@interface PCHTTPClient : NSObject

#pragma mark - Synchronous Methods
/// -------------------------------------
/// @name Making Synchronous Requests
/// -------------------------------------

/// @name Performing GET Requests

/*!
 Performs a synchronous GET request on the given URL.
 @param  url         The URL to request.
 @return The response for the request.
 */
+ (PCHTTPResponse *)get: (NSString *)url;

/*!
 Performs a synchronous GET request on the given URL.
 @param  url         The URL to request.
 @param  parameters  A dictionary of query string parameters.
 @return The response for the request.
 */
+ (PCHTTPResponse *)get: (NSString *)url parameters: (NSDictionary *)parameters;

/// @name Performing POST Requests

/*!
 Performs a synchronous POST request on the given URL.
 @param  url      The URL to request.
 @return The response for the request.
 */
+ (PCHTTPResponse *)post: (NSString *)url;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url         The URL to request.
 @param  parameters  A dictionary of query string parameters.
 @return The response for the request.
 */
+ (PCHTTPResponse *)post: (NSString *)url parameters: (NSDictionary *)parameters;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url      The URL to request.
 @param  payload  The object for the POST body.
 @return The response for the request.
 */
+ (PCHTTPResponse *)post: (NSString *)url payload: (id)payload;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url         The URL to request.
 @param  parameters  A dictionary of query string parameters.
 @param  payload     The object for the POST body.
 @return The response for the request.
 */
+ (PCHTTPResponse *)post: (NSString *)url parameters: (NSDictionary *)parameters payload: (id)payload;

/// @name Performing PUT Requests

/*!
 Performs a synchronous PUT request on the given URL.
 @param  url      The URL to request.
 @return The response for the request.
 */
+ (PCHTTPResponse *)put: (NSString *)url;

/*!
 Performs a synchronous PUT request on the given URL.
 @param  url         The URL to request.
 @param  parameters  A dictionary of query string parameters.
 @return The response for the request.
 */
+ (PCHTTPResponse *)put: (NSString *)url parameters: (NSDictionary *)parameters;

/*!
 Performs a synchronous PUT request on the given URL.
 @param  url      The URL to request.
 @param  payload  The object for the PUT body.
 @return The response for the request.
 */
+ (PCHTTPResponse *)put: (NSString *)url payload: (id)payload;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url         The URL to request.
 @param  parameters  A dictionary of query string parameters.
 @param  payload     The object for the POST body.
 @return The response for the request.
 */
+ (PCHTTPResponse *)put: (NSString *)url parameters: (NSDictionary *)parameters payload: (id)payload;

/// @name Performing DELETE Requests

/*!
 Performs a synchronous DELETE request on the given URL.
 @param  url         The URL to request.
 @return The response for the request.
 */
+ (PCHTTPResponse *)delete: (NSString *)url;

/*!
 Performs a synchronous DELETE request on the given URL.
 @param  url         The URL to request.
 @param  parameters  A dictionary of query string parameters.
 @return The response for the request.
 */
+ (PCHTTPResponse *)delete: (NSString *)url parameters: (NSDictionary *)parameters;

#pragma mark - Asynchronous Methods
/// -------------------------------------
/// @name Making Synchronous Requests
/// -------------------------------------

/// @name Performing GET Requests

/*!
 Performs a synchronous GET request on the given URL.
 @param  url           The URL to request.
 @param  responseBlock The response handler.
 */
+ (void)get: (NSString *)url withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous GET request on the given URL.
 @param  url           The URL to request.
 @param  parameters    A dictionary of query string parameters.
 @param  responseBlock The response handler.
 */
+ (void)get: (NSString *)url parameters: (NSDictionary *)parameters withBlock: (PCHTTPResponseBlock)responseBlock;

/// @name Performing POST Requests

/*!
 Performs a synchronous POST request on the given URL.
 @param  url           The URL to request.
 @param  responseBlock The response handler.
 */
+ (void)post: (NSString *)url withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url           The URL to request.
 @param  parameters    A dictionary of query string parameters.
 @param  responseBlock The response handler.
 */
+ (void)post: (NSString *)url parameters: (NSDictionary *)parameters withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url           The URL to request.
 @param  payload       The object for the POST body.
 @param  responseBlock The response handler.
 */
+ (void)post: (NSString *)url payload: (id)payload withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url           The URL to request.
 @param  parameters    A dictionary of query string parameters.
 @param  payload       The object for the POST body.
 @param  responseBlock The response handler.
 */
+ (void)post: (NSString *)url parameters: (NSDictionary *)parameters payload: (id)payload withBlock: (PCHTTPResponseBlock)responseBlock;

/// @name Performing PUT Requests

/*!
 Performs a synchronous PUT request on the given URL.
 @param  url           The URL to request.
 @param  responseBlock The response handler.
 */
+ (void)put: (NSString *)url withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous PUT request on the given URL.
 @param  url           The URL to request.
 @param  parameters    A dictionary of query string parameters.
 @param  responseBlock The response handler.
 */
+ (void)put: (NSString *)url parameters: (NSDictionary *)parameters withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous PUT request on the given URL.
 @param  url           The URL to request.
 @param  payload       The object for the PUT body.
 @param  responseBlock The response handler.
 */
+ (void)put: (NSString *)url payload: (id)payload withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous POST request on the given URL.
 @param  url           The URL to request.
 @param  parameters    A dictionary of query string parameters.
 @param  payload       The object for the POST body.
 @param  responseBlock The response handler.
 */
+ (void)put: (NSString *)url parameters: (NSDictionary *)parameters payload: (id)payload withBlock: (PCHTTPResponseBlock)responseBlock;

/// @name Performing DELETE Requests

/*!
 Performs a synchronous DELETE request on the given URL.
 @param  url           The URL to request.
 @param  responseBlock The response handler.
 */
+ (void)delete: (NSString *)url withBlock: (PCHTTPResponseBlock)responseBlock;

/*!
 Performs a synchronous DELETE request on the given URL.
 @param  url           The URL to request.
 @param  parameters    A dictionary of query string parameters.
 @param  responseBlock The response handler.
 */
+ (void)delete: (NSString *)url parameters: (NSDictionary *)parameters withBlock: (PCHTTPResponseBlock)responseBlock;

@end