//
//  PredictRate.h
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PredictRate : JSONModel

@property (nonatomic, strong) NSArray <Optional> *arrayList;

- (NSNumber*)price;
- (NSString*)pricePretty;

@end
