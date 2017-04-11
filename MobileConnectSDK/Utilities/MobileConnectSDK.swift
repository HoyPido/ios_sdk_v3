//
//  MobileConnectSDK.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 09/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

protocol MobileConnectSDKProtocol {
    // MARK: SDK setters
    static func setClientKey(_ clientKey : String)
    static func setClientSecret(_ clientSecret : String)
    static func setRedirect(_ redirectURL : URL)
    static func setApplicationEndpoint(_ applicationEndpoint : String)
}

///Is used for supplying the Mobile Connect services with needed credentials/resources (such as clientKey, clientSecret, applicationEndpoint redirectURL and the delegate responsible for catching Mobile Connect responses)
open class MobileConnectSDK: NSObject, MobileConnectSDKProtocol {
    fileprivate static var clientKey : String!
    fileprivate static var clientSecret : String!
    fileprivate static var applicationEndpoint : String! = "https://discovery.integration.sandbox.mobileconnect.io/v2/discovery"
    fileprivate static var redirectURL : URL!
    fileprivate static var xRedirect : String! = "APP"
    fileprivate static var delegate : MobileConnectManagerDelegate?
    
    // MARK: SDK setters
    ///Mobile connect xRedirect
    
    open static func setXRedirect(_ xRedirect : String)
    {
        MobileConnectSDK.xRedirect = xRedirect
    }
    
    open static func getXRedirect() -> String
    {
        return xRedirect
    }
    
    ///Mobile connect client key
    open static func setClientKey(_ clientKey : String)
    {
        NSException.checkClientKey(clientKey)
        MobileConnectSDK.clientKey = clientKey
    }
    
    static func getClientKey() -> String
    {
        //in case the client key is not set but is requested by some instance
        NSException.checkClientKey(clientKey)
        return clientKey
    }
    
    ///Mobile connect client secret
    open static func setClientSecret(_ clientSecret : String)
    {
        NSException.checkClientSecret(clientSecret)
        MobileConnectSDK.clientSecret = clientSecret
    }
    
    static func getClientSecret() -> String
    {
        NSException.checkClientSecret(clientSecret)
        return clientSecret
    }
    
    ///Mobile connect redirect url set in Mobile Connect dashboard
    open static func setRedirect(_ redirectURL : URL)
    {
        NSException.checkRedirect(redirectURL)
        MobileConnectSDK.redirectURL = redirectURL
    }
    
    static func getRedirectURL() -> URL
    {
        NSException.checkRedirect(redirectURL)
        return redirectURL
    }
    
    ///The url of you Mobile Connect application set in the Dashboard
    open static func setApplicationEndpoint(_ applicationEndpoint : String)
    {
        NSException.checkEndpoint(applicationEndpoint)
        self.applicationEndpoint = applicationEndpoint
    }
    
    static func getApplicationEndpoint() -> String
    {
        NSException.checkEndpoint(applicationEndpoint)
        return applicationEndpoint
    }
    
    ///The delegate which will catch all the publicly available MobileConnectManager events
    open static func setDelegate(_ delegate : MobileConnectManagerDelegate)
    {
        NSException.checkDelegate(delegate)
        self.delegate = delegate
    }
    
    static func getDelegate() -> MobileConnectManagerDelegate?
    {
        NSException.checkDelegate(delegate)
        return self.delegate
    }
}
