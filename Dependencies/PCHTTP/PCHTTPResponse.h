//
//  PCHTTPResponse.h
//
//  Created by Patrick Perini on 4/29/12.
//  Licensing information available in README.md
//

#import <Foundation/Foundation.h>

/*!
 Response codes that correspond to HTTP response codes.
 */
typedef enum
{
    // Informational
    PCHTTPShouldContinue                  = 100,
    PCHTTPWillSwitchProtocols             = 101,
    
    // Successful
    PCHTTPSuccess                         = 200,
    PCHTTPResourceWasCreated              = 201,
    PCHTTPRequestWasAccepted              = 202,
    PCHTTPNonAuthoritativeSuccess         = 203,
    PCHTTPNoContent                       = 204,
    PCHTTPContentWasReset                 = 205,
    PCHTTPPartialContent                  = 206,
    
    // Redirection
    PCHTTPMutltipleChoices                = 300,
    PCHTTPResourcePermanentlyMoved        = 301,
    PCHTTPResourceWasFound                = 302,
    PCHTTPSeeOtherResource                = 303,
    PCHTTPResourceHasNotBeenModified      = 304,
    PCHTTPRequestMustBeProxied            = 305,
    PCHTTPResourceHasBeenTemporarilyMoved = 307,
    
    // Client Errors
    PCHTTPBadRequest                      = 400,
    PCHTTPUnauthorizedRequest             = 401,
    PCHTTPPaymentIsRequired               = 402,
    PCHTTPAccessIsForbidden               = 403,
    PCHTTPResourceWasNotFound             = 404,
    PCHTTPMethodIsNotAllowed              = 405,
    PCHTTPContentIsNotAcceptable          = 406,
    PCHTTPProxyAuthenticationIsRequired   = 407,
    PCHTTPRequestTimedOut                 = 408,
    PCHTTPResourceConflict                = 409,
    PCHTTPResourceIsGone                  = 410,
    PCHTTPLengthHeaderIsRequired          = 411,
    PCHTTPPreconditionFailed              = 412,
    PCHTTPRequestEntityIsTooLarge         = 413,
    PCHTTPRequestURIIsTooLong             = 414,
    PCHTTPMediaTypeIsUnsupported          = 415,
    PCHTTPRequestedRangeIsUnsatisfiable   = 416,
    PCHTTPExpectationFailed               = 417,
    
    // Server Errors
    PCHTTPInternalServerError             = 500,
    PCHTTPResourceNotImpemented           = 501,
    PCHTTPServerIsABadGateway             = 502,
    PCHTTPServiceIsUnavailable            = 503,
    PCHTTPGatewayDidTimeout               = 504,
    PCHTTPHTTPVersionIsUnsupported        = 505
    
} PCHTTPResponseStatus;

/*!
 Represents a response for a single request.
 */
@interface PCHTTPResponse : NSObject

#pragma mark - Request Information
/// -------------------------------------
/// @name Request Information
/// -------------------------------------

/*!
 The URL of the request for which this is the response. 
 */
@property NSString *requestURL;

#pragma mark - Response Information
/// -------------------------------------
/// @name Response Information
/// -------------------------------------

/*!
 The HTTP status code.
 */
@property NSInteger status;

/*!
 The raw response data.
 */
@property NSData *data;

/*!
 The response data in string form.
 */
@property (readonly) NSString *string;

/*!
 The response data in JSON object form.
 */
@property (readonly) id object;

@end

typedef void(^PCHTTPResponseBlock)(PCHTTPResponse *response);
