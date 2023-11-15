//
//  NewReadWriteTagViewController.m
//  UHFSample
//
//  Created by JangJack on 2020/8/22.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import "NewReadWriteTagViewController.h"
#import "TagItemTableViewCell.h"
#import <UHFSDK/GNPTagInfo.h>
#import <UHFSDK/TS100.h>
#import <UHFSDK/GNPLockInfos.h>
#import "DevDetailTabBarViewController.h"
#import "NewDevConnStatusViewController.h"
#import "MBProgressHUD.h"

#import <UHFSDK/UntraceableParameter.h>
#import <UHFSDK/QTWriteParameter.h>
#import <UHFSDK/QTReadParameter.h>
#import <UHFSDK/ShortRangeParameter.h>

@interface NewReadWriteTagViewController () <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,IUHFDeviceListener>
@property (weak, nonatomic) IBOutlet UITextField *passwordFlagForWriteEPC_1;
@property (weak, nonatomic) IBOutlet UITextField *epcForWriteEPC_1;

@property (weak, nonatomic) IBOutlet UITextField *pc_epc_ForWriteEPC_2;
@property (weak, nonatomic) IBOutlet UITextField *passwordForWriteEPC_2;
@property (weak, nonatomic) IBOutlet UITextField *epcForWriteEPC_2;

@property (weak, nonatomic) IBOutlet UITextField *selectedEPCForReadTag_1;
@property (weak, nonatomic) IBOutlet UITextField *passwordFlagForReadTag_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForReadTag_1;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForReadTag_1;
@property (weak, nonatomic) IBOutlet UITextField *readLengthForReadTag_1;

@property (weak, nonatomic) IBOutlet UITextField *passwordFlagForReadTag_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForReadTag_2;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForReadTag_2;
@property (weak, nonatomic) IBOutlet UITextField *readLengthForReadTag_2;

@property (weak, nonatomic) IBOutlet UITextField *selectedEPCForReadTag_3;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForReadTag_3;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForReadTag_3;
@property (weak, nonatomic) IBOutlet UITextField *readLengthForReadTag_3;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForReadTag_4;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForReadTag_4;
@property (weak, nonatomic) IBOutlet UITextField *readLengthForReadTag_4;

@property (weak, nonatomic) IBOutlet UITextField *selectedEPCForWriteTag_1;
@property (weak, nonatomic) IBOutlet UITextField *passwordFlagForWriteTag_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForWriteTag_1;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForWriteTag_1;
@property (weak, nonatomic) IBOutlet UITextField *dataToWriteForWriteTag_1;

@property (weak, nonatomic) IBOutlet UITextField *passwordFlagforWriteTag_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForWriteTag_2;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForWriteTag_2;
@property (weak, nonatomic) IBOutlet UITextField *dateToWriteForWriteTag_2;

@property (weak, nonatomic) IBOutlet UITextField *selectedEPCForWriteTag_3;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForWriteTag_3;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForWriteTag_3;
@property (weak, nonatomic) IBOutlet UITextField *dataToWriteForWriteTag_3;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForWriteTag_4;
@property (weak, nonatomic) IBOutlet UITextField *startAddressForWriteTag_4;
@property (weak, nonatomic) IBOutlet UITextField *dateToWriteForWriteTag_4;

@property (weak, nonatomic) IBOutlet UITextField *accessPasswordForProtectTagPrivacy_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerFlagUForProtectTagPrivacy_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerEPCForProtectTagPrivacy_1;
@property (weak, nonatomic) IBOutlet UISlider *sliderEPCLengthForProtectTagPrivacy_1;
@property (weak, nonatomic) IBOutlet UILabel *labEPCLengthForProtectTagPrivacy_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTIDForProtectTagPrivacy_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerUserForProtectTagPrivacy_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerRangeForProtectTagPrivacy_1;

@property (weak, nonatomic) IBOutlet UITextField *accessPasswordForProtectTagPrivacy_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerAccessOptionForProtectTagPrivacy_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerQT_SRForProtectTagPrivacy_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerQT_MEMForProtectTagPrivacy_2;

@property (weak, nonatomic) IBOutlet UITextField *accessPasswordForProtectTagPrivacy_3;

@property (weak, nonatomic) IBOutlet UITextField *accessPasswordForProtectTagPrivacy_4;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerShortRangeTypeForProtectTagPrivacy_4;

@property (weak, nonatomic) IBOutlet UITextField *passwordForReadTagEx_1;

@property (weak, nonatomic) IBOutlet UITextField *passwordForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerEpcTypeForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UITextField *barcodeForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerFilterForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCompanyPrefixLengthForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UIStackView *stackFilterForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UIStackView *stackCompanyPrefixLengthForWriteTagEx_1;
@property (weak, nonatomic) IBOutlet UIStackView *stackSerialNumberForWriteTagEx_1;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerEpcTypeForWriteTagEx_2;
@property (weak, nonatomic) IBOutlet UITextField *barcodeForWriteTagEx_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerFilterForWriteTagEx_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCompanyPrefixLengthForWriteTagEx_2;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberForWriteTagEx_2;
@property (weak, nonatomic) IBOutlet UIStackView *stackFilterForWriteTagEx_2;
@property (weak, nonatomic) IBOutlet UIStackView *stackCompanyPrefixLengthForWriteTagEx_2;
@property (weak, nonatomic) IBOutlet UIStackView *stackSerialNumberForWriteTagEx_2;

@property (weak, nonatomic) IBOutlet UITextField *passwordFlagForLockTag_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForLockTag_1;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLockActionForLockTag_1;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForLockTag_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLockActionForLockTag_2;

@property (weak, nonatomic) IBOutlet UITextField *passwordFlagForLockTag_3;
@property (weak, nonatomic) IBOutlet UITextField *selectedPcEpcForLockTag_3;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForLockTag_3;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLockActionForLockTag_3;

@property (weak, nonatomic) IBOutlet UITextField *selectedPcEpcForLockTag_4;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMemoryBankForLockTag_4;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLockActionForLockTag_4;

@property (weak, nonatomic) IBOutlet UITextField *accessPasswordForKillTag_1;
@property (weak, nonatomic) IBOutlet UITextField *killPasswordForKillTag_1;

@property (weak, nonatomic) IBOutlet UITextField *killPasswordForKillTag_2;

@property (strong, nonatomic) IBOutlet UIView *customView;

@end

@implementation NewReadWriteTagViewController {
    NSMutableArray* allTagItems;
    UHFDevice* passDev;
    NewDevConnStatusViewController* childViewController;
    
    NSArray *memoryBankForReadTag_1;
    NSArray *memoryBankForReadTag_2;
    NSArray *memoryBankForReadTag_3;
    NSArray *memoryBankForReadTag_4;
    NSArray *memoryBankForWriteTag_1;
    NSArray *memoryBankForWriteTag_2;
    NSArray *memoryBankForWriteTag_3;
    NSArray *memoryBankForWriteTag_4;
    NSArray *flagUForProtectTagPrivacy_1;
    NSArray *EPCForProtectTagPrivacy_1;
    NSArray *TIDForProtectTagPrivacy_1;
    NSArray *userForProtectTagPrivacy_1;
    NSArray *rangeForProtectTagPrivacy_1;
    NSArray *accessOptionForProtectTagPrivacy_2;
    NSArray *QT_SRForProtectTagPrivacy_2;
    NSArray *QT_MEMForProtectTagPrivacy_2;
    NSArray *shortRangeTypeForProtectTagPrivacy_4;
    NSArray *memoryBankForLockTag_1;
    NSArray *lockActionForLockTag_1;
    NSArray *memoryBankForLockTag_2;
    NSArray *lockActionForLockTag_2;
    NSArray *memoryBankForLockTag_3;
    NSArray *lockActionForLockTag_3;
    NSArray *memoryBankForLockTag_4;
    NSArray *lockActionForLockTag_4;
    NSArray *epcTypeForWriteTagEx_1;
    NSArray *filterForWriteTagEx_1;
    NSArray *companyPrefixLengthForWriteTagEx_1;
    NSArray *epcTypeForWriteTagEx_2;
    NSArray *filterForWriteTagEx_2;
    NSArray *companyPrefixLengthForWriteTagEx_2;

    BOOL keyboardIsUp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (passDev) {
        [passDev setListener:self];
        
        
        
    }
    allTagItems = [[NSMutableArray alloc]init];
    [childViewController clearLog];
    
    memoryBankForReadTag_1 = @[@"RESERVE", @"EPC", @"TID", @"USER"];
    memoryBankForReadTag_2 = @[@"RESERVE", @"EPC", @"TID", @"USER"];
    memoryBankForReadTag_3 = @[@"RESERVE", @"EPC", @"TID", @"USER"];
    memoryBankForReadTag_4 = @[@"RESERVE", @"EPC", @"TID", @"USER"];
    memoryBankForWriteTag_1 = @[@"RESERVE", @"EPC", @"USER"];
    memoryBankForWriteTag_2 = @[@"RESERVE", @"EPC", @"USER"];
    memoryBankForWriteTag_3 = @[@"RESERVE", @"EPC", @"USER"];
    memoryBankForWriteTag_4 = @[@"RESERVE", @"EPC", @"USER"];
    flagUForProtectTagPrivacy_1 = @[@"DEASSERT_U", @"ASSERT_U"];
    EPCForProtectTagPrivacy_1 = @[@"SHOW", @"HIDE"];
    TIDForProtectTagPrivacy_1 = @[@"SHOW", @"HIDE_SOME", @"HIDE_ALL"];
    userForProtectTagPrivacy_1 = @[@"VIEW", @"HIDE"];
    rangeForProtectTagPrivacy_1 = @[@"NORMAL", @"TOGGLE_TEMPORARILY", @"REDUCE"];
    accessOptionForProtectTagPrivacy_2 = @[@"VOLATILE_MEMORY", @"NVM_MEMORY"];
    QT_SRForProtectTagPrivacy_2 = @[@"TAG_REDUCES_RANGE", @"TAG_DOES_NOT_REDUCES_RANGE"];
    QT_MEMForProtectTagPrivacy_2 = @[@"USE_PUBLIC_MEMORY_MAP", @"USE_PRIVATE_MEMORY_MAP"];
    shortRangeTypeForProtectTagPrivacy_4 = @[@"NORMAL_RANGE", @"SHORT_RANGE"];
    memoryBankForLockTag_1 = @[@"EPC", @"TID", @"USER", @"KILL PASSWORD", @"ACCESS PASSWORD"];
    lockActionForLockTag_1 = @[@"Unlock", @"Lock", @"Permanent Unlock", @"Permanent lock"];
    memoryBankForLockTag_2 = @[@"EPC", @"TID", @"USER", @"KILL PASSWORD", @"ACCESS PASSWORD"];
    lockActionForLockTag_2 = @[@"Unlock", @"Lock", @"Permanent Unlock", @"Permanent lock"];
    memoryBankForLockTag_3 = @[@"EPC", @"TID", @"USER", @"KILL PASSWORD", @"ACCESS PASSWORD"];
    lockActionForLockTag_3 = @[@"Unlock", @"Lock", @"Permanent Unlock", @"Permanent lock"];
    memoryBankForLockTag_4 = @[@"EPC", @"TID", @"USER", @"KILL PASSWORD", @"ACCESS PASSWORD"];
    lockActionForLockTag_4 = @[@"Unlock", @"Lock", @"Permanent Unlock", @"Permanent lock"];
    epcTypeForWriteTagEx_1 = @[@"EPC_SGTIN96", @"EPC_EAS", @"EPC_UDC"];
    filterForWriteTagEx_1 = @[@"ALL_OTHERS", @"POS_TRADE", @"TRANSPORT", @"RESERVED_3", @"HANDLING", @"RESERVED_5", @"UNIT_LOAD", @"UNIT_INSIDE_TRADE"];
    companyPrefixLengthForWriteTagEx_1 = @[@"DIGITS_6", @"DIGITS_7", @"DIGITS_8", @"DIGITS_9", @"DIGITS_10", @"DIGITS_11", @"DIGITS_12"];
    epcTypeForWriteTagEx_2 = @[@"EPC_SGTIN96", @"EPC_EAS", @"EPC_UDC"];
    filterForWriteTagEx_2 = @[@"ALL_OTHERS", @"POS_TRADE", @"TRANSPORT", @"RESERVED_3", @"HANDLING", @"RESERVED_5", @"UNIT_LOAD", @"UNIT_INSIDE_TRADE"];
    companyPrefixLengthForWriteTagEx_2 = @[@"DIGITS_6", @"DIGITS_7", @"DIGITS_8", @"DIGITS_9", @"DIGITS_10", @"DIGITS_11", @"DIGITS_12"];

    self.pickerMemoryBankForReadTag_1.dataSource = self;
    self.pickerMemoryBankForReadTag_1.delegate = self;
    [self.pickerMemoryBankForReadTag_1 setTag:1];
    [self.pickerMemoryBankForReadTag_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForReadTag_2.dataSource = self;
    self.pickerMemoryBankForReadTag_2.delegate = self;
    [self.pickerMemoryBankForReadTag_2 setTag:2];
    [self.pickerMemoryBankForReadTag_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForWriteTag_1.dataSource = self;
    self.pickerMemoryBankForWriteTag_1.delegate = self;
    [self.pickerMemoryBankForWriteTag_1 setTag:3];
    [self.pickerMemoryBankForWriteTag_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForWriteTag_2.dataSource = self;
    self.pickerMemoryBankForWriteTag_2.delegate = self;
    [self.pickerMemoryBankForWriteTag_2 setTag:4];
    [self.pickerMemoryBankForWriteTag_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForLockTag_1.dataSource = self;
    self.pickerMemoryBankForLockTag_1.delegate = self;
    [self.pickerMemoryBankForLockTag_1 setTag:5];
    [self.pickerMemoryBankForLockTag_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerLockActionForLockTag_1.dataSource = self;
    self.pickerLockActionForLockTag_1.delegate = self;
    [self.pickerLockActionForLockTag_1 setTag:6];
    [self.pickerLockActionForLockTag_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForLockTag_2.dataSource = self;
    self.pickerMemoryBankForLockTag_2.delegate = self;
    [self.pickerMemoryBankForLockTag_2 setTag:7];
    [self.pickerMemoryBankForLockTag_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerLockActionForLockTag_2.dataSource = self;
    self.pickerLockActionForLockTag_2.delegate = self;
    [self.pickerLockActionForLockTag_2 setTag:8];
    [self.pickerLockActionForLockTag_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerEpcTypeForWriteTagEx_1.dataSource = self;
    self.pickerEpcTypeForWriteTagEx_1.delegate = self;
    [self.pickerEpcTypeForWriteTagEx_1 setTag:9];
    [self.pickerEpcTypeForWriteTagEx_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerFilterForWriteTagEx_1.dataSource = self;
    self.pickerFilterForWriteTagEx_1.delegate = self;
    [self.pickerFilterForWriteTagEx_1 setTag:10];
    [self.pickerFilterForWriteTagEx_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerCompanyPrefixLengthForWriteTagEx_1.dataSource = self;
    self.pickerCompanyPrefixLengthForWriteTagEx_1.delegate = self;
    [self.pickerCompanyPrefixLengthForWriteTagEx_1 setTag:11];
    [self.pickerCompanyPrefixLengthForWriteTagEx_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerEpcTypeForWriteTagEx_2.dataSource = self;
    self.pickerEpcTypeForWriteTagEx_2.delegate = self;
    [self.pickerEpcTypeForWriteTagEx_2 setTag:12];
    [self.pickerEpcTypeForWriteTagEx_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerFilterForWriteTagEx_2.dataSource = self;
    self.pickerFilterForWriteTagEx_2.delegate = self;
    [self.pickerFilterForWriteTagEx_2 setTag:13];
    [self.pickerFilterForWriteTagEx_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerCompanyPrefixLengthForWriteTagEx_2.dataSource = self;
    self.pickerCompanyPrefixLengthForWriteTagEx_2.delegate = self;
    [self.pickerCompanyPrefixLengthForWriteTagEx_2 setTag:14];
    [self.pickerCompanyPrefixLengthForWriteTagEx_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForLockTag_3.dataSource = self;
    self.pickerMemoryBankForLockTag_3.delegate = self;
    [self.pickerMemoryBankForLockTag_3 setTag:15];
    [self.pickerMemoryBankForLockTag_3 selectRow:0 inComponent:0 animated:true];
    
    self.pickerLockActionForLockTag_3.dataSource = self;
    self.pickerLockActionForLockTag_3.delegate = self;
    [self.pickerLockActionForLockTag_3 setTag:16];
    [self.pickerLockActionForLockTag_3 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForLockTag_4.dataSource = self;
    self.pickerMemoryBankForLockTag_4.delegate = self;
    [self.pickerMemoryBankForLockTag_4 setTag:17];
    [self.pickerMemoryBankForLockTag_4 selectRow:0 inComponent:0 animated:true];
    
    self.pickerLockActionForLockTag_4.dataSource = self;
    self.pickerLockActionForLockTag_4.delegate = self;
    [self.pickerLockActionForLockTag_4 setTag:18];
    [self.pickerLockActionForLockTag_4 selectRow:0 inComponent:0 animated:true];

    self.pickerMemoryBankForReadTag_3.dataSource = self;
    self.pickerMemoryBankForReadTag_3.delegate = self;
    [self.pickerMemoryBankForReadTag_3 setTag:19];
    [self.pickerMemoryBankForReadTag_3 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForReadTag_4.dataSource = self;
    self.pickerMemoryBankForReadTag_4.delegate = self;
    [self.pickerMemoryBankForReadTag_4 setTag:20];
    [self.pickerMemoryBankForReadTag_4 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForWriteTag_3.dataSource = self;
    self.pickerMemoryBankForWriteTag_3.delegate = self;
    [self.pickerMemoryBankForWriteTag_3 setTag:21];
    [self.pickerMemoryBankForWriteTag_3 selectRow:0 inComponent:0 animated:true];
    
    self.pickerMemoryBankForWriteTag_4.dataSource = self;
    self.pickerMemoryBankForWriteTag_4.delegate = self;
    [self.pickerMemoryBankForWriteTag_4 setTag:22];
    [self.pickerMemoryBankForWriteTag_4 selectRow:0 inComponent:0 animated:true];
    
    self.pickerFlagUForProtectTagPrivacy_1.dataSource = self;
    self.pickerFlagUForProtectTagPrivacy_1.delegate = self;
    [self.pickerFlagUForProtectTagPrivacy_1 setTag:23];
    [self.pickerFlagUForProtectTagPrivacy_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerEPCForProtectTagPrivacy_1.dataSource = self;
    self.pickerEPCForProtectTagPrivacy_1.delegate = self;
    [self.pickerEPCForProtectTagPrivacy_1 setTag:24];
    [self.pickerEPCForProtectTagPrivacy_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerTIDForProtectTagPrivacy_1.dataSource = self;
    self.pickerTIDForProtectTagPrivacy_1.delegate = self;
    [self.pickerTIDForProtectTagPrivacy_1 setTag:25];
    [self.pickerTIDForProtectTagPrivacy_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerUserForProtectTagPrivacy_1.dataSource = self;
    self.pickerUserForProtectTagPrivacy_1.delegate = self;
    [self.pickerUserForProtectTagPrivacy_1 setTag:26];
    [self.pickerUserForProtectTagPrivacy_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerRangeForProtectTagPrivacy_1.dataSource = self;
    self.pickerRangeForProtectTagPrivacy_1.delegate = self;
    [self.pickerRangeForProtectTagPrivacy_1 setTag:27];
    [self.pickerRangeForProtectTagPrivacy_1 selectRow:0 inComponent:0 animated:true];
    
    self.pickerAccessOptionForProtectTagPrivacy_2.dataSource = self;
    self.pickerAccessOptionForProtectTagPrivacy_2.delegate = self;
    [self.pickerAccessOptionForProtectTagPrivacy_2 setTag:28];
    [self.pickerAccessOptionForProtectTagPrivacy_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerQT_SRForProtectTagPrivacy_2.dataSource = self;
    self.pickerQT_SRForProtectTagPrivacy_2.delegate = self;
    [self.pickerQT_SRForProtectTagPrivacy_2 setTag:29];
    [self.pickerQT_SRForProtectTagPrivacy_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerQT_MEMForProtectTagPrivacy_2.dataSource = self;
    self.pickerQT_MEMForProtectTagPrivacy_2.delegate = self;
    [self.pickerQT_MEMForProtectTagPrivacy_2 setTag:30];
    [self.pickerQT_MEMForProtectTagPrivacy_2 selectRow:0 inComponent:0 animated:true];
    
    self.pickerShortRangeTypeForProtectTagPrivacy_4.dataSource = self;
    self.pickerShortRangeTypeForProtectTagPrivacy_4.delegate = self;
    [self.pickerShortRangeTypeForProtectTagPrivacy_4 setTag:31];
    [self.pickerShortRangeTypeForProtectTagPrivacy_4 selectRow:0 inComponent:0 animated:true];

    keyboardIsUp = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [passDev setListener:self];
}


-(void)viewDidDisappear:(BOOL)animated {
//    [passDev setListener:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"NewDevConnStatusView"]) {
        
        DevDetailTabBarViewController* ctrler = (DevDetailTabBarViewController*)self.tabBarController;
        passDev = [ctrler getUHFDevice];
        
        
        
        childViewController = (NewDevConnStatusViewController *) [segue destinationViewController];
        [childViewController setUHFDevice:passDev];
    }
}

#pragma mark - Data Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger iCount;
    switch (pickerView.tag) {
        case 1: {
            iCount = memoryBankForReadTag_1.count;
        }
            break;

        case 2: {
            iCount = memoryBankForReadTag_2.count;
        }
            break;

        case 3: {
            iCount = memoryBankForWriteTag_1.count;
        }
            break;

        case 4: {
            iCount = memoryBankForWriteTag_2.count;
        }
            break;

        case 5: {
            iCount = memoryBankForLockTag_1.count;
        }
            break;

        case 6: {
            iCount = lockActionForLockTag_1.count;
        }
            break;

        case 7: {
            iCount = memoryBankForLockTag_2.count;
        }
            break;

        case 8: {
            iCount = lockActionForLockTag_2.count;
        }
            break;

        case 9: {
            iCount = epcTypeForWriteTagEx_1.count;
        }
            break;
            
        case 10: {
            iCount = filterForWriteTagEx_1.count;
        }
            break;
            
        case 11: {
            iCount = companyPrefixLengthForWriteTagEx_1.count;
        }
            break;

        case 12: {
            iCount = epcTypeForWriteTagEx_2.count;
        }
            break;
            
        case 13: {
            iCount = filterForWriteTagEx_2.count;
        }
            break;
            
        case 14: {
            iCount = companyPrefixLengthForWriteTagEx_2.count;
        }
            break;

        case 15: {
            iCount = memoryBankForLockTag_3.count;
        }
            break;

        case 16: {
            iCount = lockActionForLockTag_3.count;
        }
            break;

        case 17: {
            iCount = memoryBankForLockTag_4.count;
        }
            break;

        case 18: {
            iCount = lockActionForLockTag_4.count;
        }
            break;
            
        case 19: {
            iCount = memoryBankForReadTag_3.count;
        }
            break;

        case 20: {
            iCount = memoryBankForReadTag_4.count;
        }
            break;
            
        case 21: {
            iCount = memoryBankForWriteTag_3.count;
        }
            break;

        case 22: {
            iCount = memoryBankForWriteTag_4.count;
        }
            break;
            
        case 23: {
            iCount = flagUForProtectTagPrivacy_1.count;
        }
            break;
            
        case 24: {
            iCount = EPCForProtectTagPrivacy_1.count;
        }
            break;
            
        case 25: {
            iCount = TIDForProtectTagPrivacy_1.count;
        }
            break;
            
        case 26: {
            iCount = userForProtectTagPrivacy_1.count;
        }
            break;
            
        case 27: {
            iCount = rangeForProtectTagPrivacy_1.count;
        }
            break;
            
        case 28: {
            iCount = accessOptionForProtectTagPrivacy_2.count;
        }
            break;
            
        case 29: {
            iCount = QT_SRForProtectTagPrivacy_2.count;
        }
            break;
            
        case 30: {
            iCount = QT_MEMForProtectTagPrivacy_2.count;
        }
            break;
            
        case 31: {
            iCount = shortRangeTypeForProtectTagPrivacy_4.count;
        }
            break;

        default: {
            iCount = 0;
        }
            break;
    }
    
    return iCount;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *strValue;
    switch (pickerView.tag) {
        case 1: {
            strValue = memoryBankForReadTag_1[row];
        }
            break;
            
        case 2: {
            strValue = memoryBankForReadTag_2[row];
        }
            break;
                
        case 3: {
            strValue = memoryBankForWriteTag_1[row];
        }
            break;
                    
        case 4: {
            strValue = memoryBankForWriteTag_2[row];
        }
            break;
                        
        case 5: {
            strValue = memoryBankForLockTag_1[row];
        }
            break;
                            
        case 6: {
            strValue = lockActionForLockTag_1[row];
        }
            break;
                        
        case 7: {
            strValue = memoryBankForLockTag_2[row];
        }
            break;
                            
        case 8: {
            strValue = lockActionForLockTag_2[row];
        }
            break;
            
        case 9: {
            strValue = epcTypeForWriteTagEx_1[row];
        }
            break;
            
        case 10: {
            strValue = filterForWriteTagEx_1[row];
        }
            break;
            
        case 11: {
            strValue = companyPrefixLengthForWriteTagEx_2[row];
        }
            break;

        case 12: {
            strValue = epcTypeForWriteTagEx_2[row];
        }
            break;
            
        case 13: {
            strValue = filterForWriteTagEx_2[row];
        }
            break;
            
        case 14: {
            strValue = companyPrefixLengthForWriteTagEx_1[row];
        }
            break;

        case 15: {
            strValue = memoryBankForLockTag_3[row];
        }
            break;

        case 16: {
            strValue = lockActionForLockTag_3[row];
        }
            break;

        case 17: {
            strValue = memoryBankForLockTag_4[row];
        }
            break;

        case 18: {
            strValue = lockActionForLockTag_4[row];
        }
            break;
            
        case 19: {
            strValue = memoryBankForReadTag_3[row];
        }
            break;
            
        case 20: {
            strValue = memoryBankForReadTag_4[row];
        }
            break;
            
        case 21: {
            strValue = memoryBankForWriteTag_3[row];
        }
            break;
                    
        case 22: {
            strValue = memoryBankForWriteTag_4[row];
        }
            break;
            
        case 23: {
            strValue = flagUForProtectTagPrivacy_1[row];
        }
            break;
            
        case 24: {
            strValue = EPCForProtectTagPrivacy_1[row];
        }
            break;
            
        case 25: {
            strValue = TIDForProtectTagPrivacy_1[row];
        }
            break;
            
        case 26: {
            strValue = userForProtectTagPrivacy_1[row];
        }
            break;
            
        case 27: {
            strValue = rangeForProtectTagPrivacy_1[row];
        }
            break;
            
        case 28: {
            strValue = accessOptionForProtectTagPrivacy_2[row];
        }
            break;
            
        case 29: {
            strValue = QT_SRForProtectTagPrivacy_2[row];
        }
            break;
            
        case 30: {
            strValue = QT_MEMForProtectTagPrivacy_2[row];
        }
            break;
            
        case 31: {
            strValue = shortRangeTypeForProtectTagPrivacy_4[row];
        }
            break;

        default: {
            strValue = @"";
        }
            break;
    }
    
    return strValue;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 9: {
            switch (row) {
                case 0:
                    [self->_stackFilterForWriteTagEx_1 setHidden:false];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_1 setHidden:false];
                    [self->_stackSerialNumberForWriteTagEx_1 setHidden:false];
                    break;
                    
                case 1: {
                    [self->_stackFilterForWriteTagEx_1 setHidden:false];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_1 setHidden:false];
                    [self->_stackSerialNumberForWriteTagEx_1 setHidden:true];
                }
                    break;
                    
                case 2: {
                    [self->_stackFilterForWriteTagEx_1 setHidden:true];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_1 setHidden:true];
                    [self->_stackSerialNumberForWriteTagEx_1 setHidden:true];
                }
                    break;
                    
                default:
                    [self->_stackFilterForWriteTagEx_1 setHidden:false];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_1 setHidden:false];
                    [self->_stackSerialNumberForWriteTagEx_1 setHidden:false];
                    break;
            }
        }
            break;
            
        case 12: {
            switch (row) {
                case 0:
                    [self->_stackFilterForWriteTagEx_2 setHidden:false];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_2 setHidden:false];
                    [self->_stackSerialNumberForWriteTagEx_2 setHidden:false];
                    break;
                    
                case 1: {
                    [self->_stackFilterForWriteTagEx_2 setHidden:false];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_2 setHidden:false];
                    [self->_stackSerialNumberForWriteTagEx_2 setHidden:true];
                }
                    break;
                    
                case 2: {
                    [self->_stackFilterForWriteTagEx_2 setHidden:true];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_2 setHidden:true];
                    [self->_stackSerialNumberForWriteTagEx_2 setHidden:true];
                }
                    break;
                    
                default:
                    [self->_stackFilterForWriteTagEx_2 setHidden:false];
                    [self->_stackCompanyPrefixLengthForWriteTagEx_2 setHidden:false];
                    [self->_stackSerialNumberForWriteTagEx_2 setHidden:false];
                    break;
            }
        }
            break;
            
        default: {
            
        }
            break;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    NSString *strValue = @"";
    switch (pickerView.tag) {
        case 1: {
            strValue = memoryBankForReadTag_1[row];
        }
            break;
            
        case 2: {
            strValue = memoryBankForReadTag_2[row];
        }
            break;
                
        case 3: {
            strValue = memoryBankForWriteTag_1[row];
        }
            break;
                    
        case 4: {
            strValue = memoryBankForWriteTag_2[row];
        }
            break;
                        
        case 5: {
            strValue = memoryBankForLockTag_1[row];
        }
            break;
                            
        case 6: {
            strValue = lockActionForLockTag_1[row];
        }
            break;
                        
        case 7: {
            strValue = memoryBankForLockTag_2[row];
        }
            break;
                            
        case 8: {
            strValue = lockActionForLockTag_2[row];
        }
            break;
            
        case 9: {
            strValue = epcTypeForWriteTagEx_1[row];
        }
            break;
            
        case 10: {
            strValue = filterForWriteTagEx_1[row];
        }
            break;
            
        case 11: {
            strValue = companyPrefixLengthForWriteTagEx_2[row];
        }
            break;

        case 12: {
            strValue = epcTypeForWriteTagEx_2[row];
        }
            break;
            
        case 13: {
            strValue = filterForWriteTagEx_2[row];
        }
            break;
            
        case 14: {
            strValue = companyPrefixLengthForWriteTagEx_1[row];
        }
            break;

        case 15: {
            strValue = memoryBankForLockTag_3[row];
        }
            break;

        case 16: {
            strValue = lockActionForLockTag_3[row];
        }
            break;

        case 17: {
            strValue = memoryBankForLockTag_4[row];
        }
            break;

        case 18: {
            strValue = lockActionForLockTag_4[row];
        }
            break;
            
        case 19: {
            strValue = memoryBankForReadTag_3[row];
        }
            break;
            
        case 20: {
            strValue = memoryBankForReadTag_4[row];
        }
            break;
            
        case 21: {
            strValue = memoryBankForWriteTag_3[row];
        }
            break;
                    
        case 22: {
            strValue = memoryBankForWriteTag_4[row];
        }
            break;
            
        case 23: {
            strValue = flagUForProtectTagPrivacy_1[row];
        }
            break;
            
        case 24: {
            strValue = EPCForProtectTagPrivacy_1[row];
        }
            break;
            
        case 25: {
            strValue = TIDForProtectTagPrivacy_1[row];
        }
            break;
            
        case 26: {
            strValue = userForProtectTagPrivacy_1[row];
        }
            break;
            
        case 27: {
            strValue = rangeForProtectTagPrivacy_1[row];
        }
            break;
            
        case 28: {
            strValue = accessOptionForProtectTagPrivacy_2[row];
        }
            break;
            
        case 29: {
            strValue = QT_SRForProtectTagPrivacy_2[row];
        }
            break;
            
        case 30: {
            strValue = QT_MEMForProtectTagPrivacy_2[row];
        }
            break;
            
        case 31: {
            strValue = shortRangeTypeForProtectTagPrivacy_4[row];
        }
            break;

        default: {
            strValue = @"";
        }
            break;
    }
    [pickerLabel setText:strValue];
    
    return pickerLabel;
}

#pragma mark - Keyboard Handler

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(void)keyboardWillShow:(NSNotification *) notification {
    if (keyboardIsUp == false) {
        [UIView animateWithDuration:0.25 animations: ^{
            self->keyboardIsUp = true;
            CGRect newFrame = [self->_customView frame];
            newFrame.origin.y -= 240;
            [self->_customView setFrame:newFrame];
        }completion:^(BOOL finished) {

        }];
    }
}

-(void)keyboardWillBeHidden:(NSNotification *) notification {
    if (keyboardIsUp == true) {
        [UIView animateWithDuration:0.25 animations: ^{
            self->keyboardIsUp = false;
            CGRect newFrame = [self->_customView frame];
            newFrame.origin.y += 240;
            [self->_customView setFrame:newFrame];
        }completion:^(BOOL finished) {

        }];
    }
}

-(void)showToast:(NSString*)title message:(NSString*)message {
    
    
    
    NSMutableString* allMesg = [NSMutableString stringWithString:title];
    [allMesg appendString:@" "];
    [allMesg appendString:message];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = allMesg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1];
}

- (IBAction)actWriteEPC_1:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *password = self->_passwordFlagForWriteEPC_1.text;
            NSData *bEPC  = [GLog CreateDataWithHexString:self->_epcForWriteEPC_1.text];

            [self->passDev writeEpc:password EPCData:bEPC];
        }
    }
}

- (IBAction)actWriteEPC_2:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *password = self->_passwordForWriteEPC_2.text;
            NSData *bEPC  = [GLog CreateDataWithHexString:self->_epcForWriteEPC_2.text];
            NSString *pc_epc = self->_pc_epc_ForWriteEPC_2.text;

            [self->passDev writeEpc:pc_epc HexAccessPassword:password EPCData:bEPC];
        }
    }
}

- (IBAction)actReadTag_1:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *selectedEPC = self->_selectedEPCForReadTag_1.text;
            NSString *passwordFlag = self->_passwordFlagForReadTag_1.text;
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForReadTag_1 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_TID;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForReadTag_1.text;
            NSString *readLength = self.readLengthForReadTag_1.text;
            
            [self->passDev readTag:selectedEPC PWD:passwordFlag MemoryBank:memoryBank StartAddr:[startAddress intValue] ReadLen:[readLength intValue]];
        }
    }
}

- (IBAction)actReadTag_2:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *passwordFlag = self->_passwordFlagForReadTag_2.text;
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForReadTag_2 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_TID;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForReadTag_2.text;
            NSString *readLength = self.readLengthForReadTag_2.text;
            
            [self->passDev readTag:passwordFlag MemoryBank:memoryBank StartAddr:[startAddress intValue] ReadLen:[readLength intValue]];
        }
    }
}

- (IBAction)actReadTag_3:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *selectedEPC = self->_selectedEPCForReadTag_3.text;
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForReadTag_3 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_TID;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForReadTag_3.text;
            NSString *readLength = self.readLengthForReadTag_3.text;
            
            [self->passDev readTag:selectedEPC PWD:nil MemoryBank:memoryBank StartAddr:[startAddress intValue] ReadLen:[readLength intValue]];
        }
    }
}

- (IBAction)actReadTag_4:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForReadTag_4 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_TID;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForReadTag_4.text;
            NSString *readLength = self.readLengthForReadTag_4.text;
            
            [self->passDev readTag:nil MemoryBank:memoryBank StartAddr:[startAddress intValue] ReadLen:[readLength intValue]];
        }
    }
}

- (IBAction)actWriteTag_1:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *selectedEPC = self->_selectedEPCForWriteTag_1.text;
            NSString *passwordFlag = self->_passwordFlagForWriteTag_1.text;
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForWriteTag_1 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                        
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForWriteTag_1.text;
            NSString *data = self->_dataToWriteForWriteTag_1.text;
            
            [self->passDev writeTag:selectedEPC PWD:passwordFlag MemoryBank:memoryBank StartAddr:[startAddress intValue] Data:[GLog CreateDataWithHexString:data]];

        }
    }
}

- (IBAction)actWriteTag_2:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *passwordFlag = self->_passwordFlagforWriteTag_2.text;
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForWriteTag_2 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                        
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForWriteTag_2.text;
            NSString *data = self->_dateToWriteForWriteTag_2.text;

            [self->passDev writeTag:passwordFlag MemoryBank:memoryBank StartAddr:[startAddress intValue] Data:[GLog CreateDataWithHexString:data]];
        }
    }
}

- (IBAction)actWriteTag_3:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *selectedEPC = self->_selectedEPCForWriteTag_3.text;
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForWriteTag_3 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                        
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForWriteTag_3.text;
            NSString *data = self->_dataToWriteForWriteTag_3.text;
            
            [self->passDev writeTag:selectedEPC PWD:nil MemoryBank:memoryBank StartAddr:[startAddress intValue] Data:[GLog CreateDataWithHexString:data]];

        }
    }
}

- (IBAction)actWriteTag_4:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            MemoryBank memoryBank = MBC_Reserve;
            switch ([self.pickerMemoryBankForWriteTag_4 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_Reserve;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_EPC;
                }
                    break;
                        
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;

                default: {
                    memoryBank = MBC_Reserve;
                }
                    break;
            }
            NSString *startAddress = self.startAddressForWriteTag_4.text;
            NSString *data = self->_dateToWriteForWriteTag_4.text;

            [self->passDev writeTag:nil MemoryBank:memoryBank StartAddr:[startAddress intValue] Data:[GLog CreateDataWithHexString:data]];
        }
    }
}

- (IBAction)actReadTagEx_1:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *passwordFlag = self->_passwordForReadTagEx_1.text;
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 readTagEx:passwordFlag];
            }
        }
    }
}

- (IBAction)actReadTagEx_2:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 readTagEx];
            }
        }
    }
}

- (IBAction)actWriteTagEx_1:(id)sender {
    NSString *password = self->_passwordForWriteTagEx_1.text;
    NSString *barcode = self->_barcodeForWriteTagEx_1.text;
    EpcHeader epcHeader = EPC_SGTIN96;
    Filter filter = ALL_OTHERS;
    CompanyPrefixLength companyPrefixLength = DIGITS_6;
    NSString *serialNumber = self->_serialNumberForWriteTagEx_1.text;
    
    switch ([self.pickerFilterForWriteTagEx_1 selectedRowInComponent:0]) {
        case 0: {
            filter = ALL_OTHERS;
        }
            break;
            
        case 1: {
            filter = POS_TRADE;
        }
            break;
            
        case 2: {
            filter = TRANSPORT;
        }
            break;
            
        case 3: {
            filter = RESERVED_3;
        }
            break;
            
        case 4: {
            filter = HANDLING;
        }
            break;
            
        case 5: {
            filter = RESERVED_5;
        }
            break;
            
        case 6: {
            filter = UNIT_LOAD;
        }
            break;
            
        case 7: {
            filter = UNIT_INSIDE_TRADE;
        }
            break;
            
        default: {
            filter = ALL_OTHERS;
        }
            break;
    }
    
    switch ([self.pickerCompanyPrefixLengthForWriteTagEx_1 selectedRowInComponent:0]) {
        case 0: {
            companyPrefixLength = DIGITS_6;
        }
            break;
            
        case 1: {
            companyPrefixLength = DIGITS_7;
        }
            break;
            
        case 2: {
            companyPrefixLength = DIGITS_8;
        }
            break;
            
        case 3: {
            companyPrefixLength = DIGITS_9;
        }
            break;
            
        case 4: {
            companyPrefixLength = DIGITS_10;
        }
            break;
            
        case 5: {
            companyPrefixLength = DIGITS_11;
        }
            break;
            
        case 6: {
            companyPrefixLength = DIGITS_12;
        }
            break;
            
        default: {
            companyPrefixLength = DIGITS_6;
        }
            break;
    }
    
    BaseTagData *baseTagData = nil;
    
    switch ([self.pickerEpcTypeForWriteTagEx_1 selectedRowInComponent:0]) {
        case 0: {
            epcHeader = EPC_SGTIN96;
            SGTIN96TagData *sGTIN96TagData = [[SGTIN96TagData alloc] initWithEpcHader:epcHeader Barcode:barcode Filter:filter CompanyPrefixLength:companyPrefixLength SerialNumber:serialNumber];
            baseTagData = sGTIN96TagData;
        }
            break;
            
        case 1: {
            epcHeader = EPC_EAS;
            SGTIN96EASTagData *sGTIN96EASTagData = [[SGTIN96EASTagData alloc] initWithEpcHader:epcHeader Barcode:barcode Filter:filter CompanyPrefixLength:companyPrefixLength];
            baseTagData = sGTIN96EASTagData;
        }
            break;
            
        case 2: {
            epcHeader = EPC_UDC;
            UDCTagData *uDCTagData = [[UDCTagData alloc] initWithEpcHader:epcHeader Barcode:barcode];
            baseTagData = uDCTagData;
        }
            break;
            
        default: {
            epcHeader = EPC_SGTIN96;
        }
            break;
    }

    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 writeTagEx:baseTagData HexAccessPassword:password];
            }
        }
    }
}

- (IBAction)actWriteTagEx_2:(id)sender {
    NSString *barcode = self->_barcodeForWriteTagEx_2.text;
    EpcHeader epcHeader = EPC_SGTIN96;
    Filter filter = ALL_OTHERS;
    CompanyPrefixLength companyPrefixLength = DIGITS_6;
    NSString *serialNumber = self->_serialNumberForWriteTagEx_2.text;

    switch ([self.pickerFilterForWriteTagEx_2 selectedRowInComponent:0]) {
        case 0: {
            filter = ALL_OTHERS;
        }
            break;
            
        case 1: {
            filter = POS_TRADE;
        }
            break;
            
        case 2: {
            filter = TRANSPORT;
        }
            break;
            
        case 3: {
            filter = RESERVED_3;
        }
            break;
            
        case 4: {
            filter = HANDLING;
        }
            break;
            
        case 5: {
            filter = RESERVED_5;
        }
            break;
            
        case 6: {
            filter = UNIT_LOAD;
        }
            break;
            
        case 7: {
            filter = UNIT_INSIDE_TRADE;
        }
            break;
            
        default: {
            filter = ALL_OTHERS;
        }
            break;
    }
    
    switch ([self.pickerCompanyPrefixLengthForWriteTagEx_2 selectedRowInComponent:0]) {
        case 0: {
            companyPrefixLength = DIGITS_6;
        }
            break;
            
        case 1: {
            companyPrefixLength = DIGITS_7;
        }
            break;
            
        case 2: {
            companyPrefixLength = DIGITS_8;
        }
            break;
            
        case 3: {
            companyPrefixLength = DIGITS_9;
        }
            break;
            
        case 4: {
            companyPrefixLength = DIGITS_10;
        }
            break;
            
        case 5: {
            companyPrefixLength = DIGITS_11;
        }
            break;
            
        case 6: {
            companyPrefixLength = DIGITS_12;
        }
            break;
            
        default: {
            companyPrefixLength = DIGITS_6;
        }
            break;
    }
    
    BaseTagData *baseTagData = nil;
    
    switch ([self.pickerEpcTypeForWriteTagEx_2 selectedRowInComponent:0]) {
        case 0: {
            epcHeader = EPC_SGTIN96;
            SGTIN96TagData *sGTIN96TagData = [[SGTIN96TagData alloc] initWithEpcHader:epcHeader Barcode:barcode Filter:filter CompanyPrefixLength:companyPrefixLength SerialNumber:serialNumber];
            baseTagData = sGTIN96TagData;
        }
            break;
            
        case 1: {
            epcHeader = EPC_EAS;
            SGTIN96EASTagData *sGTIN96EASTagData = [[SGTIN96EASTagData alloc] initWithEpcHader:epcHeader Barcode:barcode Filter:filter CompanyPrefixLength:companyPrefixLength];
            baseTagData = sGTIN96EASTagData;
        }
            break;
            
        case 2: {
            epcHeader = EPC_UDC;
            UDCTagData *uDCTagData = [[UDCTagData alloc] initWithEpcHader:epcHeader Barcode:barcode];
            baseTagData = uDCTagData;
        }
            break;
            
        default: {
            epcHeader = EPC_SGTIN96;
        }
            break;
    }

    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 writeTagEx:baseTagData];
            }
        }
    }
}

- (IBAction)actEPCLengthChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(32 * slider.value) / 32;
    
    self->_labEPCLengthForProtectTagPrivacy_1.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actProtectTagPrivacy_1:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *accessPassword = self->_accessPasswordForProtectTagPrivacy_1.text;
            UntraceableParameter *tagAccessParameter = [[UntraceableParameter alloc] initWithAccessPassword:accessPassword];
            
            switch ([self.pickerFlagUForProtectTagPrivacy_1 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignFlagU:FlagU_DEASSERT_U];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignFlagU:FlagU_ASSERT_U];
                }
                    break;
                    
                default: {
                    
                }
                    break;
            }
            
            switch ([self->_pickerEPCForProtectTagPrivacy_1 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignEPC:EPC_SHOW];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignEPC:EPC_HIDE];
                }
                    break;

                default:
                    break;
            }
            
            [tagAccessParameter assignEpcLength:round(100 * [self->_sliderEPCLengthForProtectTagPrivacy_1 value]) / 100];
            
            switch ([self->_pickerTIDForProtectTagPrivacy_1 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignTID:TID_SHOW];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignTID:TID_HIDE_SHOME];
                }
                    break;
                    
                case 2: {
                    [tagAccessParameter assignTID:TID_HIDE_ALL];
                }
                    break;

                default:
                    break;
            }
            
            switch ([self->_pickerUserForProtectTagPrivacy_1 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignUser:User_VIEW];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignUser:User_HIDE];
                }
                    break;

                default:
                    break;
            }
            
            switch ([self->_pickerRangeForProtectTagPrivacy_1 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignRange:Range_NORMAL];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignRange:Range_TOGGLE_TEMPORARILY];
                }
                    break;
                    
                case 2: {
                    [tagAccessParameter assignRange:Range_REDUCE];
                }
                    break;

                default:
                    break;
            }
            
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 protectTagPrivacy:tagAccessParameter];
            }
        }
    }
}

- (IBAction)actProtectTagPrivacy_2:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *accessPassword = self->_accessPasswordForProtectTagPrivacy_2.text;
            QTWriteParameter *tagAccessParameter = [[QTWriteParameter alloc] initWithAccessPassword:accessPassword];
            
            switch ([self->_pickerAccessOptionForProtectTagPrivacy_2 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignAccessOption:QTWrite_VOLATILE_MEMORY];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignAccessOption:QTWrite_NVM_MEMORY];
                }
                    break;

                default:
                    break;
            }
            
            switch ([self->_pickerQT_SRForProtectTagPrivacy_2 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignQT_SR:QT_SR_TAG_REDUCES_RANGE];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignQT_SR:QT_SR_TAG_DOSE_NOT_REDUCES_RANGE];
                }
                    break;

                default:
                    break;
            }
            
            switch ([self->_pickerQT_MEMForProtectTagPrivacy_2 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignQT_MEM:QT_MEM_USE_PUBLIC_MEMORY_MAP];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignQT_MEM:QT_MEM_USE_PRIVATE_MEMORY_MAP];
                }
                    break;

                default:
                    break;
            }
            
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 protectTagPrivacy:tagAccessParameter];
            }
        }
    }
}

- (IBAction)actProtectTagPrivacy_3:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *accessPassword = self->_accessPasswordForProtectTagPrivacy_3.text;
            QTReadParameter *tagAccessParameter = [[QTReadParameter alloc] initWithAccessPassword:accessPassword];
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 protectTagPrivacy:tagAccessParameter];
            }
        }
    }
}

- (IBAction)actProtectTagPrivacy_4:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *accessPassword = self->_accessPasswordForProtectTagPrivacy_4.text;
            ShortRangeParameter *tagAccessParameter = [[ShortRangeParameter alloc] initWithAccessPassword:accessPassword];
            
            switch ([self->_pickerShortRangeTypeForProtectTagPrivacy_4 selectedRowInComponent:0]) {
                case 0: {
                    [tagAccessParameter assignShortRangeType:NORMAL_RANGE];
                }
                    break;
                    
                case 1: {
                    [tagAccessParameter assignShortRangeType:SHORT_RANGE];
                }
                    break;

                default:
                    break;
            }
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 protectTagPrivacy:tagAccessParameter];
            }
        }
    }
}

- (IBAction)actLockTag_3:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *passwordFlag = self->_passwordFlagForLockTag_3.text;
            NSString *selectedPcEpc = self->_selectedPcEpcForLockTag_3.text;
            MemoryBank memoryBank = MBC_EPC;
            switch ([self.pickerMemoryBankForLockTag_3 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_TID;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_KILL_PASSWORD;
                }
                    break;
                        
                case 4: {
                    memoryBank = MBC_ACCESS_PASSWORD;
                }
                    break;

                default: {
                    memoryBank = MBC_EPC;
                }
                    break;
            }
            LockAction lockAction = LA_UNLOCK;
            switch ([self->_pickerLockActionForLockTag_3 selectedRowInComponent:0]) {
                case 0: {
                    lockAction = LA_UNLOCK;
                }
                    break;
                    
                case 1: {
                    lockAction = LA_LOCK;
                }
                    break;
                    
                case 2: {
                    lockAction = LA_PERMA_UNLOCK;
                }
                    break;
                        
                case 3: {
                    lockAction = LA_PERMA_LOCK;
                }
                    break;

                default: {
                    lockAction = LA_UNLOCK;
                }
                    break;
            }
            
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
            GNPLockInfos* lockInfo = [[GNPLockInfos alloc] init];
            lockInfo.action = lockAction;
            lockInfo.memBank_R = memoryBank;
            [array addObject:lockInfo];
            [self->passDev lockTag:passwordFlag SelectedPcEpc:selectedPcEpc LockInfos:array];
        }
    }
}

- (IBAction)actLockTag_4:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *selectedPcEpc = self->_selectedPcEpcForLockTag_4.text;
            MemoryBank memoryBank = MBC_EPC;
            switch ([self.pickerMemoryBankForLockTag_4 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_TID;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_KILL_PASSWORD;
                }
                    break;
                        
                case 4: {
                    memoryBank = MBC_ACCESS_PASSWORD;
                }
                    break;

                default: {
                    memoryBank = MBC_EPC;
                }
                    break;
            }
            LockAction lockAction = LA_UNLOCK;
            switch ([self->_pickerLockActionForLockTag_4 selectedRowInComponent:0]) {
                case 0: {
                    lockAction = LA_UNLOCK;
                }
                    break;
                    
                case 1: {
                    lockAction = LA_LOCK;
                }
                    break;
                    
                case 2: {
                    lockAction = LA_PERMA_UNLOCK;
                }
                    break;
                        
                case 3: {
                    lockAction = LA_PERMA_LOCK;
                }
                    break;

                default: {
                    lockAction = LA_UNLOCK;
                }
                    break;
            }
            
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
            GNPLockInfos* lockInfo = [[GNPLockInfos alloc] init];
            lockInfo.action = lockAction;
            lockInfo.memBank_R = memoryBank;
            [array addObject:lockInfo];
            [self->passDev lockTag:nil SelectedPcEpc:selectedPcEpc LockInfos:array];
        }
    }
}

- (IBAction)actLockTag_1:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *passwordFlag = self->_passwordFlagForLockTag_1.text;
            MemoryBank memoryBank = MBC_EPC;
            switch ([self.pickerMemoryBankForLockTag_1 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_TID;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_KILL_PASSWORD;
                }
                    break;
                        
                case 4: {
                    memoryBank = MBC_ACCESS_PASSWORD;
                }
                    break;

                default: {
                    memoryBank = MBC_EPC;
                }
                    break;
            }
            LockAction lockAction = LA_UNLOCK;
            switch ([self->_pickerLockActionForLockTag_1 selectedRowInComponent:0]) {
                case 0: {
                    lockAction = LA_UNLOCK;
                }
                    break;
                    
                case 1: {
                    lockAction = LA_LOCK;
                }
                    break;
                    
                case 2: {
                    lockAction = LA_PERMA_UNLOCK;
                }
                    break;
                        
                case 3: {
                    lockAction = LA_PERMA_LOCK;
                }
                    break;

                default: {
                    lockAction = LA_UNLOCK;
                }
                    break;
            }
            
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
            GNPLockInfos* lockInfo = [[GNPLockInfos alloc] init];
            lockInfo.action = lockAction;
            lockInfo.memBank_R = memoryBank;
            [array addObject:lockInfo];
//            [self->passDev lockTag:passwordFlag LockInfos:array];
            [self->passDev lockTag:passwordFlag SelectedPcEpc:nil LockInfos:array];
        }
    }
}

- (IBAction)actLockTag_2:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            MemoryBank memoryBank = MBC_EPC;
            switch ([self.pickerMemoryBankForLockTag_2 selectedRowInComponent:0]) {
                case 0: {
                    memoryBank = MBC_EPC;
                }
                    break;
                    
                case 1: {
                    memoryBank = MBC_TID;
                }
                    break;
                    
                case 2: {
                    memoryBank = MBC_UserMemory;
                }
                    break;
                        
                case 3: {
                    memoryBank = MBC_KILL_PASSWORD;
                }
                    break;
                        
                case 4: {
                    memoryBank = MBC_ACCESS_PASSWORD;
                }
                    break;

                default: {
                    memoryBank = MBC_EPC;
                }
                    break;
            }
            LockAction lockAction = LA_UNLOCK;
            switch ([self->_pickerLockActionForLockTag_2 selectedRowInComponent:0]) {
                case 0: {
                    lockAction = LA_UNLOCK;
                }
                    break;
                    
                case 1: {
                    lockAction = LA_LOCK;
                }
                    break;
                    
                case 2: {
                    lockAction = LA_PERMA_UNLOCK;
                }
                    break;
                        
                case 3: {
                    lockAction = LA_PERMA_LOCK;
                }
                    break;

                default: {
                    lockAction = LA_UNLOCK;
                }
                    break;
            }
            
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
            GNPLockInfos* lockInfo = [[GNPLockInfos alloc] init];
            lockInfo.action = lockAction;
            lockInfo.memBank_R = memoryBank;
            [array addObject:lockInfo];
//            [self->passDev lockTag:array];
            [self->passDev lockTag:nil SelectedPcEpc:nil LockInfos:array];
        }
    }
}

- (IBAction)actKillTag_1:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *accessPassword = self->_accessPasswordForKillTag_1.text;
            NSString *killPassword = self->_killPasswordForKillTag_1.text;
            [self->passDev killTag:accessPassword KillPWD:killPassword];
        }
    }
}

- (IBAction)actKillTag_2:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *killPassword = self->_killPasswordForKillTag_2.text;
//            [self->passDev killTag:killPassword];
            [self->passDev killTag:nil KillPWD:killPassword];
        }
    }
}

#pragma mark - UHF API Callback

-(void)didReadTag:(NSData *)data {
    [childViewController addLog:[NSString stringWithFormat:@"didReadTag = %@",data]];
}

-(void)didReadTagEx:(NSData *)data{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [childViewController addLog:[NSString stringWithFormat:@"didReadTagEx, data = %@ (%@)",data, string]];
}

-(void)didGetFirmwareVersion:(NSString *)fwVer {
    [childViewController addLog:[NSString stringWithFormat:@"didGetFirmwareVersion, fwVer = %@",fwVer]];
    [passDev getDevInfo].devROMVersion = fwVer;
    [childViewController reloadData];
}

-(void)didGetBleRomVersion:(NSString *)romVersion{
    [childViewController addLog:[NSString stringWithFormat:@"didGetBleRomVersion, romVersion = %@",romVersion]];
}

- (void)didGetBLEFirmwareVersion:(NSString *)fwVer {
    [childViewController addLog:[NSString stringWithFormat:@"didGetBLEFirmwareVersion, fwVer= %@",fwVer]];
    [passDev getDevInfo]._bleDevInfo.devROMVersion = fwVer;
    [childViewController reloadData];
}

- (void)didGetWiFiMacAddress:(NSString *)wifiMacAddress {
    [childViewController addLog:[NSString stringWithFormat:@"didGetWiFiMacAddress, wifiMacAddress = %@",wifiMacAddress]];
    [childViewController reloadData];
}

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
    if (self->passDev != nil && self->passDev.getDevInfo.currentConnStatus == DevConnected) {
        [self->passDev stopInventory];
    }
//    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber],
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %02X",taginfo.RSSI],
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]],
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString],
//    [taginfo.TIDHexString isEqual: @""] ? @"" : [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
//    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %02X",taginfo.RSSI]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]]];
////    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPC = %@",taginfo.EPC]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString]];
////    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TID = %@",taginfo.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
}

- (void)didDiscoverTagInfoEx:(GNPDecodedTagData *)decodedTagData{
//    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TID = %@",decodedTagData.TID],
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TagSerialNumber = %@",decodedTagData.TagSerialNumber],
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DeviceSerialNumber = %@",decodedTagData.DeviceSerialNumber],
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DecodedDataList = %@",decodedTagData.DecodedDataList]];
//    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TID = %@",decodedTagData.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TagSerialNumber = %@",decodedTagData.TagSerialNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DeviceSerialNumber = %@",decodedTagData.DeviceSerialNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DecodedDataList = %@",decodedTagData.DecodedDataList]];
}

-(void)didTagRemoved:(GNPTagInfo *)taginfo {
//    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.TagNumber = %d",taginfo.TagNumber],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.RSSI = %02X",taginfo.RSSI],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.Frequency = %f",[taginfo getFrequency]],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.EPCHexString = %@",taginfo.EPCHexString],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
//    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TagNumber = %d",taginfo.TagNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.RSSI = %02X",taginfo.RSSI]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.Frequency = %f",[taginfo getFrequency]]];
////    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.EPC = %@",taginfo.EPC]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.EPCHexString = %@",taginfo.EPCHexString]];
////    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TID = %@",taginfo.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
}

-(void)didGeneralSuccess:(NSString *)strCMDName {
    [childViewController addLog:[NSString stringWithFormat:@"didGeneralSuccess = %@",strCMDName]];
}

-(void)didGeneralERROR:(NSString *)strCMDName ErrMessage:(NSString *)strErrorMessage {
    [childViewController addLog:[NSString stringWithFormat:@"didGeneralERROR strCMDName = %@, strErrorMessage = %@", strCMDName, strErrorMessage]];
}

-(void)didGeneralTimeout:(NSString *)strCMDName ErrMessage:(NSString *)strErrorMessage Data:(NSData *)data {
    [childViewController addLog:[NSString stringWithFormat:@"didGeneralTimeout strCMDName = %@, strErrorMessage = %@, data = %@", strCMDName, strErrorMessage, data]];
}

@end
