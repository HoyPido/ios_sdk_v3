//
//  ViewController.m
//  DemoObjectiveC
//
//  Created by jenkins on 11/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "ViewController.h"

@import MobileConnectSDK;

@interface ViewController ()<MobileConnectManagerDelegate>

@end

@implementation ViewController

- (IBAction)action:(id)sender {
    MobileConnectManager *manager = [MobileConnectManager new];
    
    manager.delegate = self;
    
    [manager getTokenInPresenterController:self withCompletionHandler:^(TokenResponseModel * _Nullable tokenResponseModel, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)mobileConnectDidGetTokenResponse:(TokenResponseModel *)tokenResponse
{
    NSLog(@"token response : %@", tokenResponse);
}

@end
