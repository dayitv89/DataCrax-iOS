//
//  Copyright (c) 2013 rewardify. All rights reserved.
//

#import "RPAPIClient.h"
#import "RPError.h"
#import "RPErrorManager.h"
#import "APIList.h"

#define ERROR_DOMAIN [[NSBundle mainBundle] bundleIdentifier]

@interface RPAPIClient ()
@property (nonatomic, strong) RPErrorManager *errorManager;
@end


@implementation RPAPIClient

void gds_pt(NSString *format, ...) {
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
#endif
}

+ (instancetype)sharedInstance {
    static dispatch_once_t oncePredicate = 0;
    __strong static id _sharedInstance = nil;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.errorManager = [[RPErrorManager alloc] init];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self setHeaders:nil];
    self.requestSerializer.HTTPShouldHandleCookies = NO;
    self.securityPolicy.allowInvalidCertificates = YES;
    return self;
}

- (NSDictionary *)defaultHeaders {
#warning FIXME: user-agent not configured
    return @{
             @"Accept"                  :       @"text/html",
             @"Accept-Language"         :       @"en",
             @"Accept-Timezone"         :       [[NSTimeZone localTimeZone] name],
             @"Content-Type"            :       @"application/json",
             @"User-Agent"              :       @""
             };
}

#pragma mark - API call handler
- (AFHTTPRequestOperation *)method:(RPHTTPMethodType)methodType
                               URI:(NSString *)URIString
                           headers:(NSDictionary*)headers
                        parameters:(NSDictionary *)parameters
                     excludeErrors:(NSArray *)excludeErrors
                     needAuthToken:(BOOL)needAuthToken
                           success:(RPAPIResponseSuccessBlock)success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    RPError *errorFailure;
    if ([self shouldAuthorizeHeader:needAuthToken]) {
//        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            RPAPIResponseFailureIntermediateBlock responseFailureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(operation, error);
            };
            [self setHeaders:headers];
            AFHTTPRequestOperation *httpRequestOperation = nil;
            switch (methodType) {
                case kRPHTTPMethodTypePost:
                {
                    httpRequestOperation = [super POST:URIString
                                            parameters:parameters
                                               success:success
                                               failure:responseFailureBlock];
                }
                    break;
                case kRPHTTPMethodTypePut:
                {
                    httpRequestOperation = [super PUT:URIString
                                           parameters:parameters
                                              success:success
                                              failure:responseFailureBlock];
                }
                    break;
                case kRPHTTPMethodTypeDelete:
                {
                    httpRequestOperation = [super DELETE:URIString
                                              parameters:parameters
                                                 success:success
                                                 failure:responseFailureBlock];
                }
                    break;
                case kRPHTTPMethodTypePatch:
                {
                    httpRequestOperation = [super PATCH:URIString
                                             parameters:parameters
                                                success:success
                                                failure:responseFailureBlock];
                }
                    break;
                case kRPHTTPMethodTypeHead:
                {
                    httpRequestOperation = [super HEAD:URIString
                                            parameters:parameters
                                               success:^(AFHTTPRequestOperation *operation) {
                                                   success(operation, nil);
                                               }
                                               failure:responseFailureBlock];
                }
                    break;
                case kRPHTTPMethodTypeGet:
                default:
                {
                    httpRequestOperation = [super GET:URIString
                                           parameters:parameters
                                              success:success
                                              failure:responseFailureBlock];
                }
                    break;
            }
            return httpRequestOperation;
//        } else {
//#warning TODO: make Internet reachability error and post
//            errorFailure = [RPError errorWithDomain:ERROR_DOMAIN
//                                               code:0
//                                           userInfo:@{NSLocalizedDescriptionKey:@"Internet reachability error"}];
//            [self.errorManager handleNotReachableError];
//        }
    } else {
#warning TODO: make user unautherized error and post
        errorFailure = [RPError errorWithDomain:ERROR_DOMAIN
                                           code:401
                                       userInfo:@{NSLocalizedDescriptionKey:@"User Authentication Problem"}];
        [self.errorManager handleUserUnAuthorisedError];
    }
    failure(nil, @[errorFailure]);
    return nil;
}

#pragma mark - API call halper
- (BOOL)shouldAuthorizeHeader:(BOOL)needAuthToken {
    [self.requestSerializer clearAuthorizationHeader];
    if (needAuthToken) {
#warning FIXME: pass auth token here
#warning TODO: return value must check that valid auth token available or not and then return value
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"AUTH_TOKEN"
                                                               password:@"X"];
        return YES;
    } else {
        return YES;
    }
}

- (void)setHeaders:(NSDictionary*)headers {
    NSMutableDictionary *newHeaders = [[self defaultHeaders] mutableCopy];
    if (headers) {
        [newHeaders addEntriesFromDictionary:headers];
    }
    [self.requestSerializer setValue:newHeaders forKey:@"mutableHTTPRequestHeaders"];
}

- (void)runFailureBlock:(RPAPIResponseFailureBlock)failure
               andError:(NSError *)error
           andOperation:(AFHTTPRequestOperation *)operation
       andExcludeErrors:(NSArray *)excludeErrors {
    NSArray *errors = [self.errorManager errorsWithError:error
                                               operation:operation
                                           excludeErrors:excludeErrors];
    if (failure) {
        failure(operation, errors);
    }
}

@end
