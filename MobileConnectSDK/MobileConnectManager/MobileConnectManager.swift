//
//  MobileConnectManager.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 06/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

public typealias MobileConnectResponse = (tokenResponseModel : TokenResponseModel?, error : NSError?) -> Void

///This protocol allows catching events which occur while using the MobileConnectButton or MobileConnectManager class
@objc public protocol MobileConnectManagerDelegate {
    optional func mobileConnectWillStart()
    optional func mobileConnectWillPresentWebController()
    optional func mobileConnectWillDismissWebController()
    optional func mobileConnectDidGetTokenResponse(tokenResponse : TokenResponseModel)
    optional func mobileConnectFailedGettingTokenResponseWithError(error : NSError)
}

/**
 Abstracts the Discovery and Mobile Connect services by offering 2 convenience methods for directly getting the token. The token will be delivered in the supplied callbacks or delegate methods if set.
 */
public class MobileConnectManager: NSObject {
    
    ///The delegate responsible for receiving MobileConnectManager events
    public var delegate : MobileConnectManagerDelegate?
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
    
    //MARK: init
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
    
    //MARK: SDK main methods
    /**
     Will get the token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
     Will automatically try to retrieve and merge the Metadata.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     - Parameter scopes: The scopes to be authorized
     */
    public func getTokenInPresenterController(presenterController: UIViewController, withScopes scopes : [ProductType]? = nil, withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        getToken(presenterController, scopes : (scopes ?? []).map({$0.stringValue}), withCompletionHandler: completionHandler)
    }
    
    /**
     Will get the token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
     Will automatically try to retrieve and merge the Metadata.
     This methods allows passing string values for the scopes array.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     - Parameter scopes: The scopes to be authorized
     */
    public func getTokenInPresenterController(presenterController: UIViewController, withStringValueScopes scopes : [String], withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        getToken(presenterController, scopes : scopes, withCompletionHandler: completionHandler)
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
    
    public func getAuthorizationTokenInPresenterController(presenterController : UIViewController, withContext context : String, withScopes scopes : [ProductType], bindingMessage : String?, completionHandler : MobileConnectResponse?)
    {
        getToken(presenterController, context: context, scopes: scopes.map({$0.stringValue}), bindingMessage: bindingMessage, withCompletionHandler: completionHandler)
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
    
    public func getAuthorizationTokenInPresenterController(presenterController : UIViewController, withContext context : String, withStringValueScopes scopes : [String], bindingMessage : String?, completionHandler : MobileConnectResponse?)
    {
        getToken(presenterController, context: context, scopes: scopes, bindingMessage: bindingMessage, withCompletionHandler: completionHandler)
    }
    
    /**
     Will get the token with client's phone number. By providing the number the only web view presented will be that of the sms confirmation. Will use both Discovery and Mobile Connect services underneath.
     Will automatically try to retrieve and merge the Metadata.
     - Parameter phoneNumber: The client's phone number
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    public func getTokenForPhoneNumber(phoneNumber: String, inPresenterController presenterController : UIViewController, withScopes scopes : [ProductType]? = nil, withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        getTokenForPhoneNumber(phoneNumber, inPresenterController: presenterController, scopes : (scopes ?? []).map({$0.stringValue}), completionHandler: completionHandler)
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
    public func getTokenForPhoneNumber(phoneNumber: String, inPresenterController presenterController : UIViewController, withStringValueScopes scopes : [String], withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        getTokenForPhoneNumber(phoneNumber, inPresenterController: presenterController, scopes : scopes, completionHandler: completionHandler)
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
    public func getAuthorizationTokenForPhoneNumber(phoneNumber : String, inPresenterController presenterController : UIViewController, withScopes scopes : [ProductType], context : String, bindingMessage : String?, completionHandler : MobileConnectResponse?)
    {
        getTokenForPhoneNumber(phoneNumber, inPresenterController: presenterController, withContext: context, bindingMessage: bindingMessage, scopes:  scopes.map({$0.stringValue}),  completionHandler: completionHandler)
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
    public func getAuthorizationTokenForPhoneNumber(phoneNumber : String, inPresenterController presenterController : UIViewController, withStringValueScopes scopes : [String], context : String, bindingMessage : String?, completionHandler : MobileConnectResponse?)
    {
        getTokenForPhoneNumber(phoneNumber, inPresenterController: presenterController, withContext: context, bindingMessage: bindingMessage, scopes:  scopes,  completionHandler: completionHandler)
    }
  
    public func getAttributeServiceResponse(controller: UIViewController, context : String, scopes : [ProductType], bindingMessage : String? = nil, withCompletionHandler : (response: AttributeResponseModel?, error : NSError?) -> Void ){
      
      self.getAuthorizationTokenInPresenterController(controller, withContext: context, withScopes: scopes, bindingMessage: bindingMessage) { (tokenResponseModel, error) in
        guard let accessToken = tokenResponseModel?.tokenData?.access_token, premiumURL = tokenResponseModel?.discoveryResponse?.linksInformation?.premiumInfo() else {
          withCompletionHandler(response: nil, error: error)
          return
        }
        
        let attributeRequest = AttributeRequestConstructor(accessToken: accessToken)
        let attributeService = AttributeService(requestConstructor: attributeRequest)
        
        attributeService.getAttributeInformation(withURL: premiumURL, completionHandler: { (responseModel, error) in
          withCompletionHandler(response: responseModel, error: error)
        })
      }
      
      
    }
  
    func getToken(presenterController: UIViewController, context : String? = nil, scopes : [String]? = nil, bindingMessage : String? = nil, withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        startDiscoveryInHandler({
            
            self.delegate?.mobileConnectWillPresentWebController?()
            self.discovery.startOperatorDiscoveryInController(presenterController, completionHandler: {
              (controller, operatorsData, error) in
                self.checkDiscoveryResponse(controller, operatorsData: operatorsData, error: error)(context: context, scopes : scopes, bindingMessage : bindingMessage)
            })
            
            },presenter: presenterController, withCompletition: completionHandler)
    }
    
    func getTokenForPhoneNumber(phoneNumber: String, inPresenterController presenterController : UIViewController, withContext context : String? = nil, bindingMessage : String? = nil, scopes : [String]? = nil, completionHandler : MobileConnectResponse?)
    {
        startDiscoveryInHandler({
            
            self.discovery.startOperatorDiscoveryForPhoneNumber(phoneNumber, completionHandler: { (operatorsData, error) in
                
                self.checkDiscoveryResponse(nil, operatorsData: operatorsData, error: error)(context: context, scopes : scopes, bindingMessage : bindingMessage)
            })
            
            }, presenter: presenterController, withCompletition: completionHandler)
    }
    
    //MARK: Discovery methods
    func checkDiscoveryResponse(controller : BaseWebController?, operatorsData : DiscoveryResponse?, error : NSError?) -> (context : String?, scopes : [String]?, bindingMessage : String?) -> Void
    {
        return { (context : String?, scopes : [String]?, bindingMessage : String?) -> Void in
            
            guard let operatorsData = operatorsData else
            {
                self.finishWithResponse(controller, model: nil, error: error ?? MCErrorCode.Unknown.error)
                
                return
            }
            
            if let controller = controller
            {
                self.delegate?.mobileConnectWillDismissWebController?()
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
            
            var configuration : MobileConnectServiceConfiguration
            
            if let context = context
            {
                configuration = MCAuthorizationConfiguration(discoveryResponse: operatorsData, context: context, bindingMessage: bindingMessage , stringAuthorizationScopes: scopes ?? [])
            }
            else
            {
                configuration = MobileConnectServiceConfiguration(discoveryResponse: operatorsData, authorizationScopes : scopes ?? [])
            }
            
            let mobileConnect : MobileConnectService = MobileConnectService(configuration: configuration)
            
            self.getTokenWithMobileConnectService(mobileConnect, inWebController: controller, withOperatorsData: operatorsData, isAuthorization: context != .None)
        }
    }
    
    func getTokenWithMobileConnectService(mobileConnectService : MobileConnectService, inWebController webController : BaseWebController?, withOperatorsData operatorsData : DiscoveryResponse, isAuthorization : Bool = false)
    {
        if let presenter = currentPresenter
        {
            delegate?.mobileConnectWillPresentWebController?()
            
            if isAuthorization
            {
                mobileConnectService.getAuthorizationTokenInController(presenter, completionHandler: checkMobileConnectResponse(operatorsData))
            }
            else
            {
                mobileConnectService.getAuthenticationTokenInController(presenter, completionHandler: checkMobileConnectResponse(operatorsData))
            }
        }
        else
        {
            finishWithResponse(webController, model: nil, error: MCErrorCode.Unknown.error)
        }
    }
    
    //MARK: Mobile connect methods
    func checkMobileConnectResponse(operatorData : DiscoveryResponse?) -> (controller : BaseWebController?, tokenModel : TokenModel?, error: NSError?) -> Void
    {
        return { (controller : BaseWebController?, tokenModel : TokenModel?, error: NSError?) -> Void in
            
            self.finishWithResponse(controller, model: self.tokenResponseModel(tokenModel: tokenModel, operatorsData: operatorData), error: error)
        }
    }
    
    var tokenResponseModel : (tokenModel : TokenModel?, operatorsData : DiscoveryResponse?) -> TokenResponseModel?
    {
        return { (tokenModel : TokenModel?, operatorsData : DiscoveryResponse?) -> TokenResponseModel? in
            
            return TokenResponseModel(tokenModel: tokenModel, discoveryResponse: operatorsData)
        }
    }
    
    //MARK: Helpers
    func startDiscoveryInHandler(handler : () -> Void, presenter : UIViewController, withCompletition completionHandler : MobileConnectResponse?)
    {
        currentResponse = completionHandler
        
        if !isRunning
        {
            isRunning = true
            
            delegate?.mobileConnectWillStart?()
            
            currentPresenter = presenter
            
            handler()
        }
        else
        {
            finishWithResponse(nil, model: nil, error: MCErrorCode.Concurrency.error)
        }
    }
    
    func finishWithResponse(controller : BaseWebController?, model : TokenResponseModel?, error : NSError?)
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
        controller?.dismissViewControllerAnimated(true, completion: nil)
        
        currentResponse?( tokenResponseModel: model, error: error)
        
        currentResponse = nil
        currentPresenter = nil
    }
}
