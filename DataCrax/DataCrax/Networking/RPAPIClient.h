//
//  RPAPIClient.h
//  CoreKit
//
//  Copyright (c) 2013 rewardify. All rights reserved.
//

#import "AFNetworking.h"

#define pr(nsString,args...) gds_pt(nsString,args);
#define pro(object)     gds_pt(@"%@",object);



typedef void (^RPAPIResponseSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^RPAPIResponseFailureBlock)(AFHTTPRequestOperation *operation, NSArray *errors);
typedef void (^RPAPIResponseFailureIntermediateBlock)(AFHTTPRequestOperation *operation, NSError *errors);


typedef NS_ENUM(NSUInteger, RPHTTPMethodType) {
    kRPHTTPMethodTypeGet,
    kRPHTTPMethodTypePost,
    kRPHTTPMethodTypePut,
    kRPHTTPMethodTypeDelete,
    kRPHTTPMethodTypePatch,
    kRPHTTPMethodTypeHead
};


@interface RPAPIClient : AFHTTPRequestOperationManager

void gds_pt(NSString *format, ...);

+ (instancetype)sharedInstance;

/**
 *  Use for  Server API calls
 *  @param methodType    enum GET/POST/PUT/DELETE/PATCH/HEAD
 *  @param URIString     API URI path
 *  @param headers       modify api headers
 *  @param parameters    body of the request
 *  @param excludeErrors exclude http error code
 *  @param needAuthToken Add authorization token if user login reuired for the API
 *  @param success       Async sucess respones block
 *  @param failure       Async failure response block
 *  @return AFHTTPRequestOperation object
 */
- (AFHTTPRequestOperation *)method:(RPHTTPMethodType)methodType
                               URI:(NSString *)URIString
                           headers:(NSDictionary*)headers
                        parameters:(NSDictionary *)parameters
                     excludeErrors:(NSArray *)excludeErrors
                     needAuthToken:(BOOL)needAuthToken
                           success:(RPAPIResponseSuccessBlock)success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
