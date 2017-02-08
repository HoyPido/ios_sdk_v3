//
//  MobileConnectManager.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 06/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

public typealias MobileConnectResponseWithoutCallWithUserInfo = (userInfo : UserInfoResponse?, tokenResponseModel : TokenResponseModel?, error : NSError?) -> Void

public typealias MobileConnectResponseWithoutCall = (tokenResponseModel : TokenResponseModel?, error : NSError?) -> Void

///This protocol allows catching events which occur while using the MobileConnectButton or MobileConnectManager class
@objc public protocol MobileConnectManagerWithoutCallDelegate {
    optional func mobileConnectWillStart()
    optional func mobileConnectWillPresentWebController()
    optional func mobileConnectWillDismissWebController()
    optional func mobileConnectDidGetTokenResponse(tokenResponse : TokenResponseModel)
    optional func mobileConnectFailedGettingTokenResponseWithError(error : NSError)
}

/**
 Abstracts the Discovery and Mobile Connect services by offering 2 convenience methods for directly getting the token. The token will be delivered in the supplied callbacks or delegate methods if set.
 */
public class MobileConnectManagerWithoutCall: NSObject {
    
    ///The delegate responsible for receiving MobileConnectManager events
    public var delegate : MobileConnectManagerWithoutCallDelegate?
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
    
    public convenience init(delegate : MobileConnectManagerWithoutCallDelegate?)
    {
        NSException.checkDelegate(delegate)
        
        self.init(delegate: delegate, discoveryService: DiscoveryService())
    }
    
    init(delegate : MobileConnectManagerWithoutCallDelegate?, discoveryService : DiscoveryService) {
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
    public func getTokenInPresenterController(presenterController: UIViewController, loginHint : String? = nil, withScopes scopes : [ProductType]? = nil, withCompletionHandler completionHandler : MobileConnectResponseWithUserInfo?, discoveryResponse: DiscoveryResponse)
    {
        let scopesArray : [String]? = (scopes ?? []).map({$0.stringValue})
     
        getToken(presenterController, loginHint: loginHint, scopes : scopesArray, discoveryResponse: discoveryResponse) { (tokenResponseModel, error) in
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
    public func getTokenInPresenterController(presenterController: UIViewController, loginHint : String? = nil, withStringValueScopes scopes : [String], withParameters config : AuthorizationConfigurationParameters? = nil, withCompletionHandler completionHandler : MobileConnectResponseWithUserInfo?, discoveryResponse: DiscoveryResponse)
    {
        getToken(presenterController, loginHint : loginHint, scopes : scopes, withParameters: config, discoveryResponse: discoveryResponse){ (tokenResponseModel, error) in
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
    
    public func getAuthorizationTokenInPresenterController(presenterController : UIViewController, withContext context : String, loginHint : String? = nil, withScopes scopes : [ProductType], withParameters config : AuthorizationConfigurationParameters? = nil, bindingMessage : String?, discoveryResponse: DiscoveryResponse, completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getToken(presenterController, context: context, loginHint : loginHint, scopes: scopes.map({$0.stringValue}), withParameters: config, bindingMessage: bindingMessage, discoveryResponse: discoveryResponse) { (tokenResponseModel, error) in
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
    
    public func getAuthorizationTokenInPresenterController(presenterController : UIViewController, withContext context : String, loginHint : String? = nil, withStringValueScopes scopes : [String], withParameters config : AuthorizationConfigurationParameters? = nil, bindingMessage : String?, discoveryResponse: DiscoveryResponse, completionHandler : MobileConnectResponseWithUserInfo?)
    {
        getToken(presenterController, context: context, loginHint : loginHint, scopes: scopes, withParameters: config, bindingMessage: bindingMessage, discoveryResponse: discoveryResponse) { (tokenResponseModel, error) in
            self.processUserInfoCompletionHandler(tokenResponseModel, error: error, scopes: scopes, completionHandler: completionHandler)
        }
    }

    /**
     Will revoke token that user requests
     - Parameter tokenResponseModel: The response object that client gets after getting the access token
     - Parameter revokedToken: Token string that the user wants to be revoked; can be access token or refresh token
     - Parameter completionHandler: The closure in which the eventual revocation error will be return
     - Parameter isRefreshToken: The boolean value in which user specifies if is a refresh token or not
     */
    
    public func revokeToken(revokedToken : String, tokenResponseModel : TokenResponseModel, isRefreshToken : Bool = false, completionHandler : (error : NSError?) -> Void) {
        
        let revokeService = RevokeTokenService(revokedToken: revokedToken, tokenResponseModel: tokenResponseModel, isRefreshToken: isRefreshToken)
        revokeService.getRevokeToken {
            (responseModel : AnyObject?, error : NSError?) -> Void in
            completionHandler(error: error)
        }
    }
    
    /**
     Will reresh token with provided token model will return a new token refresh model
     - Parameter tokenResponseModel: The response object that client gets after getting the access token
     - Parameter completionHandler: The closure in which the new token refresh model or eventual refresh error will be return
     */
    
    public func refreshToken(tokenResponseModel : TokenResponseModel, withStringValueScopes scopes : [String]? = nil, completionHandler : (model : RefreshTokenModel?, error : NSError?) -> Void) {
        
        let refreshService = RefreshTokenService(tokenResponseModel: tokenResponseModel, scopes: scopes)
        refreshService.getRefreshToken { (responseModel, error) in
            completionHandler(model: responseModel, error: error)
        }
    }
    
    public func processUserInfoCompletionHandler( tokenResponseModel : TokenResponseModel?, error : NSError?, scopes : [String]?, completionHandler : MobileConnectResponseWithUserInfo?) {
        if let completionHandler = completionHandler {
            if let scopes = scopes {
                
                let scopesFiltered = scopes.filter({$0 != MobileConnectIdentityPhone && $0 != MobileConnectIdentitySignup && $0 != MobileConnectIdentityNationalID})
                if scopesFiltered.count > 0 {
                    guard let tokenResponseModel = tokenResponseModel else {
                        completionHandler(userInfo: nil, tokenResponseModel: nil, error: error)
                        return
                    }
                    
                    let userInfoService = UserInfoService(tokenResponse: tokenResponseModel)
                    
                    userInfoService.getUserInformation({ (responseModel, error) in
                        completionHandler(userInfo: responseModel, tokenResponseModel: tokenResponseModel, error: error)
                    })
                } else {
                    
                    completionHandler(userInfo: nil, tokenResponseModel: tokenResponseModel, error: error)
                }
            } else {
                completionHandler(userInfo: nil, tokenResponseModel: tokenResponseModel, error: error)
            }
        }
    }
    
    public func getAttributeServiceResponse(controller: UIViewController, context : String, loginHint : String? = nil, stringScopes : [String], bindingMessage : String? = nil, discoveryResponse: DiscoveryResponse, withCompletionHandler : (attributeResponseModel : AttributeResponseModel?, tokenResponseModel : TokenResponseModel?, error : NSError?) -> Void ){
        
        getAuthorizationTokenInPresenterController(controller, withContext: context, loginHint : loginHint, withStringValueScopes: stringScopes, bindingMessage: bindingMessage, discoveryResponse: discoveryResponse) { (userInfo, tokenResponseModel, error) in
            
            guard let tokenResponseModel = tokenResponseModel  else {
                withCompletionHandler(attributeResponseModel: nil, tokenResponseModel: nil, error: error)
                return
            }
            
            let attributeService = AttributeService(tokenResponse: tokenResponseModel)
            
            attributeService.getAttributeInformation({ (responseModel, error) in
                withCompletionHandler(attributeResponseModel: responseModel, tokenResponseModel: tokenResponseModel, error: error)
            })
        }
    }
    
    public func getAttributeServiceResponse(controller: UIViewController, context : String, loginHint : String? = nil, scopes : [ProductType], bindingMessage : String? = nil, discoveryResponse: DiscoveryResponse, withCompletionHandler : (attributeResponseModel : AttributeResponseModel?, tokenResponseModel : TokenResponseModel?, error : NSError?) -> Void ){
        
        self.getAttributeServiceResponse(controller, context: context, loginHint : loginHint, stringScopes: scopes.flatMap({$0.stringValue}), bindingMessage: bindingMessage, discoveryResponse: discoveryResponse, withCompletionHandler: withCompletionHandler)
    }
    
    
    func getToken(presenterController: UIViewController, context : String? = nil, loginHint : String?, scopes : [String]? = nil, withParameters config : AuthorizationConfigurationParameters? = nil, bindingMessage : String? = nil, discoveryResponse: DiscoveryResponse, withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        startDiscoveryInHandler({
            
            self.delegate?.mobileConnectWillPresentWebController?()
            self.discovery.startOperatorWithoutDiscoveryCall(presenterController, completionHandler: {
                (controller, operatorsData, error) in
                self.checkDiscoveryResponse(controller, loginHint: loginHint, operatorsData: operatorsData, error: error)(context: context, scopes : scopes, config : config, bindingMessage : bindingMessage)
            }, discoveryResponse: discoveryResponse)
            
            }, presenter: presenterController, withCompletition: completionHandler)
    
    }
    
    // MARK: Discovery methods
    func checkDiscoveryResponse(controller : BaseWebController?, loginHint : String?, operatorsData : DiscoveryResponse?, error : NSError?) -> (context : String?, scopes : [String]?, config : AuthorizationConfigurationParameters?, bindingMessage : String?) -> Void
    {
        let operatorTest = operatorsData

        return { (context : String?, scopes : [String]?, config : AuthorizationConfigurationParameters?, bindingMessage : String?) -> Void in
            
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
            
            if let context = context {
                
                configuration = MCAuthorizationConfiguration(discoveryResponse: operatorTest!, context: context, bindingMessage: bindingMessage, stringAuthorizationScopes: scopes ?? [], config: config, loginHint: loginHint)
            } else {
                configuration = MobileConnectServiceConfiguration(discoveryResponse: operatorTest!, authorizationScopes : scopes ?? [], loginHint : loginHint)
            }
            
            let mobileConnect : MobileConnectService = MobileConnectService(configuration: configuration)
            
            self.getTokenWithMobileConnectService(mobileConnect, inWebController: controller, withOperatorsData: operatorTest!, isAuthorization: context != .None)
        }
    }
    
    func getTokenWithMobileConnectService(mobileConnectService : MobileConnectService, inWebController webController : BaseWebController?, withOperatorsData operatorsData : DiscoveryResponse, isAuthorization : Bool = false)
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
            finishWithResponse(webController, model: nil, error: MCErrorCode.Unknown.error)
        }
    }
    
    // MARK: Mobile connect methods
    func checkMobileConnectResponseWithUserInfo(operatorData : DiscoveryResponse?) -> (controller : BaseWebController?, tokenModel : TokenModel?, error: NSError?) -> Void
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
    
    // MARK: Helpers
    func startDiscoveryInHandler(handler : () -> Void, presenter : UIViewController, withCompletition completionHandler : MobileConnectResponse?)
    {
        currentResponse = completionHandler
        
        if !isRunning {
            
            isRunning = true
            
            delegate?.mobileConnectWillStart?()
            
            currentPresenter = presenter
            
            handler()
        } else {
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
        
        currentResponse?(tokenResponseModel: model, error: error)
        
        currentResponse = nil
        currentPresenter = nil
    }
    
    func makeDiscoveryJson(options: DiscoveryOptions, links: OperatorIdModel) -> NSDictionary {
        
        let jsonobj: NSMutableDictionary = NSMutableDictionary()
        let response: NSMutableDictionary = NSMutableDictionary()
        let operatorId: NSMutableDictionary = NSMutableDictionary()
        let LinksArray: NSMutableArray = NSMutableArray()
        let apis: NSMutableDictionary = NSMutableDictionary()
        
        let authLink: String? = links.authenticationLink?.href ?? ""
        let authRel: String? = links.authenticationLink?.rel ?? ""
        let userInfoLink: String? = links.userinfolink?.href ?? ""
        let userInfoRel: String? = links.userinfolink?.rel ?? ""
        
        let tokenLink: String? = links.tokenlink?.href ?? ""
        let tokenRel: String? = links.tokenlink?.rel ?? ""
        
        let premiumInfoLink: String? = links.premiumInfoLink?.href ?? ""
        let premiumInfoRel: String? = links.premiumInfoLink?.rel ?? ""
        let jsonWebLink: String? = links.jsonwebtokenlink?.href ?? ""
        let jsonWebRel: String? = links.jsonwebtokenlink?.rel ?? ""
        
        let metadataLink: String? = links.metadatalink?.href ?? ""
        let metadataRel: String? = links.metadatalink?.rel ?? ""
        
        let linksDictionary: NSDictionary = [authRel!: authLink!,
                                             userInfoRel!: userInfoLink!,
                                             tokenRel!: tokenLink!,
                                             premiumInfoRel!: premiumInfoLink!,
                                             jsonWebRel!: jsonWebLink!,
                                             metadataRel!: metadataLink!]
        
        for (linkurl, linkrel) in linksDictionary
        {
            let link: NSMutableDictionary = NSMutableDictionary()
            link.setValue(linkurl, forKey: "href")
            link.setValue(linkrel, forKey: "rel")
            LinksArray.addObject(link)
        }
        
        let clientId = options.getClientConsumerKey()
        let clientSecret = options.getClientSecretKey()
        let clientName = options.getClientApplicationName()
        let subId = options.getSubscriberId()
        
        operatorId.setObject(LinksArray, forKey: "link")
        apis.setObject(operatorId, forKey: "operatorid")
        response.setObject(apis, forKey: "apis")
        response.setObject(clientId!, forKey: "client_id")
        response.setObject(clientSecret!, forKey: "client_secret")
        response.setObject(clientName!, forKey: "client_name")
        jsonobj.setValue(subId!, forKey: "subscriber_id")
        jsonobj.setValue(response, forKey: "response")
        
        return jsonobj
    }
    
    public func makeDiscoveryResponse(subscriberId: String, clientSecret: String, clientKey: String, name: String, linksRecieved: OperatorIdModel) -> DiscoveryResponse {
        
        let discoveryOptions: DiscoveryOptions = DiscoveryOptions()
        discoveryOptions.setSubscriberId(subscriberId)
        discoveryOptions.setClientSecretKey(clientSecret)
        discoveryOptions.setClientConsumerKey(clientKey)
        discoveryOptions.setClientApplicationName(name)
        
        let discoveryResponse: DiscoveryResponse = DiscoveryResponse()
        
        let operatorDataResponse: OperatorDataResponse = OperatorDataResponse()
        let apis: APISModel = APISModel()
        let json: NSDictionary = makeDiscoveryJson(discoveryOptions, links: linksRecieved)
        
        let operatorDictionaryValue: NSDictionary = (json.valueForKey("response") as? NSDictionary)!
        let apisDictionaryValue = operatorDictionaryValue.objectForKey("apis")
        let operatorIdLinks = apisDictionaryValue!.objectForKey("operatorid")
        let recievedLinks = operatorIdLinks!.objectForKey("link")
        
        operatorDataResponse.client_id = operatorDictionaryValue.valueForKey("client_id") as? String
        operatorDataResponse.client_secret = operatorDictionaryValue.valueForKey("client_secret") as? String
        
        apis.operatorid = linksRecieved
        
        operatorDataResponse.apis = apis
        operatorDataResponse.client_name = operatorDictionaryValue.valueForKey("client_name") as? String
        
        discoveryResponse.subscriber_id = json.valueForKey("subscriber_id") as? String
        discoveryResponse.response = operatorDataResponse
        
        return discoveryResponse
    }
}
