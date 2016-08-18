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
    
    //MARK: iVars
    var isAwaitingResponse : Bool = false
    
    var controllerResponse : ((controller : BaseWebController?, model : ResponseModel?, error : NSError?) -> Void)?
    
    var webController : BaseWebController?
    
    var isFirstResponse : Bool = true
    
    //MARK: init
    required init(webController : BaseWebController? = WebController.existingTemplate) {
        
        self.webController = webController
        
        super.init()
        
        self.webController?.delegate = self
    }
  
    //to be inherited by underlying services
    var redirectURL : NSURL {
        let reason : String = "The subclasses should override redirectURL var"
        
        NSException(name: "NoWebControllerRedirectURLProvided", reason: reason, userInfo: [NSLocalizedDescriptionKey : reason]).raise()
        
        return NSURL()
    }
    
    func didReceiveResponseFromController(webController : BaseWebController?, withRedirectModel redirectModel : RedirectModel?, error : NSError?) {
        
    }
    
    //MARK: Web view additional methods
    func presentWebControllerWithRequest(request : NSURLRequest?, inController controller : UIViewController, errorHandler : (error : NSError) -> Void) {
        guard let webController = webController else {
            errorHandler(error: MCErrorCode.WebControllerNil.error)
            return
        }
        
        guard let request = request else {
            errorHandler(error: MCErrorCode.NoRequestToLoad.error)
            return
        }
        
        webController.requestToLoad = request
        
        controller.presentViewController(webController, animated: true, completion: nil)
    }
  
    //MARK: Pre-request stage
    func startServiceInController(controller : UIViewController, withRequest request : Request, completionHandler : (controller : BaseWebController?, model : ResponseModel?, error : NSError?) -> Void) {
        //start in handler basically checks for concurrency error in this case, but with reusing the same logic as for other requests
        startInHandler({
            
            //saving completition block for later when the server response comes
            self.controllerResponse = completionHandler
            
            self.presentWebControllerWithRequest(request.request, inController: controller, errorHandler: { (error) in
                self.isAwaitingResponse = false
                self.controllerResponse?(controller: self.webController, model: nil, error: error)
            })
            
        }, withParameters: []) { (error) in
            completionHandler(controller: nil, model: nil, error: error)
        }
    }
    
    func startInHandler(handler : () -> Void, withParameters parameters : [(String?, MCErrorCode)], completionHandler: (error : NSError) -> Void) {
        guard parametersAreValid(parameters, completionHandler: completionHandler) else {
            return
        }
        
        if canStartRequesting {
            handler()
        }
        else {
            completionHandler(error: MCErrorCode.Concurrency.error)
        }
    }
    
    //MARK: Generic request treatment method
    func processRequest(request : Request, withParameters parameters : [(String?, MCErrorCode)], inHandler localHandler : (model : ResponseModel?, error : NSError?) -> Void) {
        processSpecificRequest(request, withParameters: parameters, inHandler: localHandler)
    }
    
    func processSpecificRequest<T : MCModel>(request : Request, withParameters parameters : [(String?, MCErrorCode)], inHandler localHandler : (model : T?, error : NSError?) -> Void) {
        startInHandler({
            
          BaseMobileConnectServiceRequest.callRequest(request, forCompletionHandler: { (model : T?, error : NSError?) in
            self.isAwaitingResponse = false
            localHandler(model: model, error: error)
          })
          
        }, withParameters: parameters) { (error) in
            localHandler(model : nil, error: error)
        }
    }
  
    //MARK: Checks
    var canStartRequesting : Bool {
        let localCanStartRequesting : Bool = !isAwaitingResponse
        
        isAwaitingResponse = true
        
        return localCanStartRequesting
    }
    
    func parametersAreValid(parameters : [(String?, MCErrorCode)], completionHandler : (error : NSError) -> Void) -> Bool {
        if let firstError = parameters.filter({$0.0 == .None || ($0.0?.characters.count ?? 0) == 0}).map({$0.1}).first {
            completionHandler(error: firstError.error)
            
            return false
        }
        
        return true
    }
}
