//
//  FGPKPaymentRequestFactory.m
//  AppPayDemo
//
//  Created by weichao on 16/3/9.
//  Copyright © 2016年 weichao. All rights reserved.
//

#import "FGPKPaymentRequestFactory.h"


@implementation FGPKPaymentRequestFactory
+ (PKPaymentRequest *)initialPKPaymentRequestWithshippingMethods:(NSMutableArray *)shippingMethods summaryItems:(NSMutableArray *)summaryItems {
    //设置币种、国家码及merchant标识符等基本信息
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc]init];
    payRequest.countryCode = FGApplePayConstantCountryCode;     //国家代码
    payRequest.currencyCode = FGApplePayConstantCurrencyCode;       //RMB的币种代码
    payRequest.merchantIdentifier = FGApplePayConstantMerchantIdentifier;  //申请的merchantID
    payRequest.supportedNetworks = [FGApplePayConstant supportedNetworks];   //用户可进行支付的银行卡
    payRequest.merchantCapabilities = PKMerchantCapability3DS|PKMerchantCapabilityEMV;      //设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧
    
    //    payRequest.requiredBillingAddressFields = PKAddressFieldEmail;
    //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
    //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
    payRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
    //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
    
    //设置两种配送方式
    payRequest.shippingMethods = shippingMethods;
    
    payRequest.paymentSummaryItems = summaryItems;
    return payRequest;
}



@end
