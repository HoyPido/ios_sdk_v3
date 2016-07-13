//
//  MobileConnectProduct.m
//  MobileConnectSDK
//
//  Created by jenkins on 06/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MobileConnectProduct.h"

const struct MobileConnectProductStruct MobileConnectProduct =
{
    .MobileConnect = @"openid",
    .MobileConnectAuthentication = @"openid mc_authn",
    .MobileConnectAuthorization = @"openid mc_authz",
    .Identity = {
        .Phone = @"openid mc_identity_phonenumber",
        .Signup = @"openid mc_identity_signup",
        .SignupPlus = @"openid mc_identity_signupplus",
        .NationalID = @"openid mc_identity_nationalid"
    }
};