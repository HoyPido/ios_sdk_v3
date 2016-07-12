//
//  MobileConnectService.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 09/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

class MobileConnectService: BaseMobileConnectService<TokenModel, AuthorizationModel> {
    
    let configuration : MobileConnectServiceConfiguration
    let requestConstructor : MCRequestConstructor
    
    //MARK: init
    required init(configuration : MobileConnectServiceConfiguration, requestConstructor : MCRequestConstructor? = nil)
    {
        self.configuration = configuration
        
        if let requestConstructor = requestConstructor
        {
            self.requestConstructor = requestConstructor
        }
        else
        {
            self.requestConstructor = MCRequestConstructor(clientKey: configuration.clientKey, clientSecret: configuration.clientSecret, redirectURL: configuration.redirectURL, scopeValidator: ScopeValidator(metadata: configuration.metadata))
        }
        
        super.init()
    }
    
    //MARK: Main mobile connect service method
    /**
     Gets the token by presenting the loading web view Mobile Connect controller. In case a subscriber id is not provided the user will first see a page for entering his phone number.
     - Parameter controller: the controller in which the Mobile Connect should present the web view controller
     - Parameter subscriberId: the subscriber id received from the Discovery service operatorData model
     - Parameter completionHandler: the closure which will be called upon the method completition in order to pass the resultant Mobile Connect data.
     */
    func getTokenInController(controller : UIViewController, subscriberId : String? = nil, completionHandler : MobileConnectControllerResponse)
    {
        startServiceInController(controller, withRequest: requestConstructor.authorizationRequestWithAssuranceLevel(configuration.assuranceLevel, subscriberId: subscriberId, atURL: configuration.authorizationURLString, withScopes : configuration.scopes), completionHandler: completionHandler)
    }
    
    //MARK: Secondary methods
    func getTokenWithCode(code : String, completionHandler : MobileConnectDataResponse)
    {
        processRequest(requestConstructor.tokenRequestAtURL(configuration.tokenURLString, withCode: code), withParameters: [(code, MCErrorCode.NilCode)], inHandler: completionHandler)
    }
    
    //MARK: WebController methods
    override var redirectURL : NSURL
    {
        return configuration.redirectURL
    }
    
    override func didReceiveResponseFromController(webController: BaseWebController?, withRedirectModel redirectModel: AuthorizationModel?, error: NSError?)
    {
        //the server causes redirect with code parameter even after sending the token, which causes the relaunch of this method
        getTokenWithCode(redirectModel?.code ?? "") { (tokenModel, error) in
            self.controllerResponse?(controller: webController, model: tokenModel, error: error)
        }
    }
    
    //MARK: Helper
    override func startInHandler(handler: () -> Void, withParameters parameters: [(String?, MCErrorCode)], completionHandler: (error: NSError) -> Void)
    {
        let localParameters : [(String?, MCErrorCode)] = parameters + [(configuration.clientKey, MCErrorCode.NilClientId), (configuration.authorizationURLString, MCErrorCode.NilAuthorizationURL), (configuration.tokenURLString, MCErrorCode.NilTokenURL)]
        
        super.startInHandler(handler, withParameters: localParameters, completionHandler: completionHandler)
    }
}
