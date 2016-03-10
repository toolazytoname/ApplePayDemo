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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClicked:(id)sender {
    FGApplePayHelper *applePayHelper =  [[FGApplePayHelper alloc] init];
    PKPaymentRequest *paymentRequest = applePayHelper.paymentRequest;
    PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:paymentRequest];
    view.delegate = applePayHelper;
    [self presentViewController:view animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
