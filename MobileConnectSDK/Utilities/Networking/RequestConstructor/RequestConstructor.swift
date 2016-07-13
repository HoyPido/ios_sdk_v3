//
//  RequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

class RequestConstructor: NSObject {
    
    let clientKey : String
    let clientSecret : String
    let redirectURL : URLStringConvertible
    
    var manager : Manager?
    
    lazy var authorizer : Authorizer =
    {
        return Authorizer(clientKey: self.clientKey, clientSecret: self.clientSecret)
    }()
    
    init(clientKey : String, clientSecret : String, redirectURL : URLStringConvertible) {
        
        self.clientKey = clientKey
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
        
        super.init()
    }
    
    func requestWithMethod(method : Alamofire.Method, url : URLStringConvertible , parameters : [String : AnyObject]?, encoding : ParameterEncoding) -> Request
    {
        if let localManager = manager
        {
            manager = nil
            
            return localManager.request(method, url, parameters: parameters, encoding: encoding, headers: authorizer.headers)
        }
        
        return request(method, url, parameters: parameters, encoding: encoding, headers: authorizer.headers)
    }
    
    func withManager(manager : Manager) -> Self
    {
        self.manager = manager
        
        return self
    }
}
