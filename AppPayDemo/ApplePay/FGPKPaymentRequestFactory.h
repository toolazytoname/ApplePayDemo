//
//  FGPKPaymentRequestFactory.h
//  AppPayDemo
//
//  Created by weichao on 16/3/9.
//  Copyright © 2016年 weichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGApplePayConstant.h"

@interface FGPKPaymentRequestFactory : NSObject
+ (PKPaymentRequest *)initialPKPaymentRequestWithshippingMethods:(NSMutableArray *)shippingMethods summaryItems:(NSMutableArray *)summaryItems;
@end
