//
//  Copyright (c) 2013 rewardify. All rights reserved.
//

#import "RPErrorManager.h"
#import "APIList.h"

@implementation RPErrorManager

- (NSArray <RPError*>*)errorsWithError:(NSError *)error
                             operation:(AFHTTPRequestOperation *)operation
                         excludeErrors:(NSArray *)excludeErrors {
    if ([self catchWellKnownHTTPErrors:error excludeErrors:excludeErrors]) {
        return @[[RPError errorWithError:error]];
    } else if ([self catchUnsupportedFormatError:error operation:operation]) {
        return @[[RPError errorWithError:error]];
    } else {
        return [self getRPErrorsFromResponse:operation
                 error:error];
    }
}

- (BOOL)catchUnsupportedFormatError:(NSError *)error operation:(AFHTTPRequestOperation *)operation {
    BOOL unsupportedFomatError = false;
    switch (error.code) {
        case NSURLErrorCannotDecodeContentData:
        case NSURLErrorCannotParseResponse:
        case NSURLErrorCannotDecodeRawData:
            unsupportedFomatError = true;
            [self handleUnsupportedFormatError:error operation:operation];
            break;
        default:
            break;
    }
    return unsupportedFomatError;
}

- (void)handleUnsupportedFormatError:(NSError *)error operation:(AFHTTPRequestOperation *) operation {
    NSString *dataString = [NSString stringWithFormat:@"URL:%@ ErrorCode:%ld response: %@",operation.request.URL.absoluteString, (long)error.code, operation.responseString];
#warning TODO: Post unsupported format notification
}

- (NSArray *)getRPErrorsFromResponse:(AFHTTPRequestOperation *)operation
                               error:(NSError *)error {
    return @[operation.responseObject];
#warning FIXME: make error object array well defined
//    [RPError errorsWithResponse:operation.responseObject code:error.code];
}

- (BOOL)catchWellKnownHTTPErrors:(NSError *)error
                   excludeErrors:(NSArray *)excludeErrors {

    BOOL wellKnownError = FALSE;
    if (![excludeErrors containsObject:[NSString stringWithFormat:@"%ld",(long)error.code]]) {
        switch (error.code) {
            case 500:
                wellKnownError = TRUE;
                [self handleInternalServerError];
                break;
            case 401:
                wellKnownError = TRUE;
                [self handleUserUnAuthorisedError];
                break;
            case 408:
                wellKnownError = TRUE;
                [self handleServerTimeOutError];
                break;
            case 0:
                wellKnownError = TRUE;
                [self handleNotReachableError];
                break;
            default:
                break;
        }
    }
    return false;
}

- (void)handleNotReachableError {
    [[NSNotificationCenter defaultCenter] postNotificationName:RPAPIClientNotReachableErrorNotification
                                                        object:self];
    [self postWellKnownErrorNotification];
}

- (void)handleInternalServerError {
    [[NSNotificationCenter defaultCenter] postNotificationName:RPAPIClientInternalServerErrorNotification
                                                        object:self];
    [self postWellKnownErrorNotification];
}

- (void)handleUserUnAuthorisedError {
    [[NSNotificationCenter defaultCenter] postNotificationName:RPAPIClientUserUnauthorizedErrorNotification
                                                        object:self];
    [self postWellKnownErrorNotification];
#warning TODO: Logout user when this error is traced.
}

- (void)handleServerTimeOutError {
    [[NSNotificationCenter defaultCenter] postNotificationName:RPAPIClientServerTimeoutErrorNotification
                                                        object:self];
    [self postWellKnownErrorNotification];
}

- (void)postWellKnownErrorNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:RPAPIClientWellKnownErrorNotification
                                                        object:self];
    [self postWellKnownErrorNotification];
}

@end
