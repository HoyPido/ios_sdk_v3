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

protocol MobileConnectManagerProtocol
{
    //MARK: iVars
    var delegate : MobileConnectManagerDelegate? {get set}
    
    //MARK: Main actions
    func getTokenInPresenterController(presenterController : UIViewController, withCompletionHandler completionHandler : MobileConnectResponse?)
    
    func getTokenForPhoneNumber(phoneNumber : String, inPresenterController controller : UIViewController, withCompletionHandler completionHandler : MobileConnectResponse?)
}

/**
    Abstracts the Discovery and Mobile Connect services by offering 2 convenience methods for directly getting the token. The token will be delivered in the supplied callbacks or delegate methods if set.
*/
    public class MobileConnectManager: NSObject, MobileConnectManagerProtocol {

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
    init(delegate : MobileConnectManagerDelegate? , discoveryService : DiscoveryService ) {
        NSException.checkDelegate(delegate)
        
        self.delegate = delegate
        discovery = discoveryService
        
        super.init()
    }
      
    public override convenience init() {

      self.init(delegate: MobileConnectSDK.getDelegate(), discoveryService: DiscoveryService())
    }
    
    //MARK: SDK main methods
    /**
    Will get the token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
        - Parameter presenterController: The controller which will present the Mobile Connect web view controller
        - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
    */
    public func getTokenInPresenterController(presenterController: UIViewController, withCompletionHandler completionHandler : MobileConnectResponse?)
    {
        startDiscoveryInHandler({ 
            
            self.delegate?.mobileConnectWillPresentWebController?()
            self.discovery.startOperatorDiscoveryInController(presenterController, completionHandler: self.checkDiscoveryResponse)
            
        },presenter: presenterController, withCompletion: completionHandler)
    }
    
    /**
     Will get the token with client's phone number. By providing the number the only web view presented will be that of the sms confirmation. Will use both Discovery and Mobile Connect services underneath.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    public func getTokenForPhoneNumber(phoneNumber: String, inPresenterController controller : UIViewController, withCompletionHandler completionHandler : MobileConnectResponse?) {
        
        startDiscoveryInHandler({
            
            self.discovery.startOperatorDiscoveryForPhoneNumber(phoneNumber, completionHandler: { (operatorsData, error) in
                
                self.checkDiscoveryResponse(nil, operatorsData: operatorsData, error: error)
            })
            
        }, presenter: controller, withCompletion: completionHandler)
    }
    
    
    
    //MARK: Discovery methods
    func checkDiscoveryResponse(controller : BaseWebController?, operatorsData : DiscoveryResponse?, error : NSError?)
    {
        guard let operatorsData = operatorsData else
        {
            finishWithResponse(controller, model: nil, error: error ?? MCErrorCode.Unknown.error)
            
            return
        }
        
        if let controller = controller
        {
            delegate?.mobileConnectWillDismissWebController?()
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let mobileConnect : MobileConnectService = MobileConnectService(clientId: operatorsData.response?.client_id ?? "", authorizationURL: operatorsData.response?.apis?.operatorid?.authorizationLink() ?? "", tokenURL: operatorsData.response?.apis?.operatorid?.tokenLink() ?? "")
        
        getTokenWithMobileConnectService(mobileConnect, inWebController: controller, withOperatorsData: operatorsData)
    }
    
    func getTokenWithMobileConnectService(mobileConnectService : MobileConnectService, inWebController webController : BaseWebController?, withOperatorsData operatorsData : DiscoveryResponse)
    {
        if let presenter = currentPresenter
        {
            delegate?.mobileConnectWillPresentWebController?()
            mobileConnectService.getTokenInController(presenter, subscriberId: operatorsData.subscriber_id, completionHandler: checkMobileConnectResponse)
        }
        else
        {
            finishWithResponse(webController, model: nil, error: MCErrorCode.Unknown.error)
        }
    }
    
    //MARK: Mobile connect methods
    func checkMobileConnectResponse(controller : BaseWebController?, tokenModel : TokenModel?, error: NSError?)
    {
        finishWithResponse(controller, model: TokenResponseModel(tokenModel: tokenModel), error: error)
    }
    
    //MARK: Helpers
    func startDiscoveryInHandler(handler : () -> Void, presenter : UIViewController, withCompletion completionHandler : MobileConnectResponse?)
    {
        if !isRunning
        {
            isRunning = true
            
            delegate?.mobileConnectWillStart?()
            
            currentResponse = completionHandler
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
