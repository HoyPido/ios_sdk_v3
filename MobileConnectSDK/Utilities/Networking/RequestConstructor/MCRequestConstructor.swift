//
//  MCRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 10/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

//MARK: Local constants
private let kClientId : String = "client_id"
private let kResponseType : String =  "response_type"
private let kResponseTypeValue : String = "code"
private let kRedirectURI : String = "redirect_uri"
private let kScope : String = "scope"

private let kAssuranceKey : String = "acr_values"
private let kState : String = "state"
private let kNonce : String = "nonce"
private let kLoginHint : String = "login_hint"
private let kLoginHintFormat : String = "ENCR_MSISDN:%@"

private let kCodeKey : String = "code"
private let kGrantTypeKey : String = "grant_type"
private let kGrantTypeValue : String = "authorization_code"
private let kRedirectUri : String = "redirect_uri"

class MCRequestConstructor: RequestConstructor {
    
    let scopeValidator : ScopeValidator
    let configuration : MobileConnectServiceConfiguration
    
    //Pass a MCAuthorizationConfiguration if an authorization behavior is required
    init(configuration : MobileConnectServiceConfiguration, scopeValidator : ScopeValidator) {
        
        self.configuration = configuration
        self.scopeValidator = scopeValidator
        
        super.init(clientKey: configuration.clientKey, clientSecret: configuration.clientSecret, redirectURL: configuration.redirectURL)
    }
    
    func mobileConnectRequestWithAssuranceLevel(assuranceLevel : MCLevelOfAssurance, subscriberId : String?, scopes : [String], url : String, clientName : String? = nil, context : String? = nil) -> Request
    {
        let nonce : String = NSUUID.randomUUID
        let state : String = NSUUID.randomUUID
        
        print("the current scopes are \(scopeValidator.validatedScopes(scopes))")
        
        var parameters : [String : String] = [kClientId : clientKey, kResponseType : kResponseTypeValue, kRedirectURI : redirectURL.URLString, kScope : scopeValidator.validatedScopes(scopes), kAssuranceKey : "\(assuranceLevel.rawValue)", kState : state, kNonce : nonce]
        
        if let subscriberId = subscriberId {
            parameters[kLoginHint] = String(format: kLoginHintFormat, subscriberId)
        }
        
        return requestWithMethod(.GET, url: url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL)
    }
    
    var authenticationRequest : Request
    {
        return mobileConnectRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: configuration.subscriberId, scopes: [MobileConnectAuthentication], url: configuration.authorizationURLString)
    }
    
    ///Will return nil if the configuration used to initialize the Request Constructor is not of type MCAuthorizationConfiguration
    var authorizationRequest : Request?
    {
        if let configuration = configuration as? MCAuthorizationConfiguration
        {
            return mobileConnectRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: configuration.subscriberId, scopes: configuration.scopes, url: configuration.authorizationURLString, clientName: configuration.clientName, context: configuration.context)
        }
        
        return nil
    }
//    func authorizationRequest(assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.Level2, subscriberId : String? = nil, clientName : String , context : String , atURL url : String, withScopes scopes : [String] = [MobileConnectAuthorization]) -> Request
//    {
//        return mobileConnectRequestWithAssuranceLevel(assuranceLevel, subscriberId: subscriberId, scopes: scopes, atURL: url)
//    }
    
    func tokenRequestAtURL(url : String, withCode code : String) -> Request
    {
        return requestWithMethod(.POST, url: url, parameters: [kCodeKey : code, kGrantTypeKey : kGrantTypeValue, kRedirectURI : redirectURL.URLString], encoding: ParameterEncoding.URL)
    }
}
