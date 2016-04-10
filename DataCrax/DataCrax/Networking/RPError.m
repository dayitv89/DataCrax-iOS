//
//  Copyright (c) 2013 rewardify. All rights reserved.
//

#import "RPError.h"

#define FBAccessTokenErrorDomain @"com.rewardify.fbaccesstoken.notfound"
#define FBAccessTokenErrorCode -1

@interface RPError()

@property (nonatomic, strong) NSArray *wellKnownErrors;

@end


@implementation RPError

+ (NSMutableArray *)errorsWithResponse:(NSDictionary *)response
                                  code:(NSInteger)errorCode {
    NSDictionary *errorDictionary = [response objectForKey:@"errors"];
    NSMutableArray *errors;
    for (NSString *key in errorDictionary) {
        RPError *error = [[RPError alloc] initWithDomain:@"com.rewardify.network.ValidationError"
                                                    code:errorCode
                                                userInfo:errorDictionary[key]];
        error.errorAgent = key;
        [errors addObject:error];
    }
    return errors;
}

+ (instancetype)errorWithError:(NSError *)error {
    return [[RPError alloc] initWithDomain:error.domain
                                      code:error.code
                                  userInfo:error.userInfo
                                errorAgent:nil];
}

- (instancetype) initWithDomain:(NSString *)errorDomain
                           code:(NSInteger)errorCode
                       userInfo:(NSDictionary *)userInfo {

    self = [self initWithDomain:errorDomain
                           code:errorCode
                       userInfo:userInfo
                     errorAgent:nil];
    return self;
}

- (instancetype) initWithDomain:(NSString *)errorDomain
                           code:(NSInteger)errorCode
                       userInfo:(NSDictionary *)userInfo
                     errorAgent:(NSString *)errorAgent {

    self = [super initWithDomain:errorDomain
                            code:errorCode
                        userInfo:userInfo];
    self.errorAgent = errorAgent;
    return self;
}

+ (NSError *)getFBSDKAccessTokenError {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Unable to get FB Access Token"
                                                         forKey:NSLocalizedDescriptionKey];
    NSError *error = [[NSError alloc] initWithDomain:FBAccessTokenErrorDomain
                                                code:FBAccessTokenErrorCode
                                            userInfo:userInfo];
    return error;
}

@end
