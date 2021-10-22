//
//  TS800.h
//  UHFSDK
//
//  Created by Gianni on 2019/4/29.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "UHFDevice.h"
#import <UHFSDK/BaseTagEvent.h>

NS_ASSUME_NONNULL_BEGIN

@interface TS800 : UHFDevice
/**
 Initialize setting of TS800, please call it after connected with remote TS800.
 */
-(void)cmdInitializeSettings;

/// Get Device BLE Neme
-(void)getBleDeviceName;

/// Set Device BLE Neme
/// @param devName Device BLE Neme
-(void)setBleDeviceName:(NSString*)devName;

-(void)getBleMacAddress;


/**
 Get Device BLE module
 Gets the firmware program version running on the device BLE module.
 */
-(void)getBleRomVersion;

-(void)getInventoryActiveMode:(BOOL) isTemp;

-(void)setInventoryActiveMode:(BOOL) isTemp InventoryActiveMode:(ActiveMode) activeMode;

-(void)getTriggerType:(BOOL) isTemp;

-(void)setTriggerType:(BOOL)isTemp TriggerType:(NSMutableSet *) triggerType;

-(void)getIOState;

-(void)setIOState: (IONumber) ioNumber IOState:(IOState) ioState;

-(void)getOutputInterface:(BOOL) isTemp;

-(void)setOutputInterface:(BOOL) isTemp KeyboardSimulation:(KeyboardSimulation) keyboardSimulation OutputInterface:(OutputInterface) outputInterface;

-(void)getBuzzerOperationMode:(BOOL) isTemp;

-(void)setBuzzerOperationMode:(BOOL) isTemp BuzzerOperationMode:(BuzzerOperationMode) bom;

-(void)getScanMode:(BOOL) isTemp;

-(void)setScanMode:(BOOL) isTemp ScanMode:(ScanMode) sm;

-(void)getCommandTriggerState;

-(void)setCommandTriggerState:(State) state;

-(void)setWifiSettings:(NSString*)strSSID PWD:(NSString*)strPwd;

-(void)setWifiSettings:(NSString*)strSSID PWD:(NSString*)strPwd IP:(NSString*)strIP Gateway:(NSString*)strGateway  SubNetMask:(NSString*)strSubNetMask;

-(void)setTagPresentedRepeatInterval:(BOOL)isTemp Time:(int)time;

-(void)getTagPresentedRepeatInterval:(BOOL)isTemp;

-(void)getEventType:(BOOL) isTemp;

-(void)setEventType:(BOOL) isTemp EventType:(BaseTagEvent *) eventType;

-(void)getWiFiMacAddress;

-(void)setRemoteHost:(int) connectTimeout InetSocketAddress:(InetSocketAddress *) inetSocketAddress;

-(void)getRemoteHost;

-(void)getIpAddress;

@end

NS_ASSUME_NONNULL_END
