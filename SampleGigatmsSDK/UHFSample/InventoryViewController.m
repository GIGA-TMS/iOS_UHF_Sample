//
//  InventoryViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/4/12.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "InventoryViewController.h"
#import "TagItemTableViewCell.h"
#import <UHFSDK/GNPTagInfo.h>
#import <UHFSDK/TS100.h>
#import "DevDetailTabBarViewController.h"
#import "DevConnStatusViewController.h"
#import "MBProgressHUD.h"

@interface InventoryViewController () <UITableViewDelegate, UITableViewDataSource, IUHFDeviceListener>

@end

@implementation InventoryViewController
{
    NSMutableArray* allTagItems;
    UHFDevice* passDev;
    DevConnStatusViewController* childViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (passDev) {
        [passDev setListener:self];
        
        
        
    }
    allTagItems = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    [passDev setListener:self];
}


-(void)viewDidDisappear:(BOOL)animated {
//    [passDev setListener:nil];
}
#pragma mark - Action
- (IBAction)actInitalizeSettings:(id)sender {
    [passDev cmdInitializeSettings:passDev.classVer];
}
- (IBAction)actGetBLEVer:(id)sender {
    [passDev getBLEFirmwareVersion];
}

- (IBAction)actInventoryEx:(id)sender {
    [passDev startInventoryEx:TDE_RAW_DATA];
    
    //if ([passDev isMemberOfClass:[TS100 class]]) {
    //    TS100* ts100 = (TS100 *) passDev;
    //}
}

- (IBAction)actInventory:(id)sender {
    [passDev startInventory:ET_PC_EPC];
}
- (IBAction)actStopInventory:(id)sender {
    [passDev stopInventory];
}
- (IBAction)actClearList:(id)sender {
    [allTagItems removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark Tableview Delegate Method


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allTagItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TagItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagItemCell" forIndexPath:indexPath];
    
    
    GNPTagInfo* tagItem = [allTagItems objectAtIndex:indexPath.row];
    
    
    NSString* strNo;
    NSString* strEPC;
    NSString* strCount;
    
    
    strNo = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    strEPC = [NSString stringWithFormat:@"%@",tagItem.EPCHexString];
    strCount = [NSString stringWithFormat:@"%d",tagItem.Count];
    
    cell.labNo.text = strNo;
    cell.labEPC.text = strEPC;
    cell.labCount.text = strCount;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



-(void)delayAction {
    NSLog(@"InventoryViewController delayAction getFirmwareVersion");
    [passDev getFirmwareVersion];
}


-(void)didGeneralSuccess:(NSString*)strCMDName{
    NSLog(@"InventoryViewController didGeneralSuccess strCMDName = %@",strCMDName);
    
    [self showToast:strCMDName message:@"Success"];
    if ([strCMDName isEqualToString:@"InitializeDevice"]) {
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.3];
    }
    
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGeneralSuccess, strCMDName = %@",strCMDName);
}
-(void)didGeneralERROR:(NSString*)strCMDName ErrMessage:(NSString*)strErrorMessage{
    
//    [self showToast:strCMDName message:@"ERROR"];
    NSLog(@"InventoryViewController didGeneralERROR");
    
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGeneralERROR, strCMDName = %@, strErrorMessage = %@",strCMDName, strErrorMessage);
}
- (void)didGetBLEFirmwareVersion:(NSString *)fwVer {
     NSLog(@"didGetBLEFirmwareVersion = %@",fwVer);
    [passDev getDevInfo]._bleDevInfo.devROMVersion = fwVer;
    if (childViewController) {
           [childViewController updateBLEFirmwareVersion:fwVer];
       }
    
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetBLEFirmwareVersion, fwVer = %@",fwVer);
}
- (void)didGetFirmwareVersion:(NSString *)fwVer {
     NSLog(@"didGetFirmwareVersion = %@",fwVer);
    [passDev getDevInfo].devROMVersion = fwVer;
    if (childViewController) {
        [childViewController reloadData];
    }
    
    [passDev getBLEFirmwareVersion];
}

-(void)didReadTag:(NSData *)data{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didReadTag, data = %@",data);
}

-(void)didGetRfPower:(int)rfPower{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetRfPower, rfPower = %d",rfPower);
}
-(void)didGetRfSensitivity:(RfSensitivityLevel)rfSensitivity{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetRfSensitivity, rfSensitivity = %d",rfSensitivity);
}
-(void)didGetTriggerType:(TriggerType)triggerType{
    
}

- (void)didDiscoverTagInfoEx:(GNPDecodedTagData *)decodedTagData {
    NSLog(@"didDiscoverTagInfoEx");
    GNPTagInfo* taginfo = [[GNPTagInfo alloc]init];
    taginfo.EPCHexString = [decodedTagData getTIDHexString];
    if ([allTagItems count] == 0) {
        [allTagItems addObject:taginfo];
    }else {
        int countList = 0;
        for (int i = 0; i < [allTagItems count]; i++) {
            
            GNPTagInfo* temp = [allTagItems objectAtIndex:i];
            if ([temp.EPCHexString isEqualToString:taginfo.EPCHexString]) {
                [temp updateCount:temp.Count+1];
                [allTagItems replaceObjectAtIndex:i withObject:temp];
            }else {
                countList++;
            }
        }
        if (countList == [allTagItems count]) {
            [allTagItems addObject:taginfo];
        }
    }
    [self.tableView reloadData];
}

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
    if ([allTagItems count] == 0) {
        [allTagItems addObject:taginfo];
    }else {
        int countList = 0;
        for (int i = 0; i < [allTagItems count]; i++) {
            
            GNPTagInfo* temp = [allTagItems objectAtIndex:i];
            if ([temp.EPCHexString isEqualToString:taginfo.EPCHexString]) {
                [temp updateCount:temp.Count+1];
                [allTagItems replaceObjectAtIndex:i withObject:temp];
            }else {
               countList++;
            }
        }
        if (countList == [allTagItems count]) {
            [allTagItems addObject:taginfo];
        }
    }
    [self.tableView reloadData];
}
-(void)didTagRemoved:(GNPTagInfo*)taginfo{
    // To be finished
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"DevConnStatusView"]) {
        
        DevDetailTabBarViewController* ctrler = (DevDetailTabBarViewController*)self.tabBarController;
        passDev = [ctrler getUHFDevice];
        
        
        
        childViewController = (DevConnStatusViewController *) [segue destinationViewController];
        [childViewController setUHFDevice:passDev];
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

-(void)didGetFrequencyList:(NSArray *)frequencys{
    // API Testing, Jack Jang, 2020/06/25
    NSString* strFrequency = @"";
    for (int i = 0 ; i < [frequencys count]; i++) {
        double num = [[frequencys objectAtIndex:i]doubleValue];
        strFrequency = [NSString stringWithFormat:@"%@%0.2f, ", strFrequency, num];
    }
    strFrequency = [strFrequency substringWithRange:NSMakeRange(0, [strFrequency length]-2)];
    [GLog D:@"API Testing : Callback for getFrequency" Msn:strFrequency];
}

-(void)didGetQValue:(Byte) qValue{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetQValue, qValue = %d",qValue);
}

-(void)didGetSessionAnd:(Session)session Target:(Target) target{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetSessionAnd, session= %d, target = %d",session, target);
}

-(void)didGetTagRemovedThreshold:(int)missingInventoryThreshold{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetTagRemovedThreshold, missingInventoryThreshold = %d",missingInventoryThreshold);
}

-(void)didGetInventoryRoundInterval:(int)tenMilliSeconds{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetInventoryRoundInterval, tenMilliSeconds = %d",tenMilliSeconds);
}

-(void)didGetRxDecode:(int)rxDecode{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetRxDecode, rxDecode = %d",rxDecode);
}

-(void)didGetLinkFrequency:(int)linkFrequency{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetLinkFrequency, linkFrequency = %d",linkFrequency);
}

-(void)didGetProfile:(int)profile{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetProfile, profile = %d",profile);
}

-(void)didGetBleDeviceName:(NSString *)devName{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetBLEDeviceName, devName = %@",devName);
}

-(void)didGetInventoryActiveMode:(ActiveMode)activeMode{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetInventoryActiveMode, activeMode = %d",activeMode);
}

-(void)didGetBuzzerOperationMode:(BuzzerOperationMode) bom{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetBuzzerOperationMode, bom = %d",bom);
}

- (void)didGetFilter:(TagDataEncodeType)tagDataEncodeTypes{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetFilter, tagDataEncodeTypes = %d",tagDataEncodeTypes);
}

//-(void)didGetFilter:(NSArray *)tagDataEncodeTypeList{
//    // API Testing, Jack Jang, 2020/06/25
//    NSString* strTagDataEncodeType = @"";
//    for (int i = 0 ; i < [tagDataEncodeTypeList count]; i++) {
//        double num = [[tagDataEncodeTypeList objectAtIndex:i]doubleValue];
//        strTagDataEncodeType = [NSString stringWithFormat:@"%@%0.2f, ", strTagDataEncodeType, num];
//    }
//    strTagDataEncodeType = [strTagDataEncodeType substringWithRange:NSMakeRange(0, [strTagDataEncodeType length]-2)];
//    [GLog D:@"API Testing : Callback for didGetFilter" Msn:strTagDataEncodeType];
//}

-(void)didGetEventType:(EventType) eventType{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetEventType, eventType = %d",eventType);
}

-(void)didGetOutputInterfaces:(int) settingValue {
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetOutputInterfaces, settingValue = %d",settingValue);
}

-(void)didGetPostDataDelimiter:(PostDataDelimiter)postDataDelimiter MemoryBankSelection:(MemoryBankSelection)memoryBankSelection{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetPostDataDelimiter, postDataDelimiter = %d, memoryBankSelection = %d",postDataDelimiter, memoryBankSelection);
}

-(void)didGetTagMemorySelection:(TagMemorySelection)tagMemorySelection{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetTagMemorySelection, tagMemorySelection = %d",tagMemorySelection);
}

-(void)didGetTagPresentedRepeatInterval:(int)interval {
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetTagPresentedRepeatInterval, interval = %d",interval);
}

-(void)didGetWiFiMacAddress:(NSString *)wifiMacAddress{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetMacAddress, macAddress = %@",wifiMacAddress);
}

-(void)didGetRemoteHost:(int)connectTime InetSocketAddress:(InetSocketAddress *)inetSocketAddress {
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetRemoteHost, connectTime = %d, address = %@, port = %d", connectTime, [[inetSocketAddress getHost] getHostAddress], [inetSocketAddress getPort]);
}

-(void)didGetBarcodeReadFormat:(BarcodeFormat) barcodeFormat{
    // API Testing, Jack Jang, 2020/06/25
    NSLog(@"API Testing : Callback for didGetBarcodeReadFormat, barcodeFormat = %d",barcodeFormat);
}

// New develoed at 2020/07/10, not test yet
//-(void)didGetFieldSeparator:(Byte) separator {
//    // API Testing, Jack Jang, 2020/07/10
//    NSLog(@"API Testing : Callback for didGetFieldSeparator, fieldSeparator = %d",separator);
//}
//
//-(void)didGetTransformEpcState:(State)state {
//    // API Testing, Jack Jang, 2020/07/10
//    NSLog(@"API Testing : Callback for didGetTransformEpcState, state = %d",state);
//}

@end
