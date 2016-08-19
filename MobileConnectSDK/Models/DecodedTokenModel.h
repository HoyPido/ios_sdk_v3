//
//  DecodedTokenModel.h
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 18/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MCModel.h"

@interface DecodedTokenModel : MCModel

@property (nullable) NSString *sub;
@property (nullable) NSString *iss;
@property (nullable) NSArray<NSString*> *aud;
@property double exp;
@property double iat;
@property (nullable) NSString *nonce;
@property (nullable) NSString *at_hash;
@property double auth_time;
@property (nullable) NSString *acr;
@property (nullable) NSArray<NSString*> *amr;
@property (nullable) NSString *displayed_data;
@property (nullable) NSString *azp;

@end
