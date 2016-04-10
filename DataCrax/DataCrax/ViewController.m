//
//  ViewController.m
//  DataCrax
//
//  Created by Gaurav on 10/04/16.
//  Copyright © 2016 Softex Lab. All rights reserved.
//

#import "ViewController.h"
#import "APIList.h"
#import "BrandList.h"
#import "JVFloatLabeledTextField.h"
#import "NSString+ExtendedString.h"
#import "PredictRate.h"
#import "RequestPredictModel.h"
#import "RPAPIClient.h"
#import "RPErrorManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSUInteger, PickerType) {
    kNone,
    kBrandName,
    kModelName,
    kModelYear,
};

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    __weak IBOutlet JVFloatLabeledTextField *textFieldBrandName;
    __weak IBOutlet JVFloatLabeledTextField *textFieldModelName;
    __weak IBOutlet JVFloatLabeledTextField *textFieldModelYear;
    __weak IBOutlet JVFloatLabeledTextField *textFieldModelKms;
    
    __weak IBOutlet UIView *pickerView;
    __weak IBOutlet UIPickerView *picker;
    
    __weak IBOutlet UIButton *btnRefresh;
    __weak IBOutlet UIButton *btnPredict;
    __weak IBOutlet UIButton *btnClearAll;
    
    NSArray <Optional, BrandList*> *arrBrandList;
    NSArray *pickerData;
    RequestPredictModel *requestPredictModel;
    NSInteger selectedIndex;
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = kNone;
    requestPredictModel = [[RequestPredictModel alloc] init];
    
    pickerView.hidden = YES;
    [self btnRefreshTapped:btnRefresh];
}

#pragma mark - Btn Tapped
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)btnRefreshTapped:(id)sender {
    [self dismissKeyboard:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RPAPIClient sharedInstance] method:kRPHTTPMethodTypeGet
                                     URI:API_BRAND_LIST
                                 headers:nil
                              parameters:nil
                           excludeErrors:nil
                           needAuthToken:NO
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     arrBrandList = (NSArray<Optional, BrandList*>*)[BrandList arrayOfModelsFromData:responseObject error:nil];
                                     pr(@"res %@", arrBrandList);
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     pr(@"err %@", error);
                                     [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] show];
                                 }];
}

- (IBAction)btnClearAllTapped:(id)sender {
    [self dismissKeyboard:nil];
    textFieldBrandName.text = requestPredictModel.brandName = nil;
    textFieldModelName.text = requestPredictModel.modelName = nil;
    textFieldModelYear.text = requestPredictModel.modelYear = nil;
    textFieldModelKms.text = requestPredictModel.modelKms = nil;
}

- (IBAction)btnPredictTapped:(id)sender {
    [self dismissKeyboard:nil];
    if ([self validate]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RPAPIClient sharedInstance] method:kRPHTTPMethodTypeGet
                                         URI:API_PRICE_PREDICT
                                     headers:nil
                                  parameters:requestPredictModel.params
                               excludeErrors:nil
                               needAuthToken:NO
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         PredictRate *predictRate = [[PredictRate alloc] initWithData:responseObject error:nil];
                                         pr(@"res %@", predictRate.pricePretty);
                                         [[[UIAlertView alloc] initWithTitle:@"Your bike price is"
                                                                     message:predictRate.pricePretty
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         pr(@"err %@", error);
                                         [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:error.localizedDescription
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil] show];
                                     }];

    }
}

- (BOOL)validate {
    if (textFieldModelKms.text.present) {
        requestPredictModel.modelKms = textFieldModelKms.text;
    }
    if (requestPredictModel) {
        NSString *msg;
        switch (requestPredictModel.validate) {
            case kAllOk:
                return YES;
                break;
            case kBrandNameMissing:
                msg = @"Select your brand first.";
                break;
            case kModelNameMissing:
                msg = @"Select your model first.";
                break;
            case kModelYearMissing:
                msg = @"Select your model purchased year.";
                break;
            case kModelKmsMissing:
                msg = @"Enter how much your bike already being runned.";
                break;
            default:
                msg = @"something is missing";
                break;
        }
        [[[UIAlertView alloc] initWithTitle:@"Validation Error"
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    return NO;
}

#pragma mark picker Btns
- (IBAction)btnPreTapped:(id)sender {
    [self getPickerValue];
    selectedIndex = selectedIndex == kNone ? kNone : selectedIndex-1;
    [self managePickers];
}

- (IBAction)btnNextTapped:(id)sender {
    [self getPickerValue];
    if (selectedIndex == kModelYear) {
        [textFieldModelKms becomeFirstResponder];
        selectedIndex = kNone;
    } else {
        selectedIndex++;
    }
    [self managePickers];
}

- (IBAction)btnDoneTapped:(id)sender {
    [self getPickerValue];
    [self btnNextTapped:nil];
}

- (void)managePickers {
    switch (selectedIndex) {
        case kBrandName: [self setBrandArray]; break;
        case kModelName: [self setModelArray]; break;
        case kModelYear: [self setModelYearArray]; break;
        case kNone:
        default:
            pickerView.hidden = YES;
            return;
            break;
    }
    [self setPicker];
}

- (void)setPicker {
    switch (selectedIndex) {
        case kBrandName:
        case kModelName:
        case kModelYear:
            pickerView.hidden = NO;
            [self dismissKeyboard:nil];
            [picker reloadAllComponents];
            break;
        case kNone:
        default:
            pickerView.hidden = YES;
            break;
    }
}

- (void)getPickerValue {
    switch (selectedIndex) {
        case kNone:
            pickerView.hidden = YES;
            break;
        case kBrandName:
            requestPredictModel.brandName = pickerData[[picker selectedRowInComponent:0]];
            textFieldBrandName.text = requestPredictModel.brandName;
            textFieldModelName.text = requestPredictModel.modelName = nil;
            break;
        case kModelName:
            requestPredictModel.modelName = pickerData[[picker selectedRowInComponent:0]];
            textFieldModelName.text = requestPredictModel.modelName;
            break;
        case kModelYear:
            requestPredictModel.modelYear = pickerData[[picker selectedRowInComponent:0]];
            textFieldModelYear.text = requestPredictModel.modelYear;
            break;
        default:
            break;
    }
}

#pragma mark - Picker 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    return pickerData[row];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == textFieldBrandName) {
        selectedIndex = kBrandName;
    } else if (textField == textFieldModelName){
        selectedIndex = kModelName;
    } else if (textField == textFieldModelYear) {
        selectedIndex = kModelYear;
    } else if (textField == textFieldModelKms) {
        return YES;
    }
    [self managePickers];
    return NO;
}

- (void)setBrandArray {
    pickerData = [arrBrandList valueForKey:@"name"];
}

- (void)setModelArray {
    if (requestPredictModel.brandName) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name = %@", requestPredictModel.brandName];
        NSArray *arrayFilter = [arrBrandList filteredArrayUsingPredicate:predicate];
        if (arrayFilter && arrayFilter.count) {
            pickerData = [(BrandList*)arrayFilter[0] getModels];
        }
    } else {
        [self textFieldShouldBeginEditing:textFieldBrandName];
    }
    
}

- (void)setModelYearArray {
    NSMutableArray *array = [NSMutableArray new];
    for (NSUInteger i = 2000; i < 2016; i++) {
        [array addObject:[@(i) stringValue]];
    }
    pickerData = array;
}

@end
