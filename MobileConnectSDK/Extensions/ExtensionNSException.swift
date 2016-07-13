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
    class func checkContext(context : String?, forProducts products : [String])
    {
        checkAuthorizationProperty(context, forProducts: products, withErrorName: Localizator.nilContext, andErrorMessage: Localizator.nilContextMessage)
    }
    
    class func checkClientName(clientName : String?, forProducts products : [String])
    {
        checkAuthorizationProperty(clientName, forProducts: products, withErrorName: Localizator.nilClientName, andErrorMessage: Localizator.nilClientNameMessage)
    }
    
    private class func checkAuthorizationProperty(property : String?, forProducts products : [String], withErrorName errorName : String, andErrorMessage errorMessage : String)
    {
        if products.map({ProductType(stringValue: $0)}).contains({$0 == ProductType.Authorization}) && property == .None
        {
            NSException(name: errorName, reason: errorMessage, userInfo: [NSLocalizedDescriptionKey : errorMessage]).raise()
        }
    }
    
    class func checkController(controller : UIViewController?)
    {
        if controller == .None
        {
            NSException(name: Localizator.nilPresenterName, reason:Localizator.nilPresenterMessage , userInfo: [NSLocalizedDescriptionKey : Localizator.nilPresenterMessage]).raise()
        }
    }
    
    class func checkDelegate(delegate : Any?)
    {
        if let delegate = delegate
        {
            if !(delegate is MobileConnectManagerDelegate)
            {
                NSException(name: Localizator.incorrectDelegateName, reason: Localizator.incorrectDelegateMessage, userInfo: [NSLocalizedDescriptionKey : Localizator.incorrectDelegateMessage]).raise()
            }
        }
    }
    
    class func checkRedirect(redirect : NSURL?)
    {
        checkParameters([redirect], withErrorMessage: Localizator.nilRedirectMessage, exceptionName: Localizator.nilRedirectName)
    }
    
    class func checkEndpoint(endpoint : String?)
    {
        checkParameters([endpoint], withErrorMessage: Localizator.nilApplicationEndpointMessage, exceptionName: Localizator.nilApplicationEndpointName)
    }
    
    class func checkClientKey(clientKey : String?)
    {
        checkParameters([clientKey], withErrorMessage: Localizator.nilClientKeyMessage, exceptionName: Localizator.nilClientKeyName)
    }
    
    class func checkClientSecret(clientSecret : String?)
    {
        checkParameters([clientSecret], withErrorMessage: Localizator.nilClientSecretMessage, exceptionName: Localizator.nilClientKeyName)
    }
    
    class func checkParameters(parameters : [AnyObject?], withErrorMessage message : String, exceptionName : String)
    {
        guard !(parameters.filter({$0 == nil}).count > 0) else
        {
            NSException(name: exceptionName, reason: message, userInfo: [NSLocalizedDescriptionKey : message]).raise()
            
            return
        }
    }
}