//
//  ViewController.m
//  AppPayDemo
//
//  Created by weichao on 16/3/9.
//  Copyright © 2016年 weichao. All rights reserved.
//

#import "ViewController.h"
#import "FGApplePayHeaders.h"

@interface ViewController ()
@property (nonatomic, strong) FGApplePayHelper *applePayHelper;
@end

@implementation ViewController

- (FGApplePayHelper *)applePayHelper
{
    if (!_applePayHelper) {
        _applePayHelper =  [[FGApplePayHelper alloc] init];
    }
    return _applePayHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addPKPaymentButton];
}

- (void)addPKPaymentButton
{
    PKPaymentButton *paymentButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
    paymentButton.center = self.view.center;
    [paymentButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:paymentButton];
}

- (IBAction)buttonClicked:(id)sender {
    PKPaymentRequest *paymentRequest = self.applePayHelper.paymentRequest;
    PKPaymentAuthorizationViewController *paymentAuthorizationViewController = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:paymentRequest];
    paymentAuthorizationViewController.delegate = self.applePayHelper;
    [self presentViewController:paymentAuthorizationViewController animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
