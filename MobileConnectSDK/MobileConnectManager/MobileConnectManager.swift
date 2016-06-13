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
    
     func mobileConnectWillStart()
     func mobileConnectWillPresentWebController()
     func mobileConnectWillDismissWebController()
     func mobileConnectDidGetTokenResponse(tokenResponse : TokenResponseModel)
     func mobileConnectFailedGettingTokenResponseWithError(error : NSError)
}

protocol MobileConnectManagerProtocol
{
    //MARK: iVars
    var delegate : MobileConnectManagerDelegate? {get set}
    
    //MARK: Main actions
    func getTokenInPresenterController(presenterController : UIViewController, withCompletitionHandler completitionHandler : MobileConnectResponse?)
    
    func getTokenForPhoneNumber(phoneNumber : String, inPresenterController controller : UIViewController, withCompletitionHandler completitionHandler : MobileConnectResponse?)
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
    
    lazy var discovery : DiscoveryService = DiscoveryService()
    var currentResponse : MobileConnectResponse?
    var currentPresenter : UIViewController?
    
    var isRunning : Bool = false
    
    //private var discoveryService : DiscoveryService
    
    //MARK: init
    public convenience override init() {
        self.init(delegate: MobileConnectSDK.getDelegate())
    }
    
    private init(delegate : MobileConnectManagerDelegate? = nil) {
        NSException.checkDelegate(delegate)
        
        self.delegate = delegate
        super.init()
    }
    
    //MARK: SDK main methods
    /**
    Will get the token without any info needed from the client. Will use both Discovery and Mobile Connect services underneath. First the Discovery web controller will be presented which will require client's phone number or operator information. Afterwards the Mobile Connect Service will present its web view controller. In case the client did not provide a phone number, Mobile Connect will first ask the client for a phone number and then present the waiting for sms confirmation screen.
        - Parameter presenterController: The controller which will present the Mobile Connect web view controller
        - Parameter completitionHandler: The closure in which the Mobile Connect Token or error will be returned
    */
    public func getTokenInPresenterController(presenterController: UIViewController, withCompletitionHandler completitionHandler : MobileConnectResponse?)
    {
        startDiscoveryInHandler({ 
            
            self.delegate?.mobileConnectWillPresentWebController()
            self.discovery.startOperatorDiscoveryInController(presenterController, completitionHandler: self.checkDiscoveryResponse)
            
        },presenter: presenterController, withCompletition: completitionHandler)
    }
    
    /**
     Will get the token with client's phone number. By providing the number the only web view presented will be that of the sms confirmation. Will use both Discovery and Mobile Connect services underneath.
     - Parameter presenterController: The controller which will present the Mobile Connect web view controller
     - Parameter completitionHandler: The closure in which the Mobile Connect Token or error will be returned
     */
    public func getTokenForPhoneNumber(phoneNumber: String, inPresenterController controller : UIViewController, withCompletitionHandler completitionHandler : MobileConnectResponse?) {
        
        startDiscoveryInHandler({
            
            self.discovery.startOperatorDiscoveryForPhoneNumber(phoneNumber, completitionHandler: { (operatorsData, error) in
                
                self.checkDiscoveryResponse(nil, operatorsData: operatorsData, error: error)
            })
            
        }, presenter: controller, withCompletition: completitionHandler)
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
            delegate?.mobileConnectWillDismissWebController()
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let mobileConnect : MobileConnectService = MobileConnectService(clientId: operatorsData.response?.client_id ?? "", authorizationURL: operatorsData.response?.apis?.operatorid?.authorizationLink() ?? "", tokenURL: operatorsData.response?.apis?.operatorid?.tokenLink() ?? "")
        
        if let presenter = currentPresenter
        {
            delegate?.mobileConnectWillPresentWebController()
            mobileConnect.getTokenInController(presenter, subscriberId: operatorsData.subscriber_id, completitionHandler: checkMobileConnectResponse)
        }
        else
        {
            finishWithResponse(controller, model: nil, error: MCErrorCode.Unknown.error)
        }
    }
    
    //MARK: Mobile connect methods
    func checkMobileConnectResponse(controller : BaseWebController?, tokenModel : TokenModel?, error: NSError?)
    {
        finishWithResponse(controller, model: TokenResponseModel(tokenModel: tokenModel), error: error)
    }
    
    //MARK: Helpers
    func startDiscoveryInHandler(handler : () -> Void, presenter : UIViewController, withCompletition completitionHandler : MobileConnectResponse?)
    {
        if !isRunning
        {
            isRunning = true
            
            delegate?.mobileConnectWillStart()
            
            currentResponse = completitionHandler
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
            delegate?.mobileConnectFailedGettingTokenResponseWithError(error)
        }
        
        if let model = model
        {
            delegate?.mobileConnectDidGetTokenResponse(model)
        }
        
        delegate?.mobileConnectWillDismissWebController()
        controller?.dismissViewControllerAnimated(true, completion: nil)
        
        currentResponse?( tokenResponseModel: model, error: error)
        
        currentResponse = nil
        currentPresenter = nil
    }
}
