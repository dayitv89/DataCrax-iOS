//
//  RPErrorManager.h
//  RPnchhCoreKit
//
//  Copyright (c) 2013 rewardify. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "RPError.h"

@interface RPErrorManager : NSObject

/**
 *  Gives array of RPError class instances. In case of defined HTTP errors array will contain single object and errorAgent of this error will be nil.
 *  In case of Bad Request errors, Unprocessable Entity errors errorAgent will be the field that is root of error.
 *  @param error         Response Error provided by API Client.
 *  @param operation     AFHTTPRequest operation.
 *  @param excludeErrors Array of http error codes that should be excluded.
 *  @return Array of RPError objects.
 */
- (NSArray <RPError*>*)errorsWithError:(NSError *)error
                             operation:(AFHTTPRequestOperation *)operation
                         excludeErrors:(NSArray *)excludeErrors;

- (void)handleNotReachableError;

- (void)handleUserUnAuthorisedError;

@end
