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
private let kScopeValue : String = "openid"
private let kAcreditationValue : String = "acr_values"
private let kState : String = "state"
private let kNonce : String = "nonce"
private let kLoginHint : String = "login_hint"
private let kLoginHintFormat : String = "ENCR_MSISDN:%@"

private let kCodeKey : String = "code"
private let kGrantTypeKey : String = "grant_type"
private let kGrantTypeValue : String = "authorization_code"
private let kRedirectUri : String = "redirect_uri"

class MCRequestConstructor: RequestConstructor {
    
    func authorizationRequestWithClientId(clientId : String, acreditationValue : MCLevelOfAssurance, subscriberId : String?, atURL url : String) -> Request
    {
        let nonce : String = NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
        let state : String = NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
        
        var parameters : [String : String] = [kClientId : clientId, kResponseType : kResponseTypeValue, kRedirectURI : redirectURL.URLString, kScope : kScopeValue, kAcreditationValue : "\(acreditationValue.rawValue)", kState : state, kNonce : nonce]
        
        if let subscriberId = subscriberId {
            parameters[kLoginHint] = String(format: kLoginHintFormat, subscriberId)
        }
        
        return requestWithMethod(.GET, url: url, parameters: parameters, encoding: ParameterEncoding.URL)
    }
    
    func tokenRequestAtURL(url : String, withCode code : String) -> Request
    {
        return requestWithMethod(.POST, url: url, parameters: [kCodeKey : code, kGrantTypeKey : kGrantTypeValue, kRedirectURI : redirectURL.URLString], encoding: ParameterEncoding.URL)
    }
}
