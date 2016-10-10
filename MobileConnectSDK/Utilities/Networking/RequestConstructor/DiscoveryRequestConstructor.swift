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
    init(clientKey: String, clientSecret: String, redirectURL: URLStringConvertible, applicationEndpoint : String){
        
        NSException.checkEndpoint(applicationEndpoint)
        
        self.applicationEndpoint = applicationEndpoint
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: redirectURL)
    }
    
    // MARK: Request factory
    var noOperatorDataRequest : Request
    {
        return genericDiscoveryRequestWithParameters([:], shouldNotStartImmediately : true)
    }
    
    func requestWithCountryCode(countryCode : String, networkCode : String) -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyCountryCode : countryCode, kKeyNetworkCode : networkCode], additionalHeaders: ["Accept":"application/json"])
    }
    
    func requestWithPhoneNumber(phoneNumber : String) -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyPhone : phoneNumber.stringByReplacingOccurrencesOfString("+", withString: "")], isPhoneRequest: true, additionalHeaders: ["Content-Type":"application/x-www-form-urlencoded"])
    }
    
    private func genericDiscoveryRequestWithParameters(parameters : [String : AnyObject], isPhoneRequest : Bool = false, additionalHeaders : [String : String]? = nil, shouldNotStartImmediately : Bool = false) -> Request
    {
        let method : Alamofire.Method = isPhoneRequest  ? .POST : .GET
        let encoding : ParameterEncoding = isPhoneRequest ? ParameterEncoding.URL : ParameterEncoding.URLEncodedInURL
        
        return requestWithMethod(method, url: applicationEndpoint, parameters: [kRedirectURL : redirectURL.URLString] + parameters, encoding: encoding, additionalHeaders: additionalHeaders, shouldNotStartImmediately : shouldNotStartImmediately)
    }
}
