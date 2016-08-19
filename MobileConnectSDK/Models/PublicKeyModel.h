//
//  PublicKeyModel.h
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 19/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MCModel.h"

@protocol PublicKeyModel

@end

@interface PublicKeyModel : MCModel

@property (nullable) NSString *kty;
@property (nullable) NSString *use;
@property (nullable) NSString *n;
@property (nullable) NSString *e;
@property (nullable) NSString *kid;

@end

@interface PublicKeyModelArray : MCModel

@property (nullable) NSArray<PublicKeyModel> *keys;

@end