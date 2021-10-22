//
//  UDCTagData.h
//  UHFSDK
//
//  Created by JangJack on 2020/9/5.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <UHFSDK/UHFSDK.h>

#import "BaseTagData.h"

NS_ASSUME_NONNULL_BEGIN

@interface UDCTagData : BaseTagData

-(instancetype) initWithEpcHader:(EpcHeader) epcHeader Barcode:(NSString *) barcode;
-(NSData *) getSpecificDataBytes;

@end

NS_ASSUME_NONNULL_END
