//
//  DSService.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 11/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

/**
 The Discovery response received in methods which do not require a presenter view controller
 - Parameter operatorsData: The data received from the Discovery service. Can be nil in case an error occured.
 - Parameter error: The error which is sent in case the operatorsData is nil.
 */
public typealias DiscoveryDataResponse = (operatorsData : DiscoveryResponse?, error : NSError?) -> Void

/**
 The Discovery response received in methods which required a presenter view controller. It is the responsability of the developer to dismiss the web controller.
 - Parameter controller: The Mobile Connect controller which contains the web view. Should be dismissed by the developer.
 - Parameter operatorsData: The data received from the Discovery service. Can be nil in case an error occured.
 - Parameter error: The error which is sent in case the operatorsData is nil.
 */
public typealias DiscoveryResponseBlock = (controller : BaseWebController?, operatorsData : DiscoveryResponse?, error : NSError?) -> Void

/**
    Provides access to all needed Discovery services.
    Allows getting operator data by providing a phone number, in which case the web view will not be presented.
    Allows getting operator data without any data from the client side in which case a web view will be presented.
    The webview will require client's operator data or phone number.
 */
public class DSService: NSObject {
    
    //MARK: iVars
    let service : DiscoveryService = DiscoveryService()

    //MARK: Discovery service with no client data
    ///Gets operator data by showing a webview which will request data from client
    public func startOperatorDiscoveryInController(controller : UIViewController, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryResponseBlock)
    {
        service.startOperatorDiscoveryInController(controller, shouldProvideMetadata: shouldProvideMetadata, completionHandler: completionHandler)
    }
    
    //MARK: Discovery service with client Country Code and Mobile Network Code
    //Gets operator data by using client's operator country code and network code. It will not return a subscriber_id as for the subcriber_id one should provide the concrete phone number.
    public func startOperatorDiscoveryWithCountryCode(countryCode : String, networkCode : String, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryDataResponse)
    {
        service.startOperatorDiscoveryWithCountryCode(countryCode, networkCode: networkCode, shouldProvideMetadata: shouldProvideMetadata, completionHandler: completionHandler)
    }
    
    //MARK: Discovery service with phone number
    //Gets operator data by using client's phone number. It will return a subscriber_id.
    public func startOperatorDiscoveryForPhoneNumber(phoneNumber : String, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryDataResponse)
    {
        service.startOperatorDiscoveryForPhoneNumber(phoneNumber, shouldProvideMetadata: shouldProvideMetadata,completionHandler: completionHandler)
    }
}
