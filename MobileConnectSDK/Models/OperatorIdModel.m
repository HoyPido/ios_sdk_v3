//
//  OperatorIdModel.m
//  MobileConnectDemo
//
//  Created by Andoni Dan on 13/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "OperatorIdModel.h"
#import "LinkModel.h"

#define kAuthorizationLink @"authorization"
#define kTokenLink @"token"
#define kUserInfoLink @"userinfo"
#define kOpenIdConfiguration @"openid-configuration"
#define kPremiumInfo @"premiuminfo"
#define kTokenRevoke @"tokenrevoke"
#define kTokenRefresh @"tokenrefresh"
#define kJSONValidation @"jwks"
#define kScopeSupported @"scope"

@implementation OperatorIdModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (nullable NSString*)authorizationLink
{
    return [self linkForParameter:kAuthorizationLink];
}

- (nullable NSString*)tokenLink
{
    return [self linkForParameter:kTokenLink];
}

- (nullable NSString*)userInfoLink
{
    return [self linkForParameter:kUserInfoLink];
}

- (nullable NSString*)openIdConfiguration
{
    return [self linkForParameter:kOpenIdConfiguration];
}

- (nullable NSString*)premiumInfo
{
    return [self linkForParameter:kPremiumInfo];
}

- (nullable NSString*)tokenRevocation
{
    return [self linkForParameter:kTokenRevoke];
}

- (nullable NSString*)tokenRefresh {
    return [self linkForParameter:kTokenRefresh];
}

- (nullable NSString*)JSONWebTokenValidation
{
    return [self linkForParameter:kJSONValidation];
}

- (nullable NSString*)linkForParameter: (NSString*)parameter
{
    return ((LinkModel*)[[self.link filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        LinkModel *link = (LinkModel*)evaluatedObject;
        
        return [link.rel isEqualToString:parameter];
    }]] firstObject]).href;
}

- (void) setAuthorizationLink: (NSString*) linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kAuthorizationLink;
    _authenticationLink = link;
}

- (void) setTokenLink:(NSString *)linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kTokenLink;
    _tokenlink = link;
}

- (void) setOpenIdLink:(NSString *)linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kOpenIdConfiguration;
    _metadatalink = link;
}

- (void) setPremiumInfo:(NSString *)linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kPremiumInfo;
    _premiumInfoLink = link;
}

- (void) setUserInfoLink:(NSString *)linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kUserInfoLink;
    _userinfolink = link;
}

- (void) setJSONWebTokenValidation:(NSString *)linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kJSONValidation;
    _jsonwebtokenlink = link;
}

- (void) setTokenRefresh:(NSString *)linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kTokenRefresh;
    _refreshtokenlink = link;
    
}

- (void) revokeTokenLink:(NSString *)linkRequest {
    LinkModel *link = [[LinkModel alloc] init];
    link.href = linkRequest;
    link.rel = kTokenRevoke;
    _revokeTokenLink = link;
    
}

- (LinkModel*) getAuthLink {
    return _authenticationLink;
}

- (LinkModel*) getOpenIdLink {
    return _metadatalink;
}

- (LinkModel*) getPremiumInfoLink {
    return _premiumInfoLink;
}

- (LinkModel*) getUserInfoLink {
    return _userinfolink;
}

- (LinkModel*) getJsonWebTokenValidationLink {
    return _jsonwebtokenlink;
}

- (LinkModel*) getTokenRefreshLink {
    return _refreshtokenlink;
}

- (LinkModel*) getTokenLink {
    return _tokenlink;
}

- (LinkModel*) getRevokeTokenLink {
    return _revokeTokenLink;
}

@end
