//
//  Setting1ViewController.h
//  UHFSample
//
//  Created by Gianni on 2019/4/12.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Setting1ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIPickerView *pickerTriggerType;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerTarget;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerSession;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerBuzzerOperMode;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerCtrlBuzzer;

@property (strong, nonatomic) IBOutlet UISlider *sliderQ;

@property (strong, nonatomic) IBOutlet UISlider *sliderRFPower;

@property (strong, nonatomic) IBOutlet UISlider *sliderSensitivity;


@property (strong, nonatomic) IBOutlet UITextField *txtTagPresentedEventThreshold;

@property (strong, nonatomic) IBOutlet UITextField *txtTagRemovedEventThreshold;
@end

NS_ASSUME_NONNULL_END
