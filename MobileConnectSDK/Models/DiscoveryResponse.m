//
//  DiscoveryResponse.m
//  MobileConnectDemo
//
//  Created by Andoni Dan on 13/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "DiscoveryResponse.h"

@implementation DiscoveryResponse

- (nullable OperatorIdModel*)linksInformation
{
    return self.response.apis.operatorid;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
