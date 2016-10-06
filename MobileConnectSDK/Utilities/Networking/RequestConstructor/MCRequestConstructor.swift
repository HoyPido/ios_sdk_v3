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
private let kLoginHintENCRMSISDN : String = "ENCR_MSISDN"
private let kLoginHintPCR : String = "PCR"
private let kLoginHintMSISDN : String = "MSISDN"

private let kCodeKey : String = "code"
private let kGrantTypeKey : String = "grant_type"
private let kGrantTypeValue : String = "authorization_code"

private let kContextKey : String = "context"
private let kBindingMessageKey : String = "binding_message"
private let kClientNameKey : String = "client_name"

private let kVersionKey : String = "version"
private let kUILocaleKey : String = "ui_locales"
private let kPromptKey : String = "prompt"
private let kIdTokenHintKey : String = "id_token_hint"
private let kLoginHintTokenKey : String = "login_hint_token"
private let kResponseModeKey : String = "response_mode"
private let kClaimsKey : String = "claims"
private let kMaxAgeKey : String = "max_age"

class MCRequestConstructor: RequestConstructor {
    
    let scopeValidator : ScopeValidator
    let configuration : MobileConnectServiceConfiguration
    
    //Pass a MCAuthorizationConfiguration if an authorization behavior is required
    init(configuration : MobileConnectServiceConfiguration, scopeValidator : ScopeValidator) {
        
        self.configuration = configuration
        self.scopeValidator = scopeValidator
        
        super.init(clientKey: configuration.clientKey, clientSecret: configuration.clientSecret, redirectURL: configuration.redirectURL)
    }
    
    func mobileConnectRequestWithAssuranceLevel(assuranceLevel : MCLevelOfAssurance, subscriberId : String?, scopes : [String], config : AuthorizationConfigurationParameters? = nil, url : String, clientName : String? = nil, context : String? = nil, bindingMessage : String? = nil, shouldNotStartImmediately : Bool = false) -> Request
    {
        let state : String = NSUUID.randomUUID
        
        var parameters : [String : String] = [kClientId : clientKey, kResponseType : kResponseTypeValue, kRedirectURI : redirectURL.URLString, kScope : scopeValidator.validatedScopes(scopes), kAssuranceKey : "\(assuranceLevel.rawValue)", kState : state, kNonce : configuration.nonce]
        
        if let clientName = clientName
        {
            parameters[kClientNameKey] = clientName
        }
        
        if let config = config {
            if let version = config.version {
                parameters[kVersionKey] = version
            }
            
            if let prompt = config.prompt {
                parameters[kPromptKey] = prompt
            }
            
            if let uiLocale = config.ui_locales {
                parameters[kUILocaleKey] = uiLocale
            }
            
            if let idTokenHint = config.id_token_hint {
                parameters[kIdTokenHintKey] = idTokenHint
            }
            
            if let loginHintToken = config.login_hint_token {
                if checkLoginHint(loginHintToken) {
                    parameters[kLoginHintTokenKey] = loginHintToken
                }
            }
            
            if let response = config.response_mode {
                parameters[kResponseModeKey] = response
            }
            
            if let claims = config.claims {
                parameters[kClaimsKey] = claims
            }
            
            if let maxAge = config.max_age {
                parameters[kMaxAgeKey] = maxAge
            }
            
        }
        
        if !getLoginHintParameter().isEmpty {
            parameters[kLoginHint] = getLoginHintParameter()
        }
        
        if let context = context
        {
            parameters[kContextKey] = context
        }
        
        if let bindingMessage = bindingMessage {
            parameters[kBindingMessageKey] = bindingMessage
        }
        
        return requestWithMethod(.GET, url: url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, shouldNotStartImmediately : shouldNotStartImmediately)
    }
    
    func getLoginHintParameter() -> String {
        
        if let loginHint = configuration.loginHint {
            if loginHint.containsString(kLoginHintMSISDN) {
                if checkLoginHint(kLoginHintMSISDN) {
                    return loginHint
                }
            } else if loginHint.containsString(kLoginHintENCRMSISDN) {
                if checkLoginHint(kLoginHintENCRMSISDN) {
                    return loginHint
                }
            } else if loginHint.containsString(kLoginHintPCR) {
                if checkLoginHint(kLoginHintPCR) {
                    return loginHint
                }
            }
        }
        
        return ""
    }
    
    func checkLoginHint(loginHint : String) -> Bool {
        
        if loginHint == kLoginHintMSISDN {
            if configuration.isLoginHintMSISDNSupported() {
                return true
            }
        }
        
        if loginHint == kLoginHintENCRMSISDN {
            if configuration.isLoginHintEncryptedMSISDNSupported() {
                return true
            }
        }
        
        if loginHint == kLoginHintPCR {
            if configuration.isLoginHintPCRSupported() {
                return true
            }
            
        }
        
        return false
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
            return mobileConnectRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: configuration.subscriberId, scopes: configuration.scopes, config: configuration.config, url: configuration.authorizationURLString, clientName: configuration.clientName, context: configuration.context, bindingMessage: configuration.bindingMessage, shouldNotStartImmediately : true)
        }
        
        return nil
    }
    
    func tokenRequestAtURL(url : String, withCode code : String) -> Request
    {
        return requestWithMethod(.POST, url: url, parameters: [kCodeKey : code, kGrantTypeKey : kGrantTypeValue, kRedirectURI : redirectURL.URLString], encoding: ParameterEncoding.URL, additionalHeaders:  ["Content-Type":"application/x-www-form-urlencoded"])
    }
}
