//
//  UserInfoResponse.h
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 06/10/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import <MobileConnectSDK/MobileConnectSDK.h>
#import "AttributeResponseModel.h"

@interface UserInfoResponse : MCModel

@property (nullable) NSString *sub;
@property (nullable) NSString *family_name;
@property (nullable) NSString *given_name;
@property (nullable) NSString *phone_number;
@property BOOL phone_number_verified;
@property (nullable) NSString *updated_at;
@property (nullable) AddressModel *address;
@property (nullable) NSString *birth_date;
@property (nullable) NSString *website;
@property (nullable) NSString *preferred_username;
@property (nullable) NSString *gender;
@property (nullable) NSString *email;
@property (nullable) NSString *locale;
@property (nullable) NSString *picture;
@property BOOL email_verified;
@property (nullable) NSString *nickname;
@property (nullable) NSString *zoneinfo;
@property (nullable) NSString *name;
@property (nullable) NSString *middle_name;

@end
