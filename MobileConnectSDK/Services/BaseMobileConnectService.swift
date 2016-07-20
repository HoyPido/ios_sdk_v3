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
class BaseMobileConnectService<ResponseModel : MCModel, RedirectModel : MCModel>: NSObject, WebControllerDelegate {
    
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
    
    //MARK: Web controller delegate
    func webControllerDidCancel(controller : BaseWebController)
    {
        isAwaitingResponse = false
        controllerResponse?(controller: webController, model : nil, error: MCErrorCode.UserCancelled.error)
    }
    
    func webController(controller : BaseWebController, shouldRedirectToURL url : NSURL) -> Bool
    {
        print("----------------------------------------- should redirect to url ")
        print("\(url)")
        
        return !isValidRedirectURL(url, inController: controller)
    }
    
    func webController(controller : BaseWebController, failedLoadingRequestWithError error : NSError?)
    {
        isAwaitingResponse = false
        controllerResponse?(controller : nil, model: nil, error: error)
    }
    
    //to be inherited by underlying services
    var redirectURL : NSURL
    {
        let reason : String = "The subclasses should override redirectURL var"
        
        NSException(name: "NoWebControllerRedirectURLProvided", reason: reason, userInfo: [NSLocalizedDescriptionKey : reason]).raise()
        
        return NSURL()
    }
    
    func didReceiveResponseFromController(webController : BaseWebController?, withRedirectModel redirectModel : RedirectModel?, error : NSError?)
    {
        
    }
    
    //MARK: Web view additional methods
    func presentWebControllerWithRequest(request : NSURLRequest?, inController controller : UIViewController, errorHandler : (error : NSError) -> Void)
    {        
        guard let webController = webController else
        {
            errorHandler(error: MCErrorCode.WebControllerNil.error)
            
            return
        }
        
        guard let request = request else
        {
            errorHandler(error: MCErrorCode.NoRequestToLoad.error)
            
            return
        }
        
        webController.requestToLoad = request
        
        controller.presentViewController(webController, animated: true, completion: nil)
    }
    
    //MARK: Web view helpers
    func isValidRedirectURL(url : NSURL, inController controller : BaseWebController) -> Bool
    {
        var isTheSameHost : Bool = false
        
        if let urlHost = url.host, redirectHost = redirectURL.host
        {
            isTheSameHost = urlHost == redirectHost
        }
        
        let parameters : [NSObject : AnyObject] = keyValuesFromString(url.query)
        
        if isTheSameHost && parameters.count > 0 {
            isAwaitingResponse = false
            
            didReceiveResponseWithParameters(parameters, fromController: controller)
            
            return true
        }
        
        return false
    }
    
    func didReceiveResponseWithParameters(parameters : [NSObject : AnyObject], fromController controller : BaseWebController)
    {
        isAwaitingResponse = false
        
        treatWebRedirectParameters(parameters, withCompletionHandler: didReceiveResponseFromController)
    }
    
    func treatWebRedirectParameters(parameters : [NSObject : AnyObject], withCompletionHandler completionHandler : (controller : BaseWebController?, model : RedirectModel?, error : NSError?) -> Void)
    {
        deserializeModel(parameters) { (model : RedirectModel?, error : NSError?) in
            guard let model = model else
            {
                self.controllerResponse?(controller: self.webController, model: nil, error : error)
                return
            }
            
            completionHandler( controller: self.webController, model: model, error: nil)
        }
    }
    
    //MARK: Deserialization methods
    func deserializeModel<T : MCModel>(modelDictionary : AnyObject?, completionHandler : (model : T? , error : NSError?) -> Void)
    {
        guard let dictionary = modelDictionary as? [NSObject : AnyObject] else
        {
            completionHandler(model: nil, error: MCErrorCode.SerializationError.error)
            return
        }
        
        //if server responds with error, create an NSError instance and send in compl handler
        if dictionary.keys.contains({$0 == "error"}) {
            
            let errorDescription : String = (dictionary["error_description"] as? String) ?? (dictionary["description"] as? String) ?? ""
            
            completionHandler(model: nil, error: NSError(domain: kMobileConnectErrorDomain, code: MCErrorCode.ServerResponse.rawValue, userInfo: [NSLocalizedDescriptionKey : errorDescription]))
            return
        }
        
        var model : T?
        
        do
        {
            model = try T(dictionary: dictionary)
        }
        catch
        {
            completionHandler(model: nil, error: MCErrorCode.SerializationError.error)
        }
        
        completionHandler(model: model, error: nil)
    }
    
    func keyValuesFromString(string : String?) -> [NSObject : AnyObject]
    {
        var keyValueDictionary : [NSObject : AnyObject] = [:]
        
        if let string = string
        {
            let components : [[String]] = string.componentsSeparatedByString("&").map({$0.componentsSeparatedByString("=")})
            
            components.forEach { (component : [String]) in
                
                if let first = component.first, last = component.last
                {
                    keyValueDictionary[first] = last
                }
            }
        }
        
        return keyValueDictionary
    }
    
    //MARK: Pre-request stage
    func startServiceInController(controller : UIViewController, withRequest request : Request, completionHandler : (controller : BaseWebController?, model : ResponseModel?, error : NSError?) -> Void)
    {
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
    
    func startInHandler(handler : () -> Void, withParameters parameters : [(String?, MCErrorCode)], completionHandler: (error : NSError) -> Void)
    {
        guard parametersAreValid(parameters, completionHandler: completionHandler) else
        {
            return
        }
        
        if canStartRequesting
        {
            handler()
        }
        else
        {
            completionHandler(error: MCErrorCode.Concurrency.error)
        }
    }
    
    //MARK: Generic request treatment method
    func processRequest(request : Request, withParameters parameters : [(String?, MCErrorCode)], inHandler localHandler : (model : ResponseModel?, error : NSError?) -> Void)
    {
        processSpecificRequest(request, withParameters: parameters, inHandler: localHandler)
    }
    
    func processSpecificRequest<T : MCModel>(request : Request, withParameters parameters : [(String?, MCErrorCode)], inHandler localHandler : (model : T?, error : NSError?) -> Void)
    {
        startInHandler({
            
            self.callRequest(request, forCompletionHandler: localHandler)
            
        }, withParameters: parameters) { (error) in
            localHandler(model : nil, error: error)
        }
    }
    
    func callRequest<T : MCModel>(request : Request, forCompletionHandler completionHandler : (model : T?, error : NSError?) -> Void)
    {        
        request.responseJSON { (response : Response<AnyObject, NSError>) in
            
            self.treatResponseCompletionHandler(response, withClientResponseHandler: completionHandler)
        }
    }
    
    func treatResponseCompletionHandler<T : MCModel>(response : Response<AnyObject, NSError>, withClientResponseHandler clientResponseHandler : (model : T?, error : NSError?) -> Void)
    {
        self.isAwaitingResponse = false
        
        if response.result.isSuccess
        {
            self.deserializeModel(response.result.value, completionHandler: clientResponseHandler)
        }
        else
        {
            print(response.request?.allHTTPHeaderFields)
            
            print(response.result.error)
            print(response.request?.URL)
            
            clientResponseHandler(model: nil, error: response.result.error)
        }
    }
    
    //MARK: Checks
    var canStartRequesting : Bool
    {
        let localCanStartRequesting : Bool = !isAwaitingResponse
        
        isAwaitingResponse = true
        
        return localCanStartRequesting
    }
    
    func parametersAreValid(parameters : [(String?, MCErrorCode)], completionHandler : (error : NSError) -> Void) -> Bool
    {
        if let firstError = parameters.filter({$0.0 == .None || ($0.0?.characters.count ?? 0) == 0}).map({$0.1}).first
        {
            completionHandler(error: firstError.error)
            
            return false
        }
        
        return true
    }
}
