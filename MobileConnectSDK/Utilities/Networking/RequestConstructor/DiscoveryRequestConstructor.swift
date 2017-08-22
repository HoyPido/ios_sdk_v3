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
private let uuidTest = NSUUID().uuidString
public let correlation: String = "correlation_id"

class DiscoveryRequestConstructor : RequestConstructor
{
    
    // MARK: iVars
    var applicationEndpoint : String = ""
    let uuidValue: String = uuidTest
    // MARK: init
    init(clientKey: String, clientSecret: String, redirectURL: URLConvertible, applicationEndpoint : String){
        
        NSException.checkEndpoint(applicationEndpoint)
        
        self.applicationEndpoint = applicationEndpoint
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: redirectURL)
        
    }
    
    func setSDKVersion() -> String {
        let pathToConfigutationFile = Bundle.main.path(forResource: "Info", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        var sdkVersion = (itemsDictionaryRoot?.value(forKey: "CFBundleShortVersionString") as? String)!
        if (sdkVersion != SDKVersion ) {
            sdkVersion = SDKVersion
        }
        return sdkVersion
    }
    
    convenience init() {
        self.init(clientKey: "", clientSecret: "", redirectURL: "", applicationEndpoint : "")
    }

    
    // MARK: Request factory
    var noOperatorDataRequest : Request
    {
        return genericDiscoveryRequestWithParameters([:], shouldNotStartImmediately : true, correlationId : false)
    }
    
    func noOperatorDataRequest(correlationId: Bool? = false) -> Request {
        return genericDiscoveryRequestWithParameters([:], shouldNotStartImmediately : true, correlationId : false)
    }
    
    func requestNoOperatorDataRequest(_ clientIP: String? = "", correlationId : Bool? = false) -> Request {
        return genericDiscoveryRequestWithParameters([:], additionalHeaders: ["X-Source-IP":clientIP ?? "", "X-Redirect":MobileConnectSDK.getXRedirect()], shouldNotStartImmediately : true, correlationId: correlationId)
    }
    
    func requestWithCountryCode(_ countryCode : String, networkCode : String, correlationId : Bool? = false) -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyCountryCode : countryCode as AnyObject, kKeyNetworkCode : networkCode as AnyObject], additionalHeaders: ["Accept":"application/json", "X-Redirect":MobileConnectSDK.getXRedirect()], correlationId: correlationId)
    }
    
    func requestWithPhoneNumber(_ phoneNumber : String, clientIP : String? = "", correlationId : Bool? = false) -> Request
    {
        return genericDiscoveryRequestWithParameters([kKeyPhone : phoneNumber.replacingOccurrences(of: "+", with: "") as AnyObject], isPhoneRequest: true, additionalHeaders: ["Content-Type":"application/x-www-form-urlencoded", "X-Source-IP": clientIP ?? "", "X-Redirect":MobileConnectSDK.getXRedirect()], correlationId : correlationId)
    }
    
    fileprivate func genericDiscoveryRequestWithParameters(_ parameters : [String : AnyObject], isPhoneRequest : Bool = false, additionalHeaders : [String : String]? = nil, shouldNotStartImmediately : Bool = false, correlationId : Bool? = false) -> Request
    {
        
        var parametersNewDictionary = parameters
        parametersNewDictionary[kRedirectURL] = redirectURL as AnyObject?
        var newAdditionalHeaders = additionalHeaders
        newAdditionalHeaders?["SDK-Version"] = setSDKVersion()
        
        if (correlationId == true) {
            parametersNewDictionary[correlation] = uuidValue as AnyObject?
        }
        let method : HTTPMethod = isPhoneRequest ?  .post : .get
        let encoding : ParameterEncoding = isPhoneRequest ? URLEncoding.default : URLEncoding.methodDependent
        
        return requestWithMethod(method, url: applicationEndpoint, parameters: parametersNewDictionary, encoding: encoding, additionalHeaders: newAdditionalHeaders, shouldNotStartImmediately : shouldNotStartImmediately)
    }
    
}
