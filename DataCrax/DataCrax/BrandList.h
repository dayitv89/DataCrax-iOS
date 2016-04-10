//
//  BrandList.h
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BrandList : JSONModel

@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSArray <Optional, NSDictionary*> *models;

- (NSString*)getName:(NSUInteger)index;
- (NSArray*)getModels;

@end
