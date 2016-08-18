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
@property (nullable) AddressModel *address;
@property (nullable) NSDate *birthdate;

@end


