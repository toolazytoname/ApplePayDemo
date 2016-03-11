//
//  FGApplePayHelper.m
//  AppPayDemo
//
//  Created by weichao on 16/3/9.
//  Copyright © 2016年 weichao. All rights reserved.
//

#import "FGApplePayHelper.h"
#import "FGPKPaymentRequestFactory.h"

@interface FGApplePayHelper()
/**
 *  账单
 */
@property (nonatomic ,strong) NSMutableArray *summaryItems;

/**
 *  配送方式
 */
@property (nonatomic ,strong) NSMutableArray *shippingMethods;
@end

@implementation FGApplePayHelper
#pragma mark -Getter&Setter
- (NSMutableArray *)shippingMethods {
    if (!_shippingMethods) {
        //设置两种配送方式
        PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
        freeShipping.identifier = @"freeshipping";
        freeShipping.detail = @"6-8 天 送达";
        
        PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"极速送达" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
        expressShipping.identifier = @"expressshipping";
        expressShipping.detail = @"2-3 小时 送达";
        _shippingMethods = [NSMutableArray arrayWithArray:@[freeShipping, expressShipping]];
    }
    return _shippingMethods;
}

- (NSMutableArray *)summaryItems {
    if (!_summaryItems) {
        NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:1275 exponent:-2 isNegative:NO];   //12.75
        PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"商品价格" amount:subtotalAmount];
        
        NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithString:@"-12.74"];      //-12.74
        PKPaymentSummaryItem *discount = [PKPaymentSummaryItem summaryItemWithLabel:@"优惠折扣" amount:discountAmount];
        
        NSDecimalNumber *methodsAmount = [NSDecimalNumber zero];
        PKPaymentSummaryItem *methods = [PKPaymentSummaryItem summaryItemWithLabel:@"包邮" amount:methodsAmount];
        
        NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
        totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
        totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
        totalAmount = [totalAmount decimalNumberByAdding:methodsAmount];
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"懒得起名" amount:totalAmount];  //最后这个是支付给谁。哈哈，快支付给我
        
        _summaryItems = [NSMutableArray arrayWithArray:@[subtotal, discount, methods, total]];
    }
    return _summaryItems;
}

- (PKPaymentRequest *)paymentRequest {
    if (![self authorization]) {
        NSLog(@"设备Applepay权限检测未通过");
        return nil;
    }
    if (!_paymentRequest) {
        _paymentRequest = [FGPKPaymentRequestFactory initialPKPaymentRequestWithshippingMethods:self.shippingMethods summaryItems:self.summaryItems];
    }
    return _paymentRequest;
}
/**
 *  检测
 *
 *  @return 检测
 */
- (bool)authorization {
    bool authorizationResult = NO;
    if (![PKPaymentAuthorizationViewController class]) {
        //PKPaymentAuthorizationViewController需iOS8.0以上支持
        NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return authorizationResult;
    }
    //检查当前设备是否可以支付
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        //支付需iOS9.0以上支持
        NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return authorizationResult;
    }
    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
    NSArray *supportedNetworks = [FGApplePayConstant supportedNetworks];
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
        NSLog(@"没有绑定支付卡");
        return authorizationResult;
    }
    authorizationResult = YES;
    NSLog(@"可以支付，开始建立支付请求");
    return authorizationResult;
}


#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //contact送货地址信息，PKContact类型
    NSPersonNameComponents *name = contact.name;                //联系人姓名
    CNPostalAddress *postalAddress = contact.postalAddress;     //联系人地址
    NSString *emailAddress = contact.emailAddress;              //联系人邮箱
    CNPhoneNumber *phoneNumber = contact.phoneNumber;           //联系人手机
    NSString *supplementarySubLocality = contact.supplementarySubLocality;  //补充信息,iOS9.2及以上才有
    
    NSLog(@"name:%@;postalAddress:%@;emailAddress:%@;phoneNumber:%@;supplementarySubLocality:%@;",name,postalAddress,emailAddress,phoneNumber,supplementarySubLocality);
    //送货信息选择回调，如果需要根据送货地址调整送货方式，比如普通地区包邮+极速配送，偏远地区只有付费普通配送，进行支付金额重新计算，可以实现该代理，返回给系统：shippingMethods配送方式，summaryItems账单列表，如果不支持该送货信息返回想要的PKPaymentAuthorizationStatus
    completion(PKPaymentAuthorizationStatusSuccess, self.shippingMethods, self.summaryItems);
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //配送方式回调，如果需要根据不同的送货方式进行支付金额的调整，比如包邮和付费加速配送，可以实现该代理
    PKShippingMethod *oldShippingMethod = [self.summaryItems objectAtIndex:2];
    PKPaymentSummaryItem *total = [self.summaryItems lastObject];
    total.amount = [total.amount decimalNumberBySubtracting:oldShippingMethod.amount];
    total.amount = [total.amount decimalNumberByAdding:shippingMethod.amount];
    
    [self.summaryItems replaceObjectAtIndex:2 withObject:shippingMethod];
    [self.summaryItems replaceObjectAtIndex:3 withObject:total];
    
    completion(PKPaymentAuthorizationStatusSuccess, self.summaryItems);
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //支付银行卡回调，如果需要根据不同的银行调整付费金额，可以实现该代理
    completion(self.summaryItems);
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion{

    PKPaymentToken *payToken = payment.token;
    //支付凭据，发给服务端进行验证支付是否真实有效
    PKContact *billingContact = payment.billingContact;     //账单信息
    PKContact *shippingContact = payment.shippingContact;   //送货信息
    PKShippingMethod *shippingMethod = payment.shippingMethod;     //送货方式
    

    
    
    NSLog(@"去服务器端校验 payToken:%@\n;billingContact:%@\n;shippingContact:%@\n;shippingMethod:%@\n;",payToken,billingContact,shippingContact,shippingMethod);
    //等待服务器返回结果后再进行系统block调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //模拟服务器通信
        completion(PKPaymentAuthorizationStatusSuccess);
    });
}


- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
