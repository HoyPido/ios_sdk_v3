//
//  DiscoveryOptions.m
//  MobileConnectSDK
//
//  Created by Dmitry Maretsky on 1/23/17.
//  Copyright © 2017 GSMA. All rights reserved.
//

#import "DiscoveryOptions.h"

@implementation DiscoveryOptions

- (void) setSubscriberId:(NSString *)subscriberId{
    _subscriber_id = subscriberId;
}

- (void) setClientConsumerKey:(NSString *) clientConsumerKey {
    _client_id = clientConsumerKey;
}

- (void) setClientSecretKey:(NSString *) clientSecretKey {
    _client_secret = clientSecretKey;
}

- (void) setMSISDN:(NSString *) msisdn {
    _msisdn = msisdn;
}

- (void) setMCC:(NSString *) mcc {
    _mcc = mcc;
}

- (void) setMNC:(NSString *) mnc {
    _mnc = mnc;
}

- (void) setRedirectUrl:(NSString *) redirectUrl {
    _redirectUrl = redirectUrl;
}

- (void) setOperatorUrls:(OperatorIdModel *)links {
    _operatorUrls = links;
}

- (NSString*) getSubscriberId {
    return _subscriber_id;
}

- (NSString*) getClientConsumerKey {
    return _client_id;
}

- (NSString*) getClientSecretKey {
    return _client_secret;
}

- (NSString*) getMSISDN {
    return _msisdn;
}

- (NSString*) getMCC {
    return _mcc;
}

- (NSString*) getMNC {
    return _mnc;
}

- (NSString*) getRedirectUrl {
    return _redirectUrl;
}

- (OperatorIdModel*) getOperatorUrls {
    return _operatorUrls;
}
@end
