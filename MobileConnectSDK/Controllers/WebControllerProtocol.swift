//
//  WebControllerProtocol.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 06/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import WebKit

private let kWebControllerStoryboardName : String = "WebController"
private let kWebControllerIdentifier : String = "WebController"

protocol WebControllerProtocol : UIToolbarDelegate, WKNavigationDelegate
{
    //MARK: iVars
    var delegate : WebControllerDelegate? {get set}
    var requestToLoad : NSURLRequest? {get set}
    
    //MARK: Factory methods
    static func controllerWithDelegate(delegate : WebControllerDelegate?) -> BaseWebController?
    static func controllerWithDelegate(delegate : WebControllerDelegate?, requestToLoad : NSURLRequest?) -> BaseWebController?
    
    //MARK: Storyboard creation datasource
    static var controllerIdentifier : String {get}
    static var storyboardName : String {get}
}

extension WebControllerProtocol
{
    static var controllerIdentifier : String
    {
        return kWebControllerIdentifier
    }
    
    static var storyboardName : String
    {
        return kWebControllerStoryboardName
    }
    
    static func controllerWithDelegate(delegate : WebControllerDelegate?) -> BaseWebController?
    {
        return controllerWithDelegate(delegate, requestToLoad: nil)
    }
    
    static func controllerWithDelegate(delegate : WebControllerDelegate?, requestToLoad : NSURLRequest?) -> BaseWebController?
    {
        guard let controller = UIStoryboard(name: storyboardName, bundle: Resources.bundle).instantiateViewControllerWithIdentifier(controllerIdentifier) as? BaseWebController else
        {
            return nil
        }
        
        controller.delegate = delegate
        controller.requestToLoad = requestToLoad
        
        return controller
    }
}