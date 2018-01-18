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
@property (nullable) NSString *updated_at;
@property (nullable) AddressModel *address;
@property (nullable) NSString *preferred_username;
@property (nullable) NSString *email;
@property BOOL email_verified;
@property (nullable) NSString *nickname;
@property (nullable) NSString *middle_name;
@property (nullable) NSString *name;
@property (nullable) NSString *correlation_id;

@end
