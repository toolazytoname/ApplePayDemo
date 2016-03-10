//
//  FGApplePayConstant.m
//  AppPayDemo
//
//  Created by weichao on 16/3/9.
//  Copyright © 2016年 weichao. All rights reserved.
//

#import "FGApplePayConstant.h"

NSString *const FGApplePayConstantMerchantIdentifier = @"merchant.com.sohu.weichao.test";

NSString *const FGApplePayConstantCountryCode = @"CN";

NSString *const FGApplePayConstantCurrencyCode = @"CNY";

@implementation FGApplePayConstant

+ (NSArray *)supportedNetworks{
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    return supportedNetworks;
}


@end
