//
//  TokenResponseModel.m
//  DiscoveryDemoSDK
//
//  Created by Andoni Dan on 24/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "TokenResponseModel.h"
#import <MobileConnectSDK/MobileConnectSDK-Swift.h>

@implementation TokenResponseModel

- (instancetype)initWithTokenModel:(TokenModel*)tokenModel
{
    if ((self = [super init]) && tokenModel) {
        
        self.tokenData = tokenModel;
        
        if (tokenModel.id_token) {
            self.decodedToken = [[[JWTDecoder alloc] initWithTokenString:tokenModel.id_token] decodedDictionary];
        }
        else
        {
            NSLog(@"the provided token model had no encoded jwt");
        }
        
        return self;
    }
    
    return nil;
}

@end
