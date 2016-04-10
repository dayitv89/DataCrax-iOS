//
//  RPError.h
//  rewardifyCoreKit
//
//  Copyright (c) 2013 rewardify. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Possible error agents. Error agents are the fields/params sent in an API Call that might be the reason of thrown error.
 */
static NSString *const kRPErrorAgentEmail       = @"email";
static NSString *const kRPErrorAgentPassword    = @"password";
static NSString *const kRPErrorAgentFirstName   = @"firstName";
static NSString *const kRPErrorAgentLastName    = @"lastName";
static NSString *const kRPErrorAgentBirthday    = @"birthDay";
static NSString *const kRPErrorAgentAnniversary = @"anniversary";

@interface RPError : NSError

@property (nonatomic, strong) NSString *errorAgent;

/**
 *  Designated initializer to create RPError objects. RPError has an extra property errorAgent that can be used to track the
 *  parameter that is root cause of error.
 *  @param errorDomain Error Domain.
 *  @param errorCode   Error Code.
 *  @param userInfo    Dictionary containing the string which will be used as Localized Description.
 *  @param errorAgent  Error Agent.
 *  @return RPError instance.
 */
- (instancetype) initWithDomain:(NSString *)errorDomain
                           code:(NSInteger)errorCode
                       userInfo:(NSDictionary *)userInfo
                     errorAgent:(NSString *)errorAgent NS_DESIGNATED_INITIALIZER;

/**
 *  Class method to get Array of RPError objects based on array of error object in response JSON.
 *  @param response  AFHTTPRequestOperation's response object.
 *  @param errorCode AFHTTPRequestOperation's Error Code.
 *  @return Array of RPError objects.
 */
+ (NSMutableArray *)errorsWithResponse:(NSDictionary *)response
                                  code:(NSInteger)errorCode;

/**
 *  Create RPError object from NSError object.
 *  @param error NSError object.
 *  @return RPError object.
 */
+ (instancetype)errorWithError:(NSError *)error;

/**
 *  Called when facebook token gets expired.
 *  @return FBSDKAccessToken.
 */
+ (NSError *)getFBSDKAccessTokenError;

@end
