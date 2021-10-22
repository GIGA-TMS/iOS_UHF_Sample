//
//  DevConnStatusViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/4/18.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "DevConnStatusViewController.h"

@interface DevConnStatusViewController () <DevConnectionCallback>

@end

@implementation DevConnStatusViewController
{
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
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [passDev setConnCallback:self];
    [self.labDevInfo setText:passDev.getDevInfo.devUidInfo];
    [self.labDevConnStatus setText:passDev.getDevInfo.strConnStauts];
    [self didUpdateConnectionStatus:passDev Status:passDev.getDevInfo.currentConnStatus err_code:0];
}


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
            }
            isConnected = true;
            
            break;
    }
}



@end
