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
    
    init(clientKey: String, clientSecret: String, redirectURL: URLStringConvertible, scopeValidator : ScopeValidator) {
        
        self.scopeValidator = scopeValidator
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: redirectURL)
    }
    
    func mobileConnectRequestWithAssuranceLevel(assuranceLevel : MCLevelOfAssurance, subscriberId : String?, scopes : [String], atURL url : String) -> Request
    {
        let nonce : String = NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
        let state : String = NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
        
        print(scopeValidator.validatedScopes(scopes))
        
        var parameters : [String : String] = [kClientId : clientKey, kResponseType : kResponseTypeValue, kRedirectURI : redirectURL.URLString, kScope : scopeValidator.validatedScopes(scopes), kAssuranceKey : "\(assuranceLevel.rawValue)", kState : state, kNonce : nonce]
        
        if let subscriberId = subscriberId {
            parameters[kLoginHint] = String(format: kLoginHintFormat, subscriberId)
        }
        
        return requestWithMethod(.GET, url: url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL)
    }
    
    func authorizationRequestWithAssuranceLevel(assuranceLevel : MCLevelOfAssurance, subscriberId : String?, atURL url : String, withScopes scopes : [String]) -> Request
    {
        return mobileConnectRequestWithAssuranceLevel(assuranceLevel, subscriberId: subscriberId, scopes: scopes, atURL: url)
    }
    
    func tokenRequestAtURL(url : String, withCode code : String) -> Request
    {
        return requestWithMethod(.POST, url: url, parameters: [kCodeKey : code, kGrantTypeKey : kGrantTypeValue, kRedirectURI : redirectURL.URLString], encoding: ParameterEncoding.URL)
    }
}
