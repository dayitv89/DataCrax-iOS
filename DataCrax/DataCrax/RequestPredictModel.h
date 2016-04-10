//
//  RequestPredictModel.h
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, RequestPredictModelValidator) {
    kAllOk,
    kBrandNameMissing,
    kModelNameMissing,
    kModelYearMissing,
    kModelKmsMissing
};

@interface RequestPredictModel : JSONModel

@property (nonatomic, strong) NSString <Optional> *brandName;
@property (nonatomic, strong) NSString <Optional> *modelName;
@property (nonatomic, strong) NSString <Optional> *modelYear;
@property (nonatomic, strong) NSString <Optional> *modelKms;

- (RequestPredictModelValidator)validate;
- (NSDictionary*)params;

@end
