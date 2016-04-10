//
//  NSString+TrimmedString.m
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import "NSString+ExtendedString.h"

@implementation NSString (TrimmedString)

-(NSString *)getTrimmedString {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString *)getTrimmedStringWithCharacterSet:(NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:trimString]];
}

-(NSString *)removeWhiteSpaces {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(BOOL)present {
    return (self &&
            self.length &&
            [self isKindOfClass:[NSString class]] &&
            ![self isEqualToString:@"null"]);
}

-(BOOL) isEqualTo:(NSString *)string {
    if (self.present || string.present) {
        return [self isEqualToString:string];
    }
    return true;
}

@end
