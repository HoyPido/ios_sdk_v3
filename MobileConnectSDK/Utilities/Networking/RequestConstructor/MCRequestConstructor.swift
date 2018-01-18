//
//  MCRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 10/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

// MARK: Local constants
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
private let kLoginHintENCRMSISDNFormat : String = "ENCR_MSISDN:%@"
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
private let kCorrelationId : String = "correlation_id"

class MCRequestConstructor: RequestConstructor {
    
    let scopeValidator : ScopeValidator
    let configuration : MobileConnectServiceConfiguration
    var uuid: String? = nil
    let notificationName = Notification.Name("uuidNotification")
    //Pass a MCAuthorizationConfiguration if an authorization behavior is required
    init(configuration : MobileConnectServiceConfiguration, scopeValidator : ScopeValidator) {
        
        self.configuration = configuration
        self.scopeValidator = scopeValidator
        
        super.init(clientKey: configuration.clientKey, clientSecret: configuration.clientSecret, redirectURL: configuration.redirectURL)
        
        
    }
    
    func mobileConnectRequestWithAssuranceLevel(_ assuranceLevel : MCLevelOfAssurance, subscriberId : String?, scopes : [String], config : AuthorizationConfigurationParameters? = nil, url : String, clientName : String? = nil, context : String? = nil, bindingMessage : String? = nil, shouldNotStartImmediately : Bool = false, correlationId: Bool) -> Request
    {
        if (correlationId == true) {
            uuid = ""
        }
        
        let state : String = UUID.randomUUID
        
        var parameters : [String : Any] = [kClientId : clientKey, kResponseType : kResponseTypeValue, kRedirectURI : redirectURL , kScope : scopeValidator.validatedScopes(scopes), kAssuranceKey : "\(assuranceLevel.rawValue)", kState : state, kNonce : configuration.nonce, correlation : uuid]
        
        if scopes.contains(MobileConnectAuthorization) {
            let productVersion = scopeValidator.versionPairsForStringValues([MobileConnectAuthorization])
            if let version = productVersion.first?.versionString() {
                parameters[kVersionKey] = "\(version)"
            }
        } else if scopes.contains(MobileConnectAuthentication) {
            let productVersion = scopeValidator.versionPairsForStringValues([MobileConnectAuthentication, MobileConnect])
            if let version = productVersion.first?.versionString() {
                parameters[kVersionKey] = "\(version)"
            }
        }
        
        if let clientName = clientName {
            parameters[kClientNameKey] = clientName
        }
        
        if let config = config {
            
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
            
            if let correlationId = config.correlation_id {
                parameters[correlationId] = correlationId
            }
            
        }
        
        
        if let correlationId = configuration.correlationId {
            parameters[kCorrelationId] = correlationId
        }
        
        
        if let loginHint = configuration.loginHint {
            parameters[kLoginHint] = loginHint
        } else {
            if let subscriberId = subscriberId {
                parameters[kLoginHint] = String(format: kLoginHintENCRMSISDNFormat, subscriberId)
            }
        }
        
        if let context = context
        {
            parameters[kContextKey] = context
        }
        
        if let bindingMessage = bindingMessage {
            parameters[kBindingMessageKey] = bindingMessage
        }

        return requestWithMethod(.get, url: url, parameters: parameters as [String : AnyObject]?, encoding: URLEncoding.methodDependent, shouldNotStartImmediately : shouldNotStartImmediately)
    }
    
    func checkLoginHint(_ loginHint : String) -> Bool {
        
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
    
    func authenticationRequest(correlationId: Bool) -> Request
    {
        return mobileConnectRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: configuration.subscriberId, scopes: configuration.scopes, url: configuration.authorizationURLString, shouldNotStartImmediately : true, correlationId: correlationId)
    }
    
    ///Will return nil if the configuration used to initialize the Request Constructor is not of type MCAuthorizationConfiguration
    func authorizationRequest(correlationId: Bool) -> Request?
    {
        if let configuration = configuration as? MCAuthorizationConfiguration
        {
            
            if (configuration.config?.login_hint_token?.isEmpty == false) {
                configuration.loginHint = ""
            }
            
            return mobileConnectRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: configuration.subscriberId, scopes: configuration.scopes, config: configuration.config, url: configuration.authorizationURLString, clientName: configuration.clientName, context: configuration.context, bindingMessage: configuration.bindingMessage, shouldNotStartImmediately : true, correlationId: correlationId)
        }
        
        return nil
    }
    
    func tokenRequestAtURL(_ url : String, withCode code : String) -> Request
    {
        return requestWithMethod(.post, url: url, parameters: [kCodeKey : code as AnyObject, kGrantTypeKey : kGrantTypeValue as AnyObject, kRedirectURI : redirectURL as AnyObject, correlation : uuid as AnyObject], encoding: URLEncoding.default, additionalHeaders:  ["Content-Type":"application/x-www-form-urlencoded"])
    }
}
