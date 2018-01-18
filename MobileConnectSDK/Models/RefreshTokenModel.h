//
//  RefreshTokenModel.h
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 26/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MCModel.h"

@interface RefreshTokenModel : MCModel

@property (nullable) NSString *access_token;
@property (nullable) NSString *token_type;
@property (nullable) NSString *scope;
@property (nullable) NSString *expires_in;
@property (nullable) NSString *refresh_token;
@property (nullable) NSString *correlation_id;
@end
