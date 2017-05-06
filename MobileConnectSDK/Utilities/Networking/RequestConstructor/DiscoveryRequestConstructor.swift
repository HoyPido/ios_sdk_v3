//
//  DiscoveryRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Local constants
private let kRedirectURL : String = "Redirect_URL"
private let kKeyPhone : String = "MSISDN"
private let kKeyCountryCode : String = "Selected-MCC"
private let kKeyNetworkCode : String = "Selected-MNC"

class DiscoveryRequestConstructor : RequestConstructor
{
    // MARK: iVars
    let applicationEndpoint : String
    
    // MARK: init
    init(clientKey: String, clientSecret: String, redirectURL: URLConvertible, applicationEndpoint : String){
        
        NSException.checkEndpoint(applicationEndpoint)
        
        self.applicationEndpoint = applicationEndpoint
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: redirectURL)
    }
    
    // MARK: Request factory
    var noOperatorDataRequest : Request
    {
        return genericDiscoveryRequestWithParameters([:], shouldNotStartImmediately : true)
    }
    
    func requestNoOperatorDataRequest(_ clientIP: String? = "") -> Request {
        return genericDiscoveryRequestWithParameters([:], additionalHeaders: ["X-Source-IP":clientIP ?? "", "X-Redirect":MobileConnectSDK.getXRedirect()], shouldNotStartImmediately : true)
    }
    
    func requestWithCountryCode(_ countryCode : String, networkCode : String) -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyCountryCode : countryCode as AnyObject, kKeyNetworkCode : networkCode as AnyObject], additionalHeaders: ["Accept":"application/json", "X-Redirect":MobileConnectSDK.getXRedirect()])
    }
    
    func requestWithPhoneNumber(_ phoneNumber : String, clientIP : String? = "") -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyPhone : phoneNumber.replacingOccurrences(of: "+", with: "") as AnyObject], isPhoneRequest: true, additionalHeaders: ["Content-Type":"application/x-www-form-urlencoded", "X-Source-IP": clientIP ?? "", "X-Redirect":MobileConnectSDK.getXRedirect()])
    }
    
    fileprivate func genericDiscoveryRequestWithParameters(_ parameters : [String : AnyObject], isPhoneRequest : Bool = false, additionalHeaders : [String : String]? = nil, shouldNotStartImmediately : Bool = false) -> Request
    {
        
        var parametersNewDictionary = parameters
        parametersNewDictionary[kRedirectURL] = redirectURL as AnyObject?
        let method : HTTPMethod = isPhoneRequest ?  .post : .get
        let encoding : ParameterEncoding = isPhoneRequest ? URLEncoding.default : URLEncoding.methodDependent
        return requestWithMethod(method, url: applicationEndpoint, parameters: parametersNewDictionary, encoding: encoding, additionalHeaders: additionalHeaders, shouldNotStartImmediately : shouldNotStartImmediately)
    }
}
