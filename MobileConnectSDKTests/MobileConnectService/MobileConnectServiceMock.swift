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
    var shouldCallSuper : Bool = false
    
    var checksForNilWebController : Bool = false
    
    override func presentWebControllerWithRequest(request: NSURLRequest?, inController controller: UIViewController, errorHandler: (error: NSError) -> Void)
    {
        if checksForNilWebController
        {
            super.presentWebControllerWithRequest(request, inController: controller, errorHandler: errorHandler)
        }
        else
        {
            treatWebRedirectParameters(codeResponse, withCompletionHandler: didReceiveResponseFromController)
        }
    }
    
    override func processRequest(request: Request, withParameters parameters: [(String?, MCErrorCode)], inHandler localHandler: (model: TokenModel?, error: NSError?) -> Void)
    {
        localHandler(model: response, error: error)
    }
    
    override func getAuthenticationTokenInController(controller: UIViewController, completionHandler: MobileConnectControllerResponse) {
        
        if shouldCallSuper
        {
            super.getAuthenticationTokenInController(controller, completionHandler: completionHandler)
        }
        else
        {
            completionHandler(controller: self.webController, tokenModel: self.response, error: self.error)
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
            completionHandler(controller: self.webController, tokenModel: self.response, error: self.error)
        }
    }
}