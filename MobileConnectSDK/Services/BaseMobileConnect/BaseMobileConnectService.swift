//
//  BaseMobileConnectService.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 09/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

///Parent class of Mobile Connect and Discovery service. Deals with web view delegate methods, deserialization tasks and redirects.
class BaseMobileConnectService<ResponseModel : MCModel, RedirectModel : MCModel>: NSObject {
    
    // MARK: iVars
    var isAwaitingResponse : Bool = false
    
    var controllerResponse : ((_ controller : BaseWebController?, _ model : ResponseModel?, _ error : NSError?) -> Void)?
    
    var webController : BaseWebController?
    
    var isFirstResponse : Bool = true
    
    // MARK: init
    required init(webController : BaseWebController? = WebController.existingTemplate) {
        
        self.webController = webController
        
        super.init()
        
        self.webController?.delegate = self
    }
  
    //to be inherited by underlying services
    var redirectURL : URL {
        let reason : String = "The subclasses should override redirectURL var"
        
        NSException(name: NSExceptionName(rawValue: "NoWebControllerRedirectURLProvided"), reason: reason, userInfo: [NSLocalizedDescriptionKey : reason]).raise()
        
        return redirectURL
    }
    
    func didReceiveResponseFromController(_ webController : BaseWebController?, withRedirectModel redirectModel : RedirectModel?, error : NSError?) {
        
    }
    
    // MARK: Web view additional methods
    func presentWebControllerWithRequest(_ request : URLRequest?, inController controller : UIViewController, errorHandler : (_ error : NSError) -> Void) {
        guard let webController = webController else {
            errorHandler(MCErrorCode.webControllerNil.error)
            return
        }
        
        guard let request = request else {
            errorHandler(MCErrorCode.noRequestToLoad.error)
            return
        }
        webController.requestToLoad = request
        
        controller.present(webController, animated: true, completion: nil)
    }
  
    func presentWebControllerWithoutRequest(inController controller : UIViewController, errorHandler : (_ error : NSError) -> Void) {
        guard let webController = webController else {
            errorHandler(MCErrorCode.webControllerNil.error)
            return
        }

        controller.present(webController, animated: true, completion: nil)
    }
    
    // MARK: Pre-request stage
    func startServiceInController(_ controller : UIViewController, withRequest request : Request, completionHandler : @escaping (_ controller : BaseWebController?, _ model : ResponseModel?, _ error : NSError?) -> Void) {
        //start in handler basically checks for concurrency error in this case, but with reusing the same logic as for other requests
        startInHandler({
            
            //saving completition block for later when the server response comes
            self.controllerResponse = completionHandler
            self.presentWebControllerWithRequest(request.request, inController: controller, errorHandler: { (error) in
                self.isAwaitingResponse = false
                self.controllerResponse?(self.webController, nil, error)
            })
            
        }, withParameters: []) { (error) in
            completionHandler(nil, nil, error)
        }
    }
    
    // MARK: Pre-request stage
    func startServiceInControllerWithoutCall(_ controller : UIViewController, withRequest request : Request, completionHandler : @escaping (_ controller : BaseWebController?, _ model : ResponseModel?, _ error : NSError?) -> Void) {
        //start in handler basically checks for concurrency error in this case, but with reusing the same logic as for other requests
        startInHandler({
            
            //saving completition block for later when the server response comes
            self.controllerResponse = completionHandler
            
            self.controllerResponse?(self.webController, nil, nil)

            self.presentWebControllerWithoutRequest(inController: controller, errorHandler: { (error) in
                self.isAwaitingResponse = false
                self.controllerResponse?(self.webController, nil, error)
            })
            
        }, withParameters: []) { (error) in
            completionHandler(nil, nil, error)
        }
    }
    
    func startInHandler(_ handler : () -> Void, withParameters parameters : [(String?, MCErrorCode)], completionHandler: (_ error : NSError) -> Void) {
        guard parametersAreValid(parameters, completionHandler: completionHandler) else {
            return
        }
        
        if canStartRequesting {
            handler()
        } else {
            completionHandler(MCErrorCode.concurrency.error)
        }
    }
    
    // MARK: Generic request treatment method
    func processRequest(_ request : Request, withParameters parameters : [(String?, MCErrorCode)], inHandler localHandler : @escaping (_ model : ResponseModel?, _ error : NSError?) -> Void) {
        processSpecificRequest(request, withParameters: parameters, inHandler: localHandler)
    }
    
    func processSpecificRequest<T : MCModel>(_ request : Request, withParameters parameters : [(String?, MCErrorCode)], inHandler localHandler : @escaping (_ model : T?, _ error : NSError?) -> Void) {
        startInHandler({
            BaseMobileConnectServiceRequest().callRequest(request: request as! DataRequest, forCompletionHandler: { (model : T?, error : NSError?) in
                self.isAwaitingResponse = false
                localHandler(model, error)
            })
            
        }, withParameters: parameters) { (error) in
            localHandler(nil, error)
        }
    }
  
    func processSpecificRequestWithoutDiscoveryCall<T : MCModel>(_ request : Request, withParameters parameters : [(String?, MCErrorCode)], inHandler localHandler : @escaping (_ model : T?, _ error : NSError?) -> Void) {
        BaseMobileConnectServiceRequest().callRequest(request: request as! DataRequest, forCompletionHandler: { (model : T?, error : NSError?) in
                self.isAwaitingResponse = false
            
                localHandler(model, error)
            })
    }
    // MARK: Checks
    var canStartRequesting : Bool {
        let localCanStartRequesting : Bool = !isAwaitingResponse
        
        isAwaitingResponse = true
        
        return localCanStartRequesting
    }
    
    func parametersAreValid(_ parameters : [(String?, MCErrorCode)], completionHandler : (_ error : NSError) -> Void) -> Bool {
        if let firstError = parameters.filter({$0.0 == .none || ($0.0?.characters.count ?? 0) == 0}).map({$0.1}).first {
            completionHandler(firstError.error)
            
            return false
        }
        
        return true
    }
}
