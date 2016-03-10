//
//  FGApplePayConstant.h
//  AppPayDemo
//
//  Created by weichao on 16/3/9.
//  Copyright © 2016年 weichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>                                 //用户绑定的银行卡信息
#import <PassKit/PKPaymentAuthorizationViewController.h>    //Apple pay的展示控件
#import <AddressBook/AddressBook.h>                         //用户联系信息相关


@interface FGApplePayConstant : NSObject
/**
 *  当前应用支持等支付网络
 *
 *  @return 当前应用支持等支付网络，包括Amex、MasterCard、Visa与银联卡等，可以根据自己项目的需要进行修改
 */
+ (NSArray *)supportedNetworks;

/**
 *  merchant identifier
 */
extern NSString *const FGApplePayConstantMerchantIdentifier;

/**
 *  countryCode
 */
extern NSString *const FGApplePayConstantCountryCode;

/**
 *  currencyCode
 */
extern NSString *const FGApplePayConstantCurrencyCode;
@end
