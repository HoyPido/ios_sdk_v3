//
//  MobileConnectProduct.m
//  MobileConnectSDK
//
//  Created by jenkins on 06/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MobileConnectProduct.h"

NSString *const MobileConnect = @"openid";
NSString *const MobileConnectAuthentication = @"openid mc_authn";
NSString *const MobileConnectAuthorization = @"openid mc_authz";

NSString *const MobileConnectIdentityPhone = @"openid mc_identity_phonenumber";
NSString *const MobileConnectIdentitySignup = @"openid mc_identity_signup";
NSString *const MobileConnectIdentitySignupPlus = @"openid mc_identity_signupplus";
NSString *const MobileConnectIdentityNationalID = @"openid mc_identity_nationalid";

NSString *const MobileConnectPhone = @"phone";
NSString *const MobileConnectAddress = @"address";
NSString *const MobileConnectProfile = @"profile";
NSString *const MobileConnectEmail = @"email";

//Indian scopes
NSString *const MobileConnectIndian = @"openid mc_identity_phonenumber_hashed";
NSString *const MobileConnectIndiaTC = @"mc_india_tc mc_identity_phonenumber_hashed";
NSString *const MobileConnectMNVValidate = @"mc_mnv_validate mc_identity_phonenumber_hashed";
NSString *const MobileConnectMNVValidatePlus = @"mc_mnv_validate_plus mc_identity_phonenumber_hashed";
