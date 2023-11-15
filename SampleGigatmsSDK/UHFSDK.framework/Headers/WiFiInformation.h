//
//  WiFiInformation.h
//  UHFSDK
//
//  Created by WadeGigatms on 2023/6/14.
//  Copyright © 2023 Gianni. All rights reserved.
//

#ifndef WiFiInformation_h
#define WiFiInformation_h

typedef NS_ENUM(Byte, WiFiMode){
    WiFi_OFF = 0x00,
    WiFi_AP = 0x01,
    WiFi_Station = 0x02,
    WiFi_Both_AP_And_Station_Mode = 0x03,
};

@interface WiFiInformation : NSObject

-(instancetype)init:(NSData*)data;

@property(nonatomic,assign) NSString* staMacAddress;
@property(nonatomic,assign) WiFiMode wifiMode;
@property(nonatomic,copy) NSString* ssid;
@property(nonatomic,assign) NSString* password;
@property(nonatomic,assign) NSString* apMacAddress;
@property(nonatomic,copy) NSString* apModeSsid;
@property(nonatomic,assign) NSString* apModePassword;
@property(nonatomic,assign) int apModeMaximumConnections;

@end

#endif /* WiFiInformation_h */
