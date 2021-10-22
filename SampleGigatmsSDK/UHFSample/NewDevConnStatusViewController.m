//
//  NewDevConnStatusViewController.m
//  UHFSample
//
//  Created by JangJack on 2020/8/23.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import "NewDevConnStatusViewController.h"
#import <UHFSDK/GNetPlus.h>
#import <UHFSDK/GNPTagInfo.h>
#import <UHFSDK/GNPLockInfos.h>
#import <UHFSDK/TS100.h>
#import <UHFSDK/TS100A.h>
#import <UHFSDK/TS800.h>
#import <UHFSDK/UR0250.h>

@interface NewDevConnStatusViewController () <DevConnectionCallback>
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UILabel *labFWVer;
@property (weak, nonatomic) IBOutlet UILabel *labBLEFWVer;
@property (weak, nonatomic) IBOutlet UILabel *labDevInfo;
@property (weak, nonatomic) IBOutlet UILabel *labDevConnStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIStackView *stackBLEInfo;

@end

@implementation NewDevConnStatusViewController {
    UHFDevice* passDev;
    BOOL isConnected;
}

- (void)setUHFDevice:(UHFDevice*) dev{
    passDev = dev;
}

-(void)reloadData{
    if (passDev) {
        
        switch ([passDev getDevInfo].connectType) {
            case Type_WiFi_UDP:
            {
                self.stackBLEInfo.hidden = YES;
            }
                break;
            case Type_WiFi_TCP:
            {
                self.stackBLEInfo.hidden = YES;
            }
                break;
            case Type_BLE:
            {
                self.stackBLEInfo.hidden = NO;
            }break;
            default:
                break;
        }
        
        [passDev setConnCallback:self];
        [self.labFWVer setText:passDev.getDevInfo.devROMVersion];
        [self.labDevInfo setText:passDev.getDevInfo.devUidInfo];
        [self.labDevConnStatus setText:passDev.getDevInfo.strConnStauts];
        [self didUpdateConnectionStatus:passDev Status:passDev.getDevInfo.currentConnStatus err_code:0];
        
        [self.labBLEFWVer setText:passDev.getDevInfo._bleDevInfo.devROMVersion];
    }
}

-(void)updateBLEFirmwareVersion:(NSString*)bleVer{
    [self.labBLEFWVer setText:bleVer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [passDev setConnCallback:self];
    [self.labDevInfo setText:passDev.getDevInfo.devUidInfo];
    [self.labDevConnStatus setText:passDev.getDevInfo.strConnStauts];
    [self didUpdateConnectionStatus:passDev Status:passDev.getDevInfo.currentConnStatus err_code:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actConnect:(id)sender {
    
    if (passDev) {
        switch (passDev.getDevInfo.currentConnStatus) {
            case DevDisconnected:
            {
                [passDev Connect];
            }
                break;
            case DevConnected:
            {
                [passDev DisConnect];
            }
                break;
            default:
                [passDev DisConnect];
                break;
        }
        
        
    }
}

- (void)didUpdateConnectionStatus:(BaseDevice*)dev Status:(GTDevConnStatus) connectedState err_code:(int)nErrCode{
    
    switch (connectedState) {
        case DevConntError:
            [self.labDevConnStatus setText:@"Connect Error"];
            isConnected = false;
            break;
        case DevDisconnected:
            [self.labDevConnStatus setText:@"Disconnected"];
            [self.labDevConnStatus setBackgroundColor:UIColor.redColor];
            [self.btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            isConnected = false;
            break;
        case DevConnecting:
            [self.labDevConnStatus setText:@"Connecting"];
            [self.labDevConnStatus setBackgroundColor:UIColor.clearColor];
            [self.btnConnect setTitle:@"Connecting" forState:UIControlStateNormal];
            isConnected = false;
            break;
        case DevConnected:
            [self.labDevConnStatus setText:@"Connected"];
            [self.labDevConnStatus setBackgroundColor:UIColor.greenColor];
            [self.btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
            if (!isConnected) {
                NSLog(@"DevConnStatusViewController DevConnected getFirmwareVersion");
                [passDev getFirmwareVersion];
                [self performSelector:@selector(delayAction) withObject:nil afterDelay:0.3];
            }
            isConnected = true;
            break;
        default:
            break;
    }
}

-(void)delayAction {
    NSLog(@"NewDevConnStatusViewController delayAction getBleRomVersion");
    if ([self->passDev isMemberOfClass:[TS100 class]]) {
        TS100 *ts100 = (TS100 *) self->passDev;
        
        [ts100 getBleRomVersion];
    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
        TS800 *ts800 = (TS800 *) self->passDev;
        
        [ts800 getBleRomVersion];
    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
        UR0250 *ur0250 = (UR0250 *) self->passDev;
        
        [ur0250 getBleRomVersion];
    }
}

-(void)clearLog {
    NSString *logs = [self.logTextView text];
    
    [self.logTextView setText:@""];
    NSRange bottom = NSMakeRange(self.logTextView.text.length, 0);
    [self.logTextView scrollRangeToVisible:bottom];
    
    [self.logTextView setScrollEnabled:NO];
    [self.logTextView setScrollEnabled:YES];
}

-(void)addLog:(NSString *) text {
    NSString *logs = [self.logTextView text];
    
    [self.logTextView setText:[NSString stringWithFormat:@"%@\n%@", logs, text]];
    NSRange bottom = NSMakeRange(self.logTextView.text.length, 0);
    [self.logTextView scrollRangeToVisible:bottom];
    
    [self.logTextView setScrollEnabled:NO];
    [self.logTextView setScrollEnabled:YES];
}

-(void)displayLog:(NSString *) text {
    [self.logTextView setText:text];
}

@end
