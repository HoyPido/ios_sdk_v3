//
//  ViewController.m
//  DemoObjectiveC
//
//  Created by jenkins on 25/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "ViewController.h"

@import MobileConnectSDK;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MobileConnectManager *manager = [MobileConnectManager new];
    
    [manager getAuthorizationTokenInPresenterController:self withContext:@"context" withStringValueScopes:@[@"scope1"] bindingMessage:@"message" completionHandler:^(TokenResponseModel * _Nullable tokenResponseModel, NSError * _Nullable error) {
        
    }];
    
    [manager getAttributeServiceResponse:self context:@"context" stringScopes:@[@"scope1"] bindingMessage:@"binding message" withCompletionHandler: ^(AttributeResponseModel * _Nullable response, NSError * _Nullable error) {
         
     }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
