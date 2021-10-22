//
//  GTCommonHeader.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/3/20.
//  Copyright © 2019 Gianni. All rights reserved.
//

#ifndef GTCommonHeader_h
#define GTCommonHeader_h

#import "GLog.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, ProtocolType){
    PT_GigaTms      = 0x00,
    PT_GNetPlus     = 0x01,
    PT_GNet         = 0x02,
    PT_OSDP         = 0x03
};
typedef NS_ENUM(short, GTClassCode){
    CC_SLI200       = 0x01,
    CC_UHF       = 0xFF
};

typedef NS_ENUM(int, GTDevConnStatus){
    DevConntPwdError = -2,
    DevConntError = -1,
    DevDisconnected = 0,
    DevConnecting = 1,
    DevConnected = 2
};

typedef struct tagProdName {
    unsigned char* pName;
    int nNameLen;
} SPRODNAME, *LPSPRODNAME;

typedef struct tagSwitcherStatus
{
    int index;
    BOOL isON;
} SSWTSTATUS, *LPSSWTSTATUS;

typedef NS_ENUM(int, GTConnectType){
    Type_WiFi_UDP = 0,
    Type_WiFi_TCP = 1,
    Type_BLE = 2
};




#endif /* GTCommonHeader_h */
