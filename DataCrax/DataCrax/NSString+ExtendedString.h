//
//  NSString+TrimmedString.h
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TrimmedString)

-(NSString *)getTrimmedString;
-(NSString *)getTrimmedStringWithCharacterSet:(NSString *)trimString;
-(NSString *)removeWhiteSpaces;
-(BOOL)present;
-(BOOL) isEqualTo:(NSString *)string;

@end
