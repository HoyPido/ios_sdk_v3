//
//  MCService.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 11/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

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
    init(levelOfAssurance : MCLevelOfAssurance,clientId : String,
         authorizationURL : String,
         tokenURL : String,
         redirectURL : NSURL,
         clientKey : String,
         clientSecret : String)
    {
        service = MobileConnectService(levelOfAssurance: levelOfAssurance, clientId: clientId, authorizationURL: authorizationURL, tokenURL: tokenURL, redirectURL: redirectURL, clientKey: clientKey, clientSecret: clientSecret)
    }
    
    ///The constructor to be used in case a specific level of assurance is needed.
    public convenience init(levelOfAssurance : MCLevelOfAssurance,
                            clientId : String, authorizationURL : String,
                            tokenURL : String)
    {
        self.init(levelOfAssurance: levelOfAssurance, clientId: clientId, authorizationURL: authorizationURL, tokenURL:  tokenURL, redirectURL: MobileConnectSDK.getRedirectURL(), clientKey: MobileConnectSDK.getClientKey(), clientSecret: MobileConnectSDK.getClientSecret())
    }
    
    /**
     This constructor will default the levelOfAssurance to Level 2.
     - Parameter clientId: the client id received from the discovery OperatorData model
     - Parameter authorizationURL: the authorization url received from the discovery OperatorData model
     - Parameter tokenURL: the token url received from the discovery OperatorData model
     */
    public convenience init(clientId : String, authorizationURL : String, tokenURL : String)
    {
        self.init(levelOfAssurance: MCLevelOfAssurance.Level2, clientId: clientId, authorizationURL:  authorizationURL, tokenURL:  tokenURL)
    }

    //MARK: Main mobile connect service method
    /**
     Gets the token by presenting the loading web view Mobile Connect controller. In case a subscriber id is not provided the user will first see a page for entering his phone number.
     - Parameter controller: the controller in which the Mobile Connect should present the web view controller
     - Parameter subscriberId: the subscriber id received from the Discovery service operatorData model
     - Parameter completitionHandler: the closure which will be called upon the method completition in order to pass the resultant Mobile Connect data.
     */
    public func getTokenInController(controller : UIViewController, subscriberId : String? = nil, completitionHandler : MobileConnectControllerResponse)
    {
        service.getTokenInController(controller, subscriberId: subscriberId, completitionHandler: completitionHandler)
    }
}
