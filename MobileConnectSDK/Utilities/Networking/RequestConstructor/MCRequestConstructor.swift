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

private let kContextKey : String = "context"
private let kClientNameKey : String = "client_name"

class MCRequestConstructor: RequestConstructor {
    
    let scopeValidator : ScopeValidator
    let configuration : MobileConnectServiceConfiguration
    
    //Pass a MCAuthorizationConfiguration if an authorization behavior is required
    init(configuration : MobileConnectServiceConfiguration, scopeValidator : ScopeValidator) {
        
        self.configuration = configuration
        self.scopeValidator = scopeValidator
        
        super.init(clientKey: configuration.clientKey, clientSecret: configuration.clientSecret, redirectURL: configuration.redirectURL)
    }
    
    func mobileConnectRequestWithAssuranceLevel(assuranceLevel : MCLevelOfAssurance, subscriberId : String?, scopes : [String], url : String, clientName : String? = nil, context : String? = nil, shouldNotStartImmediately : Bool = false) -> Request
    {
        let nonce : String = NSUUID.randomUUID
        let state : String = NSUUID.randomUUID
        
        var parameters : [String : String] = [kClientId : clientKey, kResponseType : kResponseTypeValue, kRedirectURI : redirectURL.URLString, kScope : scopeValidator.validatedScopes(scopes), kAssuranceKey : "\(assuranceLevel.rawValue)", kState : state, kNonce : nonce]
        
        if let subscriberId = subscriberId {
            parameters[kLoginHint] = String(format: kLoginHintFormat, subscriberId)
        }
        
        if let clientName = clientName
        {
            parameters[kClientNameKey] = clientName
        }
        
        if let context = context
        {
            parameters[kContextKey] = context
        }
        
        return requestWithMethod(.GET, url: url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, shouldNotStartImmediately : shouldNotStartImmediately)
    }
    
    var authenticationRequest : Request
    {
        return mobileConnectRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: configuration.subscriberId, scopes: configuration.scopes, url: configuration.authorizationURLString, shouldNotStartImmediately : true)
    }
    
    ///Will return nil if the configuration used to initialize the Request Constructor is not of type MCAuthorizationConfiguration
    var authorizationRequest : Request?
    {
        if let configuration = configuration as? MCAuthorizationConfiguration
        {
            return mobileConnectRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: configuration.subscriberId, scopes: configuration.scopes, url: configuration.authorizationURLString, clientName: configuration.clientName, context: configuration.context, shouldNotStartImmediately : true)
        }
        
        return nil
    }
    
    func tokenRequestAtURL(url : String, withCode code : String) -> Request
    {
        return requestWithMethod(.POST, url: url, parameters: [kCodeKey : code, kGrantTypeKey : kGrantTypeValue, kRedirectURI : redirectURL.URLString], encoding: ParameterEncoding.URL)
    }
}
