//
//  RefreshTokenRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 23/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire


private let kGrantTypeKey : String = "grant_type"
private let kGrantTypeValue : String = "refresh_token"
private let kRefreshTokenKey : String = "refresh_token"
private let kScopesKey : String = "scopes"

class RefreshTokenRequestConstructor : NSObject {
    
    let scopeValidator : ScopeValidator?
    let scopes : [String]?
    
    init(scopeValidator : ScopeValidator? = nil, withScopes scopes : [String]? = nil) {
        self.scopeValidator = scopeValidator
        self.scopes = scopes
    }
    
    func generateRefreshRequest(withURL: String, withRefreshToken token : String) -> Request {
        
        var parameters : Dictionary = [kGrantTypeKey : kGrantTypeValue, kRefreshTokenKey : token]
        
        if let scopes = scopes {
            parameters[kScopesKey] = scopeValidator?.validatedScopes(scopes)
        }
        
        let credentialsString : String = "\(MobileConnectSDK.getClientKey()):\(MobileConnectSDK.getClientSecret())"
        
        var headers : Dictionary = ["Content-Type":"application/x-www-form-urlencoded"]
        
        if let encodedData : NSData = credentialsString.dataUsingEncoding(NSUTF8StringEncoding)
        {
            let encodedCredentials : String = encodedData.base64EncodedStringWithOptions([])
            headers["Authorization"] = "Basic \(encodedCredentials)"
        } 
        
        return request(.POST, withURL, parameters: parameters, encoding: .URLEncodedInURL, headers: headers)
    }

}