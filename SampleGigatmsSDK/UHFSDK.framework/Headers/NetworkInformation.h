//
//  NetworkInformation.h
//  GIGATMSSDK
//
//  Created by WadeGigatms on 2023/6/14.
//  Copyright © 2023 Gianni. All rights reserved.
//

#ifndef NetworkInformation_h
#define NetworkInformation_h

@interface NetworkInformation : NSObject

-(instancetype)init:(NSData*)data;

@property(nonatomic,assign) NSString* mask;
@property(nonatomic,assign) NSString* seperator;
@property(nonatomic,copy) NSString* hostName;

@property(nonatomic,copy) NSString* loginId;
@property(nonatomic,copy) NSString* loginPassword;

@property(nonatomic,assign) BOOL DHCPEnable;
@property(nonatomic,assign) NSString* DHCP_ipAddress;
@property(nonatomic,assign) NSString* DHCP_subnetMask;
@property(nonatomic,assign) NSString* DHCP_gatewayIp;
@property(nonatomic,assign) NSString* DHCP_primaryDNSIp;
@property(nonatomic,assign) NSString* DHCP_secondaryDNSIp;

@property(nonatomic,assign) BOOL UDP_ServerEnable;
@property(nonatomic,assign) NSString* UDP_ServerPort;
@property(nonatomic,assign) BOOL UDP_ClientEnable;
@property(nonatomic,assign) NSString* UDP_ClientRemoteServerIp;
@property(nonatomic,assign) NSString* UDP_ClientRemoteServerPort;

@property(nonatomic,assign) BOOL TCP_ServerEnable;
@property(nonatomic,assign) NSString* TCP_ServerPort;
@property(nonatomic,assign) int TCP_ServerMaximumConnections;
@property(nonatomic,assign) int TCP_ServerConnectionTimeout;

@property(nonatomic,assign) BOOL TCP_ClientEnable;
@property(nonatomic,assign) NSString* TCP_ClientRemoteServerIp;
@property(nonatomic,assign) NSString* TCP_ClientRemoteServerPort;
@property(nonatomic,assign) int TCP_ClientConnectionTimeout;

@property(nonatomic,assign) NSString* STA_ipAddress;
@property(nonatomic,assign) NSString* STA_subnetMask;
@property(nonatomic,assign) NSString* STA_gatewayIp;
@property(nonatomic,assign) NSString* STA_primaryDNSIp;
@property(nonatomic,assign) NSString* STA_secondaryDNSIp;

@end

#endif /* NetworkInformation_h */
