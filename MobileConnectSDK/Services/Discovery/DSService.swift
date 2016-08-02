//
//  DSService.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 11/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit


/**
    Provides access to all needed Discovery services.
    Allows getting operator data by providing a phone number, in which case the web view will not be presented.
    Allows getting operator data without any data from the client side in which case a web view will be presented.
    The webview will require client's operator data or phone number.
 
    Objective C Wrapper class around DiscoveryService
    It is needed because Objective C cannot access generic classes or classes which inherit from generic classes
 */
public class DSService: NSObject {
    
    //MARK: iVars
    let service : DiscoveryService = DiscoveryService()

    //MARK: Discovery service with no client data
    ///Gets operator data by showing a webview which will request data from client
    public func startOperatorDiscoveryInController(controller : UIViewController, completionHandler : DiscoveryResponseBlock)
    {
        service.startOperatorDiscoveryInController(controller, completionHandler: completionHandler)
    }
    
    //MARK: Discovery service with client Country Code and Mobile Network Code
    //Gets operator data by using client's operator country code and network code. It will not return a subscriber_id as for the subcriber_id one should provide the concrete phone number.
    public func startOperatorDiscoveryWithCountryCode(countryCode : String, networkCode : String, completionHandler : DiscoveryDataResponse)
    {
        service.startOperatorDiscoveryWithCountryCode(countryCode, networkCode: networkCode, completionHandler: completionHandler)
    }
    
    //MARK: Discovery service with phone number
    //Gets operator data by using client's phone number. It will return a subscriber_id.
    public func startOperatorDiscoveryForPhoneNumber(phoneNumber : String, completionHandler : DiscoveryDataResponse)
    {
        service.startOperatorDiscoveryForPhoneNumber(phoneNumber, completionHandler: completionHandler)
    }
}
