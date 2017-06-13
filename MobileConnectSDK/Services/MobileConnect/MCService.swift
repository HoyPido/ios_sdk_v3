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
public typealias MobileConnectDataResponse = (_ tokenModel : TokenModel?, _ error : NSError?) -> Void

/**
 The Mobile Connect response received in methods which require a presenter view controller
 - Parameter controller: The Mobile Connect controller which contains the web view. Should be dismissed by the developer.
 - Parameter tokenModel: The data received from the Mobile Connect service. Can be nil in case an error occured.
 - Parameter error: The error which is sent in case the operatorsData is nil.
 */
public typealias MobileConnectControllerResponse = (_ controller : BaseWebController?, _ tokenModel : TokenModel?, _ error : NSError?) -> Void

/**
 Provides access to all needed Mobile Connect services.
 Allows getting token data by providing a subscriber id, in which case only the loading web view will be presented.
 Allows getting token data by providing a subscriber id in which case a web view will be presented.
 The webview will require client's phone number.
 */
open class MCService: NSObject {
    
    // MARK: iVars
    let service : MobileConnectService
    
    init(service : MobileConnectService) {
        self.service = service
    }
    
    // MARK: init
    public convenience init(configuration : MobileConnectServiceConfiguration) {
        self.init(service: MobileConnectService(configuration: configuration))
    }
    
    // MARK: Main mobile connect service method
    /**
     Gets the token by presenting the loading web view Mobile Connect controller. In case a subscriber id is not provided the user will first see a page for entering his phone number.
     - Parameter controller: the controller in which the Mobile Connect should present the web view controller
     - Parameter completionHandler: the closure which will be called upon the method completition in order to pass the resultant Mobile Connect data.
     */
    open func getTokenInController(_ controller : UIViewController, correlationId: Bool, completionHandler : @escaping MobileConnectControllerResponse)
    {
        service.getAuthenticationTokenInController(controller, correlationId: correlationId, completionHandler: completionHandler)
    }
    
    /**
     Gets an authorization token by presenting the loading web view Mobile Connect controller. In case a subscriber id is not provided the user will first see a page for entering his phone number.
     - Parameter controller: the controller in which the Mobile Connect should present the web view controller
     - Parameter completionHandler: the closure which will be called upon the method completition in order to pass the resultant Mobile Connect data.
     */
    open func getAuthorizationTokenInController(_ controller : UIViewController, correlationId: Bool, completionHandler : @escaping MobileConnectControllerResponse)
    {
        service.getAuthorizationTokenInController(controller, correlationId: correlationId, completionHandler: completionHandler)
    }
}
