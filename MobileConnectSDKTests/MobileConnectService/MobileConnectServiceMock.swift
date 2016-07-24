//
//  MobileConnectServiceMock.swift
//  MobileConnectSDK
//
//  Created by jenkins on 27/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

@testable import MobileConnectSDK

//public class AuthorizationModel : MCModel {
//    
//    public var code: String?
//    public var state: String?
//}

class MobileConnectServiceMock: MobileConnectService {
    
    var error : NSError?
    var response : TokenModel?
    var codeResponse : [NSObject : AnyObject] = Mocker.authenticationCodeResponse
    var withDelay : Bool = false
    var shouldCallSuper : Bool = false
    
    var hasPresentedWebController : Bool = false
    var hasCalledRequestForToken : Bool = false
    
    var checksForNilWebController : Bool = false
    
    override func presentWebControllerWithRequest(request: NSURLRequest?, inController controller: UIViewController, errorHandler: (error: NSError) -> Void)
    {
        if checksForNilWebController
        {
            super.presentWebControllerWithRequest(request, inController: controller, errorHandler: errorHandler)
        }
        else
        {
            hasPresentedWebController = true
            
            treatWebRedirectParameters(codeResponse, withCompletionHandler: didReceiveResponseFromController)
        }
    }
    
    override func processRequest(request: Request, withParameters parameters: [(String?, MCErrorCode)], inHandler localHandler: (model: TokenModel?, error: NSError?) -> Void)
    {
        hasCalledRequestForToken = true
        
        localHandler(model: response, error: error)
    }
    
    override func getAuthenticationTokenInController(controller: UIViewController, completionHandler: MobileConnectControllerResponse) {
        
        if shouldCallSuper
        {
            super.getAuthenticationTokenInController(controller, completionHandler: completionHandler)
        }
        else
        {
            callHandlerWithDelay({
                completionHandler(controller: self.webController, tokenModel: self.response, error: self.error)
            })
        }
    }
    
    override func getAuthorizationTokenInController(controller: UIViewController, completionHandler: MobileConnectControllerResponse)
    {
        if shouldCallSuper
        {
            super.getAuthorizationTokenInController(controller, completionHandler: completionHandler)
        }
        else
        {
            callHandlerWithDelay({
                completionHandler(controller: self.webController, tokenModel: self.response, error: self.error)
            })
        }
    }
    
    //MARK: Helper testing functions
    func callHandlerWithDelay(handler : () -> Void)
    {
        if withDelay
        {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
            
            dispatch_async(queue, {
                
                let queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), queue2, {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        handler()
                    })
                })
            })
        }
        else
        {
            handler()
        }
    }
}