//
//  DiscoveryRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Local constants
private let kRedirectURL : String = "Redirect_URL"
private let kKeyPhone : String = "MSISDN"
private let kKeyCountryCode : String = "Identified-MCC"
private let kKeyNetworkCode : String = "Identified-MNC"

class DiscoveryRequestConstructor : RequestConstructor
{
    //MARK: iVars
    let applicationEndpoint : String
    
    //MARK: init
    init(clientKey: String, clientSecret: String, redirectURL: URLStringConvertible, applicationEndpoint : String){
        
        NSException.checkEndpoint(applicationEndpoint)
        
        self.applicationEndpoint = applicationEndpoint
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: redirectURL)
    }
    
    //MARK: Request factory
    var noOperatorDataRequest : Request
    {
        return genericDiscoveryRequestWithParameters([:])
    }
    
    func requestWithCountryCode(countryCode : String, networkCode : String) -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyCountryCode : countryCode, kKeyNetworkCode : networkCode])
    }
    
    func requestWithPhoneNumber(phoneNumber : String) -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyPhone : phoneNumber])
    }
    
    private func genericDiscoveryRequestWithParameters(parameters : [String : AnyObject]) -> Request
    {
        let isPhoneNumberRequest : Bool = parameters.contains({$0.0 == kKeyPhone})
        
        let method : Alamofire.Method = isPhoneNumberRequest  ? .POST : .GET
        let encoding : ParameterEncoding = isPhoneNumberRequest ? ParameterEncoding.JSON : ParameterEncoding.URLEncodedInURL
        
        return requestWithMethod(method, url: applicationEndpoint, parameters: [kRedirectURL : redirectURL.URLString] + parameters, encoding: encoding)
    }
}