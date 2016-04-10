//
//  BrandList.m
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import "BrandList.h"

@implementation BrandList

- (NSString*)getName:(NSUInteger)index {
    return [self.models[index] valueForKey:@"name"];
}

- (NSArray*)getModels {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in self.models) {
        [array addObject:dict[@"name"]];
    }
    return array;
}

@end
