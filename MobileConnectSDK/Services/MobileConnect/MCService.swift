//
//  MCService.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 11/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

/**
 The Mobile Connect response received in methods which do not require a presenter view controller
 - Parameter tokenModel: The data received from the Mobile Connect service. Can be nil in case an error occured.
 - Parameter error: The error which is sent in case the operatorsData is nil.
 */
public typealias MobileConnectDataResponse = (tokenModel : TokenModel?, error : NSError?) -> Void

/**
 The Mobile Connect response received in methods which require a presenter view controller
 - Parameter controller: The Mobile Connect controller which contains the web view. Should be dismissed by the developer.
 - Parameter tokenModel: The data received from the Mobile Connect service. Can be nil in case an error occured.
 - Parameter error: The error which is sent in case the operatorsData is nil.
 */
public typealias MobileConnectControllerResponse = (controller : BaseWebController?, tokenModel : TokenModel?, error : NSError?) -> Void

/**
 Provides access to all needed Mobile Connect services.
 Allows getting token data by providing a subscriber id, in which case only the loading web view will be presented.
 Allows getting token data by providing a subscriber id in which case a web view will be presented.
 The webview will require client's phone number.
 
 Objective C Wrapper class around MobileConnectService
 It is needed because objective c cannot access generic classes or classes which inherit from generic classes
 */
public class MCService: NSObject {
    
    //MARK: iVar
    let service : MobileConnectService
    
    //MARK: init
    /**
     This constructor will default the levelOfAssurance to Level 2.
     - Parameter levelOfAssurance: The required level of assurance.
     - Parameter clientId: the client id received from the discovery OperatorData model
     - Parameter clientSecret: the client secret received from the discovery OperatorData model
     - Parameter authorizationURL: the authorization url received from the discovery OperatorData model
     - Parameter tokenURL: the token url received from the discovery OperatorData model
     */
    public init(configuration : MobileConnectServiceConfiguration) {
        
        service = MobileConnectService(configuration: configuration)
    }
    
    //MARK: Main mobile connect service method
    /**
     Gets the token by presenting the loading web view Mobile Connect controller. In case a subscriber id is not provided the user will first see a page for entering his phone number.
     - Parameter controller: the controller in which the Mobile Connect should present the web view controller
     - Parameter subscriberId: the subscriber id received from the Discovery service operatorData model
     - Parameter completionHandler: the closure which will be called upon the method completition in order to pass the resultant Mobile Connect data.
     */
    public func getTokenInController(controller : UIViewController, subscriberId : String? = nil, completionHandler : MobileConnectControllerResponse)
    {
        service.getTokenInController(controller, subscriberId: subscriberId, completionHandler: completionHandler)
    }
}
