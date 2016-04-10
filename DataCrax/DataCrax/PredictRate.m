//
//  PredictRate.m
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import "PredictRate.h"

@implementation PredictRate

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"predicted value":@"arrayList"}];
}

- (NSNumber*)price {
    return self.arrayList[0];
}

- (NSString*)pricePretty {
    return [NSString stringWithFormat:@"₹ %.2f", self.price.floatValue];
}

@end
