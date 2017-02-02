//
//  OperatorIdModel.h
//  MobileConnectDemo
//
//  Created by Andoni Dan on 13/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "LinkModel.h"
#import "MCModel.h"

@interface OperatorIdModel : MCModel
#define kAuthorizationLink @"authorization"
#define kTokenLink @"token"
#define kUserInfoLink @"userinfo"
#define kOpenIdConfiguration @"openid-configuration"
#define kPremiumInfo @"premiuminfo"
#define kTokenRevoke @"tokenrevoke"
#define kTokenRefresh @"tokenrefresh"
#define kJSONValidation @"jwks"

@property (nullable) NSArray<LinkModel>* link;

@property (nullable) LinkModel* authenticationLink;
@property (nullable) LinkModel* tokenlink;
@property (nullable) LinkModel* refreshtokenlink;
@property (nullable) LinkModel* premiumInfoLink;
@property (nullable) LinkModel* userinfolink;
@property (nullable) LinkModel* jsonwebtokenlink;
@property (nullable) LinkModel* metadatalink;
@property (nullable) LinkModel* scopeLink;
@property (nullable) LinkModel* revokeTokenLink;

- (nullable NSString*)authorizationLink;
- (nullable NSString*)tokenLink;
- (nullable NSString*)userInfoLink;
- (nullable NSString*)openIdConfiguration;
- (nullable NSString*)linkForParameter:(nonnull NSString*)parameter;
- (nullable NSString*)premiumInfo;
- (nullable NSString*)tokenRevocation;
- (nullable NSString*)tokenRefresh;
- (nullable NSString*)JSONWebTokenValidation;

- (void)setAuthorizationLink: (NSString* _Nullable) link;
- (void)setTokenLink: (NSString* _Nullable) link;
- (void)setUserInfoLink: (NSString* _Nullable) link;
- (void)setOpenIdLink: (NSString* _Nullable) link;
- (void)setPremiumInfo: (NSString* _Nullable) link;
- (void)setTokenRefresh: (NSString* _Nullable) link;
- (void)setJSONWebTokenValidation: (NSString* _Nullable) link;
- (void)revokeTokenLink: (NSString* _Nullable) link;

- (LinkModel* _Nullable) getAuthLink;
- (LinkModel* _Nullable) getTokenLink;
- (LinkModel* _Nullable) getOpenIdLink;
- (LinkModel* _Nullable) getPremiumInfoLink;
- (LinkModel* _Nullable) getUserInfoLink;
- (LinkModel* _Nullable) getJsonWebTokenValidationLink;
- (LinkModel* _Nullable) getTokenRefreshLink;
- (LinkModel* _Nullable) getRevokeTokenLink;

@end



