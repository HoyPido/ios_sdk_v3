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
    
    // MARK: init
    required init(configuration : MobileConnectServiceConfiguration, requestConstructor : MCRequestConstructor? = nil)
    {
        self.configuration = configuration
        
        if let requestConstructor = requestConstructor
        {
            self.requestConstructor = requestConstructor
        } else
        {
            self.requestConstructor = MCRequestConstructor(configuration: configuration, scopeValidator: ScopeValidator(metadata: configuration.metadata))
        }
        
        super.init()
    }
    
    required init(webController: BaseWebController?) {
        fatalError("init(webController:) has not been implemented")
    }
    
    // MARK: Main mobile connect service method
    /**
     Gets the token which allows logging in[authenticating] by presenting the loading web view Mobile Connect controller. In case a subscriber id is not provided the user will first see a page for entering his phone number.
     - Parameter controller: the controller in which the Mobile Connect should present the web view controller
     - Parameter completionHandler: the closure which will be called upon the method completition in order to pass the resultant Mobile Connect data.
     */
    func getAuthenticationTokenInController(_ controller : UIViewController, completionHandler : @escaping MobileConnectControllerResponse)
    {
        let request : Request = requestConstructor.authenticationRequest
  
        startServiceInController(controller, withRequest: request, completionHandler: completionHandler)
    }
    
    /**
     Gets the token which allows access to user's details by presenting the loading web view Mobile Connect controller. In case a subscriber id is not provided the user will first see a page for entering his phone number.
     It will request user's rights specified in the scopes passed in the configuration object.
     - Parameter controller: the controller in which the Mobile Connect should present the web view controller
     - Parameter completionHandler: the closure which will be called upon the method completition in order to pass the resultant Mobile Connect data.
     */
    func getAuthorizationTokenInController(_ controller : UIViewController, completionHandler : @escaping MobileConnectControllerResponse)
    {
        if let request = requestConstructor.authorizationRequest
        {
            startServiceInController(controller, withRequest: request, completionHandler: completionHandler)
        } else
        {
            completionHandler(nil, nil, MCErrorCode.requiresAuthorizationConfiguration.error)
        }
    }
    
    // MARK: Secondary methods
    func getTokenWithCode(_ code : String, completionHandler : @escaping MobileConnectDataResponse)
    {
      
        processRequest(requestConstructor.tokenRequestAtURL(configuration.tokenURLString, withCode: code), withParameters: [(code, MCErrorCode.nilCode)]) { (model, error) in
          
            guard let model = model else {
                completionHandler(nil, error)
                return
            }

            guard let tokenValidator = TokenValidation(configuration: self.configuration, model: model) else
            {
                completionHandler(nil, MCErrorCode.noTokenID.error)
                
                return
            }
            
            tokenValidator.checkIdTokenIsValid({ (error) in
                completionHandler(model, error)
            })
        }
    }
    
    // MARK: WebController methods
    override var redirectURL : URL
    {
        return configuration.redirectURL as URL
    }
    
    override func didReceiveResponseFromController(_ webController: BaseWebController?, withRedirectModel redirectModel: AuthorizationModel?, error: NSError?)
    {
        //the server causes redirect with code parameter even after sending the token, which causes the relaunch of this method
        getTokenWithCode(redirectModel?.code ?? "") { (tokenModel, error) in
            self.controllerResponse?(webController, tokenModel, error)
        }
    }
    
    // MARK: Helper
    override func startInHandler(_ handler: () -> Void, withParameters parameters: [(String?, MCErrorCode)], completionHandler: (_ error: NSError) -> Void)
    {
        let localParameters : [(String?, MCErrorCode)] = parameters + [(configuration.clientKey, MCErrorCode.nilClientId), (configuration.authorizationURLString, MCErrorCode.nilAuthorizationURL), (configuration.tokenURLString, MCErrorCode.nilTokenURL)]
        
        super.startInHandler(handler, withParameters: localParameters, completionHandler: completionHandler)
    }
  
    
}
