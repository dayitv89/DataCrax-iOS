//
//  RequestPredictModel.m
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import "RequestPredictModel.h"
#import "NSString+ExtendedString.h"

@implementation RequestPredictModel

- (RequestPredictModelValidator)validate {
    if (!self.brandName.present) {
        return kBrandNameMissing;
    } else if (!self.modelName.present) {
        return kModelNameMissing;
    } else if (!self.modelYear.present) {
        return kModelYearMissing;
    } else if (!self.modelKms.present) {
        return kModelKmsMissing;
    } else {
        return kAllOk;
    }
}

- (NSDictionary*)params {
    if (self.validate == kAllOk) {
        return @{@"brand":self.brandName,
                 @"model":self.modelName,
                 @"year":self.modelYear,
                 @"kms": self.modelKms};
    }
    return nil;
}

@end
