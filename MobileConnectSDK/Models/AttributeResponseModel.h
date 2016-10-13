//
//  AttributeResponseModel.h
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 16/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MCModel.h"

@interface AddressModel : MCModel

@property (nullable) NSString *formatted;

@end

@interface AttributeResponseModel : MCModel

@property (nullable) NSString *sub;
@property (nullable) NSString *family_name;
@property (nullable) NSString *given_name;
@property (nullable) NSString *national_identifier;
@property (nullable) NSString *phone_number;
@property (nullable) NSString *phone_number_alternate;
@property BOOL phone_number_verified;
@property (nullable) NSString *updated_at;
@property (nullable) AddressModel *address;
@property (nullable) NSString *state;
@property (nullable) NSString *postal_code;
@property (nullable) NSString *city;
@property (nullable) NSString *street_address;
@property (nullable) NSString *country;
@property (nullable) NSString *birthdate;
@property (nullable) NSString *preferred_username;
@property (nullable) NSString *email;
@property BOOL email_verified;

@end
