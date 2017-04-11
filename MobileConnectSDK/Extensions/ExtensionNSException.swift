//
//  ExtensionNSException.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

extension NSException
{
    class func checkContext(_ context : String?)
    {
        checkParameters([context as AnyObject], withErrorMessage: Localizator.nilContext, exceptionName: Localizator.nilContextMessage)
    }
    
    class func checkClientName(_ clientName : String?)
    {
        checkParameters([clientName as AnyObject], withErrorMessage: Localizator.nilContext, exceptionName: Localizator.nilContextMessage)
    }
    
    class func checkAuthorizationProperty(_ property : String?, withErrorName errorName : String, andErrorMessage errorMessage : String)
    {
        if property == .none
        {
            NSException(name: NSExceptionName(rawValue: errorName), reason: errorMessage, userInfo: [NSLocalizedDescriptionKey : errorMessage]).raise()
        }
    }
    
    class func checkController(_ controller : UIViewController?)
    {
        if controller == .none
        {
            NSException(name: NSExceptionName(rawValue: Localizator.nilPresenterName), reason:Localizator.nilPresenterMessage, userInfo: [NSLocalizedDescriptionKey : Localizator.nilPresenterMessage]).raise()
        }
    }
    
    class func checkDelegate(_ delegate : Any?)
    {
        if let delegate = delegate
        {
            if !(delegate is MobileConnectManagerDelegate)
            {
                NSException(name: NSExceptionName(rawValue: Localizator.incorrectDelegateName), reason: Localizator.incorrectDelegateMessage, userInfo: [NSLocalizedDescriptionKey : Localizator.incorrectDelegateMessage]).raise()
            }
        }
    }
    
    class func checkRedirect(_ redirect : URL?)
    {
        checkParameters([redirect as AnyObject], withErrorMessage: Localizator.nilRedirectMessage, exceptionName: Localizator.nilRedirectName)
    }
    
    class func checkEndpoint(_ endpoint : String?)
    {
        checkParameters([endpoint as AnyObject], withErrorMessage: Localizator.nilApplicationEndpointMessage, exceptionName: Localizator.nilApplicationEndpointName)
    }
    
    class func checkClientKey(_ clientKey : String?)
    {
        checkParameters([clientKey as AnyObject], withErrorMessage: Localizator.nilClientKeyMessage, exceptionName: Localizator.nilClientKeyName)
    }
    
    class func checkClientSecret(_ clientSecret : String?)
    {
        checkParameters([clientSecret as AnyObject], withErrorMessage: Localizator.nilClientSecretMessage, exceptionName: Localizator.nilClientKeyName)
    }
    
    class func checkParameters(_ parameters : [AnyObject?], withErrorMessage message : String, exceptionName : String)
    {
        guard !(parameters.filter({$0 == nil}).count > 0) else
        {
            NSException(name: NSExceptionName(rawValue: exceptionName), reason: message, userInfo: [NSLocalizedDescriptionKey : message]).raise()
            
            return
        }
    }
}
