//
//  MetadataModel.h
//  MobileConnectSDK
//
//  Created by jenkins on 29/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "MCModel.h"

@interface MetadataModel : MCModel

@property (nullable) NSArray<NSString*> *acr_values_supported;
@property (nullable) NSString *authorization_endpoint;
@property (nullable) NSString *check_session_iframe;
@property (nullable) NSArray<NSString*> *claim_types_supported;
@property (nullable) NSArray<NSString*> *claims_locales_supported;
@property (nullable) NSString *claims_parameter_supported;
@property (nullable) NSArray<NSString*> *claims_supported;
@property (nullable) NSArray<NSString*> *display_values_supported;
@property (nullable) NSString *end_session_endpoint;
@property (nullable) NSArray<NSString*> *grant_types_supported;
@property (nullable) NSArray<NSString*> *id_token_supported_alg_values_supported;
@property (nullable) NSArray<NSString*> *id_token_encryption_enc_values_supported;
@property (nullable) NSArray<NSString*> *id_token_signing_alg_values_supported;
@property (nullable) NSString *issuer;
@property (nullable) NSString *jwks_uri;
@property (nullable) NSArray<NSString*> *login_hint_methods_supported;
@property (nullable) NSArray<NSDictionary*> *mobile_connect_version_supported;
@property (nullable) NSString *op_policy_uri;
@property (nullable) NSString *op_tos_uri;
@property (nullable) NSArray<NSString*> *request_object_encryption_alg_values_supported;
@property (nullable) NSArray<NSString*> *request_object_encryption_enc_values_supported;
@property (nullable) NSArray<NSString*> *request_object_signing_alg_values_supported;
@property (nullable) NSNumber *request_parameter_supported;
@property (nullable) NSNumber *request_uri_parameter_supported;
@property (nullable) NSNumber *require_request_uri_registration;
@property (nullable) NSArray<NSString*> *response_types_supported;
@property (nullable) NSArray<NSString*> *scopes_supported;
@property (nullable) NSString *service_documentation;
@property (nullable) NSArray<NSString*> *subject_types_supported;
@property (nullable) NSString *token_endpoint;
@property (nullable) NSArray<NSString*> *token_endpoint_auth_methods_supported;
@property (nullable) NSArray<NSString*> *token_endpoint_auth_signing_alg_values_supported;
@property (nullable) NSArray<NSString*> *ui_locales_supported;
@property (nullable) NSArray<NSString*> *userinfo_encryption_alg_values_supported;
@property (nullable) NSArray<NSString*> *userinfo_encryption_enc_values_supported;
@property (nullable) NSString *userinfo_endpoint;
@property (nullable) NSArray<NSString*> *userinfo_signing_alg_values_supported;
@property (nullable) NSString *version;
@property (nullable) NSString *premiuminfo_endpoint;
@property (nullable) NSString *revoke_endpoint;

@end
