//
//  MobileConnectManager.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 06/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

public typealias MobileConnectResponseWithUserInfo = (_ userInfo : UserInfoResponse?, _ tokenResponseModel : TokenResponseModel?, _ error : NSError?) -> Void

public typealias MobileConnectResponse = (_ tokenResponseModel : TokenResponseModel?, _ error : NSError?) -> Void

///This protocol allows catching events which occur while using the MobileConnectButton or MobileConnectManager class
@objc public protocol MobileConnectManagerDelegate {
    @objc optional func mobileConnectWillStart()
    @objc optional func mobileConnectWillPresentWebController()
    @objc optional func mobileConnectWillDismissWebController()
    @objc optional func mobileConnectDidGetTokenResponse(_ tokenResponse : TokenResponseModel)
    @objc optional func mobileConnectFailedGettingTokenResponseWithError(_ error : NSError)
}

/**
 Abstracts the Discovery and Mobile Connect services by offering 2 convenience methods for directly getting the token. The token will be delivered in the supplied callbacks or delegate methods if set.
 */
open class MobileConnectManager: NSObject {
    
    ///The delegate responsible for receiving MobileConnectManager events
    open var delegate : MobileConnectManagerDelegate?
    {
        didSet
        {
            NSException.checkDelegate(delegate)
        }
    }
    
    let discovery : DiscoveryService
    var currentResponse : MobileConnectResponse?
    var currentPresenter : UIViewController?
    
    var isRunning : Bool = false
    
    // MARK: init
    override public convenience init() {
        self.init(delegate: nil)
    }
    
    public convenience init(delegate : MobileConnectManagerDelegate?)
    {
        NSException.checkDelegate(delegate)
        
        self.init(delegate: delegate, discoveryService: DiscoveryService())
    }
    
    init(delegate : MobileConnectManagerDelegate?, discoveryService : DiscoveryService) {
        NSException.checkDelegate(delegate)
        
        self.delegate = delegate
        discovery = discoveryService
        
        super.init()
    }
    
    // MARK: SDK main methods
    /**
     Will get the token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
     Will automatically try to retrieve and merge the Metadata.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     - Parameter scopes: The scopes to be authorized
     */
    open func getTokenInPresenterController(_ presenterController: UIViewController, loginHint : String? = nil, withParameters config : AuthorizationConfigurationParameters? = nil, withScopes scopes : [ProductType]? = nil, withCompletionHandler completionHandler : MobileConnectResponseWithUserInfo?)
    {
        let scopesArray : [String]? = (scopes ?? []).map({$0.stringValue})
        getToken(presenterController, loginHint: loginHint, scopes : scopesArray) { (tokenResponseModel, error) in
            
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: (scopes ?? []).map({$0.stringValue}), completionHandler: completionHandler)
        }
    }
    
    /**
     Will get the token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
     Will automatically try to retrieve and merge the Metadata.
     This methods allows passing string values for the scopes array.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     - Parameter scopes: The scopes to be authorized
     */
    open func getTokenInPresenterController(_ presenterController: UIViewController, loginHint : String? = nil, withStringValueScopes scopes : [String], withParameters config : AuthorizationConfigurationParameters? = nil, withCompletionHandler completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getToken(presenterController, loginHint : loginHint, scopes : scopes, withParameters: config){ (tokenResponseModel, error) in
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: scopes, completionHandler: completionHandler)
        }

    }
    
    /**
     Will get the authorization token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
     Will automatically try to retrieve and merge the Metadata.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter context: The context required for making authorization requests
     - Parameter scopes: The scopes to be authorized
     - Parameter bindingMessage: The check message to be displayed in the web view while waiting for client's confirmation
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    
    open func getAuthorizationTokenInPresenterController(_ presenterController : UIViewController, withContext context : String, loginHint : String? = nil, withScopes scopes : [ProductType], withParameters config : AuthorizationConfigurationParameters? = nil, bindingMessage : String?, completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getToken(presenterController, context: context, loginHint : loginHint, scopes: scopes.map({$0.stringValue}), withParameters: config, bindingMessage: bindingMessage) { (tokenResponseModel, error) in
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: scopes.map({$0.stringValue}), completionHandler: completionHandler)
        }
    }
    
    /**
     Will get the authorization token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
     Will automatically try to retrieve and merge the Metadata.
     This methods allows passing string values for the scopes array.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter context: The context required for making authorization requests
     - Parameter scopes: The scopes to be authorized
     - Parameter bindingMessage: The check message to be displayed in the web view while waiting for client's confirmation
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    
    open func getAuthorizationTokenInPresenterController(_ presenterController : UIViewController, withContext context : String, loginHint : String? = nil, withStringValueScopes scopes : [String], withParameters config : AuthorizationConfigurationParameters? = nil, bindingMessage : String?, completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getToken(presenterController, context: context, loginHint : loginHint, scopes: scopes, withParameters: config, bindingMessage: bindingMessage) { (tokenResponseModel, error) in
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: scopes, completionHandler: completionHandler)
        }
    }
    
    /**
     Will get the token with client's phone number. By providing the number the only web view presented will be that of the sms confirmation. Will use both Discovery and Mobile Connect services underneath.
     Will automatically try to retrieve and merge the Metadata.
     - Parameter phoneNumber: The client's phone number
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    open func getTokenForPhoneNumber(_ phoneNumber: String, clientIP : String, inPresenterController presenterController : UIViewController, loginHint : String? = nil, withParameters config : AuthorizationConfigurationParameters? = nil, withScopes scopes : [ProductType]? = nil, withCompletionHandler completionHandler : MobileConnectResponseWithUserInfo?)
    {
        let scopesArray : [String]? = (scopes ?? []).map({$0.stringValue})
        getTokenForPhoneNumber(phoneNumber, clientIP: clientIP, inPresenterController: presenterController, loginHint : loginHint, scopes : scopesArray) { (tokenResponseModel, error) in
            
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes:  (scopes ?? []).map({$0.stringValue}), completionHandler: completionHandler)
        }
    }
    
    /**
     Will revoke token that user requests
     - Parameter tokenResponseModel: The response object that client gets after getting the access token
     - Parameter revokedToken: Token string that the user wants to be revoked; can be access token or refresh token
     - Parameter completionHandler: The closure in which the eventual revocation error will be return
     - Parameter isRefreshToken: The boolean value in which user specifies if is a refresh token or not
     */
    
    open func revokeToken(_ revokedToken : String, tokenResponseModel : TokenResponseModel, isRefreshToken : Bool = false, completionHandler : @escaping (_ error : NSError?) -> Void) {
        
        let revokeService = RevokeTokenService(revokedToken: revokedToken, tokenResponseModel: tokenResponseModel, isRefreshToken: isRefreshToken)
        revokeService.getRevokeToken {
            (responseModel : AnyObject?, error : NSError?) -> Void in
            completionHandler(error)
        }
    }
    
    /**
     Will reresh token with provided token model will return a new token refresh model
     - Parameter tokenResponseModel: The response object that client gets after getting the access token
     - Parameter completionHandler: The closure in which the new token refresh model or eventual refresh error will be return
     */
    
    open func refreshToken(_ tokenResponseModel : TokenResponseModel, withStringValueScopes scopes : [String]? = nil, completionHandler : @escaping (_ model : RefreshTokenModel?, _ error : NSError?) -> Void) {
        
        let refreshService = RefreshTokenService(tokenResponseModel: tokenResponseModel, scopes: scopes)
        refreshService.getRefreshToken { (responseModel, error) in
            completionHandler(responseModel, error)
        }
    }
    
    /**
     Will get the token with client's phone number. By providing the number the only web view presented will be that of the sms confirmation. Will use both Discovery and Mobile Connect services underneath.
     Will automatically try to retrieve and merge the Metadata.
     This methods allows passing string values for the scopes array.
     - Parameter phoneNumber: The client's phone number
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter scopes: The scopes to be authorized
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    open func getTokenForPhoneNumber(_ phoneNumber: String, clientIP: String, inPresenterController presenterController : UIViewController, loginHint : String? = nil, withParameters config : AuthorizationConfigurationParameters? = nil, withStringValueScopes scopes : [String], withCompletionHandler completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getTokenForPhoneNumber(phoneNumber, clientIP: clientIP, inPresenterController: presenterController, loginHint : loginHint, scopes : scopes) { (tokenResponseModel, error) in
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: scopes, completionHandler: completionHandler)
        }

    }
    
    /**
     Will get the token with client's phone number. By providing the number the only web view presented will be that of the sms confirmation. Will use both Discovery and Mobile Connect services underneath.
     Will automatically try to retrieve and merge the Metadata.
     - Parameter phoneNumber: The client's phone number
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter scopes: The scopes to be authorized
     - Parameter context: The context required for making authorization requests
     - Parameter bindingMessage: The check message to be displayed in the web view while waiting for client's confirmation
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    open func getAuthorizationTokenForPhoneNumber(_ phoneNumber : String, clientIP : String, inPresenterController presenterController : UIViewController, loginHint : String? = nil, withScopes scopes : [ProductType], withParameters config : AuthorizationConfigurationParameters? = nil, context : String, bindingMessage : String?, completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getTokenForPhoneNumber(phoneNumber, clientIP: clientIP, inPresenterController: presenterController, withContext: context, bindingMessage: bindingMessage, loginHint : loginHint, scopes:  scopes.map({$0.stringValue}), config: config) { (tokenResponseModel, error) in
           self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: scopes.map({$0.stringValue}), completionHandler: completionHandler)
        }
    }
    
    /**
     Will get the token with client's phone number. By providing the number the only web view presented will be that of the sms confirmation. Will use both Discovery and Mobile Connect services underneath.
     Will automatically try to retrieve and merge the Metadata.
     This methods allows passing string values for the scopes array.
     - Parameter phoneNumber: The client's phone number
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter scopes: The scopes to be authorized
     - Parameter context: The context required for making authorization requests
     - Parameter bindingMessage: The check message to be displayed in the web view while waiting for client's confirmation
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    open func getAuthorizationTokenForPhoneNumber(_ phoneNumber : String, clientIP : String, inPresenterController presenterController : UIViewController, loginHint : String? = nil, withStringValueScopes scopes : [String], withParameters config : AuthorizationConfigurationParameters? = nil, context : String, bindingMessage : String?, completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getTokenForPhoneNumber(phoneNumber, clientIP: clientIP, inPresenterController: presenterController, withContext: context, bindingMessage: bindingMessage, loginHint : loginHint, scopes:  scopes, config: config) { (tokenResponseModel, error) in
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: scopes, completionHandler: completionHandler)
        }
    }
    
    open func processUserInfoCompletionHandler( _ tokenResponseModel : TokenResponseModel?, error : NSError?, scopes : [String]?, completionHandler : MobileConnectResponseWithUserInfo?) {
        if let completionHandler = completionHandler {
            if let scopes = scopes {
                
                let scopesFiltered = scopes.filter({$0 != MobileConnectIdentityPhone && $0 != MobileConnectIdentitySignup && $0 != MobileConnectIdentityNationalID})
                if scopesFiltered.count > 0 {
                    guard let tokenResponseModel = tokenResponseModel else {
                        completionHandler(nil, nil, error)
                        return
                    }
                    
                    let userInfoService = UserInfoService(tokenResponse: tokenResponseModel)
                    
                    userInfoService.getUserInformation({ (responseModel, error) in
                        completionHandler(responseModel, tokenResponseModel, error)
                    })
                } else {
                    
                    completionHandler(nil, tokenResponseModel, error)
                }
            } else {
                completionHandler(nil, tokenResponseModel, error)
            }
        }
    }
    
    open func getAttributeServiceResponseWithPhoneNumber(_ phoneNumber : String, clientIP: String, inPresenterController presenterController : UIViewController, loginHint : String? = nil, withParameters config : AuthorizationConfigurationParameters? = nil, withStringValueScopes scopes : [ProductType], context : String, bindingMessage : String?, completionHandler : @escaping (_ attributeResponseModel : AttributeResponseModel?, _ tokenResponseModel : TokenResponseModel?, _ error : NSError?) -> Void ) {
        
        getAuthorizationTokenForPhoneNumber(phoneNumber, clientIP: clientIP, inPresenterController: presenterController, loginHint : loginHint, withScopes: scopes, context: context, bindingMessage: bindingMessage) { (userInfo, tokenResponseModel, error) in
            guard let tokenResponseModel = tokenResponseModel  else {
                completionHandler(nil, nil, error)
                return
            }
            
            let attributeService = AttributeService(tokenResponse: tokenResponseModel)
            
            attributeService.getAttributeInformation({ (responseModel, error) in
                completionHandler(responseModel, tokenResponseModel, error)
            })
        }
    }
    
    open func getAttributeServiceResponse(_ controller: UIViewController, context : String, loginHint : String? = nil, stringScopes : [String], bindingMessage : String? = nil, withCompletionHandler : @escaping (_ attributeResponseModel : AttributeResponseModel?, _ tokenResponseModel : TokenResponseModel?, _ error : NSError?) -> Void ){
        
        getAuthorizationTokenInPresenterController(controller, withContext: context, loginHint : loginHint, withStringValueScopes: stringScopes, bindingMessage: bindingMessage) { (userInfo, tokenResponseModel, error) in
    
            guard let tokenResponseModel = tokenResponseModel  else {
                withCompletionHandler(nil, nil, error)
                return
            }
            
            let attributeService = AttributeService(tokenResponse: tokenResponseModel)
            
            attributeService.getAttributeInformation({ (responseModel, error) in
                withCompletionHandler(responseModel, tokenResponseModel, error)
            })
        }
    }
    
    open func getAttributeServiceResponse(_ controller: UIViewController, context : String, loginHint : String? = nil, scopes : [ProductType], bindingMessage : String? = nil, withParameters config : AuthorizationConfigurationParameters? = nil, withCompletionHandler : @escaping (_ attributeResponseModel : AttributeResponseModel?, _ tokenResponseModel : TokenResponseModel?, _ error : NSError?) -> Void ){
      
        self.getAttributeServiceResponse(controller, context: context, loginHint : loginHint, stringScopes: scopes.flatMap({$0.stringValue}), bindingMessage: bindingMessage, withCompletionHandler: withCompletionHandler)
    }
  
    func getToken(_ presenterController: UIViewController, context : String? = nil, loginHint : String?, scopes : [String]? = nil, withParameters config : AuthorizationConfigurationParameters? = nil, bindingMessage : String? = nil, withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        startDiscoveryInHandler({
            
            self.delegate?.mobileConnectWillPresentWebController?()
        
            self.discovery.startOperatorDiscoveryInController(presenterController, completionHandler: {
              (controller, operatorsData, error) in
                self.checkDiscoveryResponse(controller, loginHint: loginHint, operatorsData: operatorsData, error: error)(context, scopes, config, bindingMessage)
            })
            
            }, presenter: presenterController, withCompletition: completionHandler)
    }
   
    func getTokenForPhoneNumber(_ phoneNumber: String, clientIP: String, inPresenterController presenterController : UIViewController, withContext context : String? = nil, bindingMessage : String? = nil, loginHint : String?, scopes : [String]? = nil, config : AuthorizationConfigurationParameters? = nil, completionHandler : MobileConnectResponse?)
    {
        startDiscoveryInHandler({
            
            self.discovery.startOperatorDiscoveryForPhoneNumber(phoneNumber, clientIP: clientIP,completionHandler: { (operatorsData, error) in
                
                self.checkDiscoveryResponse(nil, loginHint: loginHint, operatorsData: operatorsData, error: error)(context, scopes, config, bindingMessage)
            })
            
            }, presenter: presenterController, withCompletition: completionHandler)
    }
    
    // MARK: Discovery methods
    func checkDiscoveryResponse(_ controller : BaseWebController?, loginHint : String?, operatorsData : DiscoveryResponse?, error : NSError?) -> (_ context : String?, _ scopes : [String]?, _ config : AuthorizationConfigurationParameters?, _ bindingMessage : String?) -> Void
    {
        return { (context : String?, scopes : [String]?, config : AuthorizationConfigurationParameters?, bindingMessage : String?) -> Void in
            guard let operatorsData = operatorsData else
            {
                self.finishWithResponse(controller, model: nil, error: error ?? MCErrorCode.unknown.error)
                
                return
            }
            
            if let controller = controller
            {
                self.delegate?.mobileConnectWillDismissWebController?()
                controller.dismiss(animated: true, completion: nil)
            }
            
            var configuration : MobileConnectServiceConfiguration
            
            if (config?.login_hint_token?.isEmpty == false) {
                if let context = context {
                    configuration = MCAuthorizationConfiguration(discoveryResponse: operatorsData, context: context, bindingMessage: bindingMessage, stringAuthorizationScopes: scopes ?? [], config: config)
                } else {
                    configuration = MobileConnectServiceConfiguration(discoveryResponse: operatorsData, authorizationScopes : scopes ?? [], config: config)
                }
            } else {
                if let context = context {
                    configuration = MCAuthorizationConfiguration(discoveryResponse: operatorsData, context: context, bindingMessage: bindingMessage, stringAuthorizationScopes: scopes ?? [], config: config, loginHint: loginHint)
                } else {
                    configuration = MobileConnectServiceConfiguration(discoveryResponse: operatorsData, authorizationScopes : scopes ?? [], config: config, loginHint : loginHint)
                }
            }
            
            let mobileConnect : MobileConnectService = MobileConnectService(configuration: configuration)
            
            self.getTokenWithMobileConnectService(mobileConnect, inWebController: controller, withOperatorsData: operatorsData, isAuthorization: context != .none)
        }
    }
    
    func getTokenWithMobileConnectService(_ mobileConnectService : MobileConnectService, inWebController webController : BaseWebController?, withOperatorsData operatorsData : DiscoveryResponse, isAuthorization : Bool = false)
    {
        if let presenter = currentPresenter
        {
            delegate?.mobileConnectWillPresentWebController?()
            
            if isAuthorization
            {
                mobileConnectService.getAuthorizationTokenInController(presenter, completionHandler: checkMobileConnectResponseWithUserInfo(operatorsData))
            } else {
                mobileConnectService.getAuthenticationTokenInController(presenter, completionHandler: checkMobileConnectResponseWithUserInfo(operatorsData))
            }
        } else
        {
            finishWithResponse(webController, model: nil, error: MCErrorCode.unknown.error)
        }
    }
    
    // MARK: Mobile connect methods
    func checkMobileConnectResponseWithUserInfo(_ operatorData : DiscoveryResponse?) -> (_ controller : BaseWebController?, _ tokenModel : TokenModel?, _ error: NSError?) -> Void
    {
        return { (controller : BaseWebController?, tokenModel : TokenModel?, error: NSError?) -> Void in
            
            self.finishWithResponse(controller, model: self.tokenResponseModel(tokenModel, operatorData), error: error)
        }
    }
    
    var tokenResponseModel : (_ tokenModel : TokenModel?, _ operatorsData : DiscoveryResponse?) -> TokenResponseModel?
    {
        return { (tokenModel : TokenModel?, operatorsData : DiscoveryResponse?) -> TokenResponseModel? in
            
            return TokenResponseModel(tokenModel: tokenModel, discoveryResponse: operatorsData)
        }
    }
    
    // MARK: Helpers
    func startDiscoveryInHandler(_ handler : () -> Void, presenter : UIViewController, withCompletition completionHandler : MobileConnectResponse?)
    {
        currentResponse = completionHandler
        
        if !isRunning {
            
            isRunning = true
            
            delegate?.mobileConnectWillStart?()
            
            currentPresenter = presenter
            
            handler()
        } else {
            finishWithResponse(nil, model: nil, error: MCErrorCode.concurrency.error)
        }
    }
    
    func finishWithResponse(_ controller : BaseWebController?, model : TokenResponseModel?, error : NSError?)
    {
        isRunning = false
        
        if let error = error
        {
            delegate?.mobileConnectFailedGettingTokenResponseWithError?(error)
        }
        
        if let model = model
        {
            delegate?.mobileConnectDidGetTokenResponse?(model)
        }
        
        delegate?.mobileConnectWillDismissWebController?()
        controller?.dismiss(animated: true, completion: nil)
        
        currentResponse?(model, error)
        
        currentResponse = nil
        currentPresenter = nil
    }
}
