//
//  TokenResponseModel.m
//  DiscoveryDemoSDK
//
//  Created by Andoni Dan on 24/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "TokenResponseModel.h"
#import "MCJWTDecoder.h"

@implementation TokenResponseModel

- (instancetype)initWithTokenModel:(TokenModel*)tokenModel
{
    if ((self = [super init]) && tokenModel) {
        
        self.tokenData = tokenModel;
        
        if (tokenModel.id_token) {
            
            MCJWTDecoder *decoder = [[MCJWTDecoder alloc] initWithJWT:tokenModel.id_token];
            
            NSError *mappingToJSONError;
            
            self.decodedToken = [NSJSONSerialization JSONObjectWithData:[decoder decodedValue] options:NSJSONReadingAllowFragments error:&mappingToJSONError];
        }
        else
        {
            NSLog(@"the provided token model had no encoded jwt");
        }
        
        return self;
    }
    else
    {
        return nil;
    }
}

@end
