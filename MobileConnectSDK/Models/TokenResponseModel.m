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

- (nullable instancetype)initWithTokenModel:(nullable TokenModel*)tokenModel discoveryResponse:(nullable DiscoveryResponse*)discoveryResponse
{
    if ((self = [super init]) && tokenModel) {
        
        self.tokenData = tokenModel;
        self.discoveryResponse = discoveryResponse;
        
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
