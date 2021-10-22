//
//  UR0250.h
//  UHFSDK
//
//  Created by Gianni on 2019/4/29.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UHFSDK/UHFSDK.h>
#import <UHFSDK/UHFDevice.h>
#import <UHFSDK/IUR0250Listener.h>
#import <UHFSDK/BaseTagEvent.h>
NS_ASSUME_NONNULL_BEGIN

@interface UR0250 : UHFDevice



@property (nonatomic, assign) id<IUR0250Listener> ur0250Listener;

/**
 Initialize setting of UR0250, please call it after connected with remote UR0250.
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

@end

NS_ASSUME_NONNULL_END
