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
#define kScopeLink @"scope"

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

- (nullable NSString*)scopeLink
{
    return [self linkForParameter:kScopeLink];
}

- (nullable NSString*)linkForParameter:(NSString*)parameter
{
    return ((LinkModel*)[[self.link filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        LinkModel *link = (LinkModel*)evaluatedObject;
        
        return [link.rel isEqualToString:parameter];
    }]] firstObject]).href;
}

@end
