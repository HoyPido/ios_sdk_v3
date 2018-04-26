//
//  DiscoveryOptions.h
//  MobileConnectSDK
//
//  Created by Dmitry Maretsky on 1/23/17.
//  Copyright © 2017 GSMA. All rights reserved.
//
#import "MCModel.h"
#import "OperatorIdModel.h"
@interface DiscoveryOptions : MCModel

@property (nonatomic, nullable) NSString* subscriber_id;
@property (nonatomic, nullable) NSString* client_id;
@property (nonatomic, nullable) NSString* client_secret;
@property (nonatomic, nullable) NSString* msisdn;
@property (nonatomic, nullable) NSString* mcc;
@property (nonatomic, nullable) NSString* mnc;
@property (nonatomic, nullable) NSString* redirectUrl;
@property (nonatomic, nullable) OperatorIdModel* operatorUrls;

- (void) setSubscriberId: (NSString* _Nullable) subscriberId;
- (void) setClientConsumerKey: (NSString* _Nullable) clientConsumerKey;
- (void) setClientSecretKey: (NSString* _Nullable) clientSecretKey;
- (void) setMSISDN: (NSString* _Nullable) msisdn;
- (void) setMCC: (NSString* _Nullable) mcc;
- (void) setMNC: (NSString* _Nullable) mnc;
- (void) setRedirectUrl: (NSString* _Nullable) redirectUrl;
- (void) setOperatorUrls: (OperatorIdModel* _Nullable) links;

- (NSString* _Nullable) getSubscriberId;
- (NSString* _Nullable) getClientConsumerKey;
- (NSString* _Nullable) getClientSecretKey;
- (NSString* _Nullable) getMSISDN;
- (NSString* _Nullable) getMCC;
- (NSString* _Nullable) getMNC;
- (NSString* _Nullable) getRedirectUrl;
- (OperatorIdModel* _Nullable) getOperatorUrls;

@end

