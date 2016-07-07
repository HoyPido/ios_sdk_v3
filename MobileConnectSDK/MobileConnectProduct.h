//
//  MobileConnectProduct.h
//  MobileConnectSDK
//
//  Created by jenkins on 06/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

struct IdentityProductStruct
{
    __unsafe_unretained NSString *const Phone;
    __unsafe_unretained NSString *const Signup;
    __unsafe_unretained NSString *const SignupPlus;
    __unsafe_unretained NSString *const NationalID;
};

struct MobileConnectProductStruct
{
    __unsafe_unretained NSString *const MobileConnect;
    __unsafe_unretained NSString *const MobileConnectAuthentication;
    __unsafe_unretained NSString *const MobileConnectAuthorization;
    const struct IdentityProductStruct Identity;
};

extern const struct MobileConnectProductStruct MobileConnectProduct;