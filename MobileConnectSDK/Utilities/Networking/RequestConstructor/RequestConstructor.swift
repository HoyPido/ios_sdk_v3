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
    
    lazy var lazyManager : Manager = {
       
        let configuration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let manager : Manager = Manager(configuration: configuration)
        
        manager.startRequestsImmediately = false
        
        return manager
    }()
    
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
    
    func requestWithMethod(method : Alamofire.Method, url : URLStringConvertible , parameters : [String : AnyObject]?, encoding : ParameterEncoding, additionalHeaders : [String : String]? = nil, shouldNotStartImmediately : Bool = false) -> Request
    {
        var headers : [String : String] = authorizer.headers
        
        if let additionalHeaders = additionalHeaders
        {
            headers = headers + additionalHeaders
        }
        
        if let localManager = manager
        {
            //in case there was a manager provided in the method withManager, nullify it in order to avoid using it next time
            manager = nil
            
            return localManager.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
        }
        
        //the requests loaded in a webview should not be launched at creation 
        if shouldNotStartImmediately
        {
            return lazyManager.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
        }
        
        let requestTest = request(method, url, parameters: parameters, encoding: encoding, headers: headers)
        
        return requestTest
    }
    
    func withManager(manager : Manager) -> Self
    {
        self.manager = manager
        
        return self
    }
}
