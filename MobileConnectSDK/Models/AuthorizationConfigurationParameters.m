//
//  AuthorizationConfigurationParameters.m
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 08/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "AuthorizationConfigurationParameters.h"
#import <MobileConnectSDK/MobileConnectSDK-Swift.h>

@implementation AuthorizationConfigurationParameters

-(id)initWithPrompt:(NSString *)prompt uiLocale:(NSString *)uiLocale idTokenHint:(NSString *)idTokenHint loginHintToken:(NSString *)loginHintToken responseMode:(NSString *)responseMode claims:(NSString *)claims maxAge:(nullable NSString*)maxAge {
    self = [super init];
    if(self) {
        self.prompt = prompt;
        self.ui_locales = uiLocale;
        self.id_token_hint = idTokenHint;
        self.response_mode = responseMode;
        self.login_hint_token = loginHintToken;
        self.claims = claims;
        self.max_age = maxAge;
    }
    
    return self;
}

@end
