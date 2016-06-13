//
//  MCJWTDecoder.m
//  DiscoveryDemoSDK
//
//  Created by Andoni Dan on 24/05/16.
//  Copyright © 2016 dan. All rights reserved.
//

#import "MCJWTDecoder.h"

@implementation MCJWTDecoder
{
    NSString *_JWTString;
}

- (instancetype)initWithJWT:(NSString*)JWTString
{
    if (self = [super init]) {
        _JWTString = JWTString;
    }
    
    return self;
}

- (NSData*)decodedValue
{
    if (_JWTString) {
        
        NSArray <NSString*>* tokenComponents = [_JWTString componentsSeparatedByString:@"."];
        
        NSString *dataComponent = tokenComponents[1];
        
        if (dataComponent) {
            
            return [self decodeDataComponent:dataComponent];
        }
        else
        {
            NSLog(@"failed to find data component in the JWT");
            
            return nil;
        }
    }
    else
    {
        NSLog(@"The JWTDecoder was initialized with null string value");
    }
    
    return nil;
}

- (NSData*)decodeDataComponent:(NSString*)dataComponent
{
    if (dataComponent) {
        
        NSInteger charactersToAdd = dataComponent.length % 4;
        
        NSString *paddedDataComponent = [dataComponent stringByAppendingString:[@"" stringByPaddingToLength:charactersToAdd withString:@"=" startingAtIndex:0]];
        
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:paddedDataComponent options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        return decodedData;
    }
    else
    {
        NSLog(@"the data component of the jwt is nil");
    }
    
    return nil;
}

@end
