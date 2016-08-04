//
//  TokenResponseModel.h
//  DiscoveryDemoSDK
//
//  Created by Andoni Dan on 24/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "MCModel.h"
#import "TokenModel.h"
#import "DiscoveryResponse.h"

/**
    Contains the tokenModel received from the server as well as the decoded JWT token.
    Can be initialized with a Token Model in order to receive the decoded JWT in decodedToken property
 */
@interface TokenResponseModel : MCModel

- (nullable instancetype)initWithTokenModel:(nullable TokenModel*)tokenModel discoveryResponse:(nullable DiscoveryResponse*)discoveryResponse;

@property (nullable) TokenModel *tokenData;
@property (nullable) NSDictionary *decodedToken;
@property (nullable) DiscoveryResponse *discoveryResponse;

@end
