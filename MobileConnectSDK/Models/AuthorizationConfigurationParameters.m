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

/**
 Initialize object with login_hint parameter
 */
- (id)initWithLoginHint:(MCLoginHint)loginHint version:(nullable NSString*)version prompt:(nullable NSString*)prompt uiLocale:(nullable NSString*)uiLocale idTokenHint:(nullable NSString*)idTokenHint loginHintToken:(nullable NSString*)loginHintToken responseMode:(nullable NSString*)responseMode claims:(nullable NSString*)claims {
    
    self = [super init];
    if(self) {
        self.version = version;
        self.prompt = prompt;
        self.ui_locales = uiLocale;
        self.id_token_hint = idTokenHint;
        self.response_mode = responseMode;
        self.login_hint_token = loginHintToken;
        self.claims = claims;
        self.loginHint = loginHint;
    }
    
    return self;
}

/**
Initialize object with default login_hint
 */
-(id)initWithVersion:(NSString *)version prompt:(NSString *)prompt uiLocale:(NSString *)uiLocale idTokenHint:(NSString *)idTokenHint loginHintToken:(NSString *)loginHintToken responseMode:(NSString *)responseMode claims:(NSString *)claims {
    self = [self initWithLoginHint:MSISDNEncrypted version:version prompt:prompt uiLocale:uiLocale idTokenHint:idTokenHint loginHintToken:loginHintToken responseMode:responseMode claims:claims];
    return self;
}

@end
