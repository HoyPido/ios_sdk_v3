//
//  AuthorizationConfigurationParameters.h
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 08/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MCModel.h"

typedef NS_ENUM(NSInteger, MCLoginHint) {
    MSISDNEncrypted,
    MSISDN,
    PCR
};

@interface AuthorizationConfigurationParameters : MCModel

@property (nullable) NSString* version;
@property (nullable) NSString* prompt;
@property (nullable) NSString* ui_locales;
@property (nullable) NSString* id_token_hint;
@property (nullable) NSString* login_hint_token;
@property (nullable) NSString* response_mode;
@property (nullable) NSString* claims;
@property (nullable) NSString* max_age;
@property MCLoginHint loginHint;

- (id)initWithLoginHint:(MCLoginHint)loginHint version:(nullable NSString*)version prompt:(nullable NSString*)prompt uiLocale:(nullable NSString*)uiLocale idTokenHint:(nullable NSString*)idTokenHint loginHintToken:(nullable NSString*)loginHintToken responseMode:(nullable NSString*)responseMode claims:(nullable NSString*)claims maxAge:(nullable NSString*)maxAge;

- (id)initWithVersion:(nullable NSString*)version prompt:(nullable NSString*)prompt uiLocale:(nullable NSString*)uiLocale idTokenHint:(nullable NSString*)idTokenHint loginHintToken:(nullable NSString*)loginHintToken responseMode:(nullable NSString*)responseMode claims:(nullable NSString*)claims maxAge:(nullable NSString*)maxAge;

@end
