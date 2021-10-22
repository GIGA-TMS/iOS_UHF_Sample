//
//  SGTIN96EASTagData.h
//  UHFSDK
//
//  Created by JangJack on 2020/9/5.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <UHFSDK/UHFSDK.h>

#import "SGTIN96TagData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGTIN96EASTagData : SGTIN96TagData

-(instancetype) initWithEpcHader:(EpcHeader) epcHeader Barcode:(NSString *) barcode Filter:(Filter) filter CompanyPrefixLength:(CompanyPrefixLength) companyPrefixLength;

@end

NS_ASSUME_NONNULL_END
