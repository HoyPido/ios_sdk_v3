//
//  AttributeResponseModel.h
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 16/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MCModel.h"

@interface AddressModel : MCModel

@property (nullable) NSString *state;
@property (nullable) NSString *city;
@property (nullable) NSString *country;
@property (nullable) NSString *postal_code;
@property (nullable) NSString *street_address;
@end

@interface AttributeResponseModel : MCModel

@property (nullable) NSString *sub;
@property (nullable) NSString *family_name;
@property (nullable) NSString *given_name;
@property (nullable) NSString *national_identifier;
@property (nullable) NSString *phone_number;
@property (nullable) NSString *phone_number_alternate;
@property (nullable) NSString *updated_at;
@property (nullable) NSString *street_address;
@property (nullable) NSString *city;
@property (nullable) NSString *country;
@property (nullable) NSString *state;
@property (nullable) NSString *postal_code;
@property (nullable) NSString *birthdate;
@property (nullable) NSString *preferred_username;
@property (nullable) NSString *email;
@property (nullable) NSString *client_name;
@property (nullable) NSString *id_token;
@property (nullable) NSString *access_token;
@property (nullable) NSString *middle_name;
@property (nullable) NSString *title;
@property BOOL email_verified;

@end
