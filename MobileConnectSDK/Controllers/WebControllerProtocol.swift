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
    static func controllerWithDelegate(delegate : WebControllerDelegate?, requestToLoad : NSURLRequest?) -> BaseWebController?
    static var existingTemplate : BaseWebController? {get}
    
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
  
    static var existingTemplate : BaseWebController?
    {
        return UIStoryboard(name: storyboardName, bundle: Resources.bundle).instantiateViewControllerWithIdentifier(controllerIdentifier) as? BaseWebController
    }
    
    static func controllerWithDelegate(delegate : WebControllerDelegate?, requestToLoad : NSURLRequest? = nil) -> BaseWebController?
    {
        guard let controller = existingTemplate else
        {
            return nil
        }
        
        controller.delegate = delegate
        controller.requestToLoad = requestToLoad
        
        return controller
    }
}