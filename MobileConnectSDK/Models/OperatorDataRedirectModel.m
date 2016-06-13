//
//  OperatorDataRedirectModel.m
//  DiscoveryDemoSDK
//
//  Created by Andoni Dan on 18/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "OperatorDataRedirectModel.h"

#define kMCCIndex 0
#define kMNCIndex 1

@implementation OperatorDataRedirectModel

- (NSString*)mcc
{
    return [self valueAtIndex:kMCCIndex];
}

- (NSString*)mnc
{
    return [self valueAtIndex:kMNCIndex];
}

- (NSString*)valueAtIndex:(NSInteger)index
{
    if (self.mcc_mnc) {
        NSArray *mccMncArray = [self.mcc_mnc componentsSeparatedByString:@"_"];
        
        if ([mccMncArray count] > 0) {
            return [mccMncArray objectAtIndex:index];
        }
        else
        {
            return nil;
        }
    }
    
    return nil;
}

@end
