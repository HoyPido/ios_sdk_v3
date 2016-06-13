//
//  MobileConnectSDK.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 09/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

protocol MobileConnectSDKProtocol {
    //MARK: SDK setters
    static func setClientKey(clientKey : String)
    static func setClientSecret(clientSecret : String)
    static func setRedirect(redirectURL : NSURL)
    static func setApplicationEndpoint(applicationEndpoint : String)
}

///Is used for supplying the Mobile Connect services with needed credentials/resources (such as clientKey, clientSecret, applicationEndpoint redirectURL and the delegate responsible for catching Mobile Connect responses)
public class MobileConnectSDK: NSObject, MobileConnectSDKProtocol {
    private static var clientKey : String!
    private static var clientSecret : String!
    private static var applicationEndpoint : String!
    private static var redirectURL : NSURL!
    private static var delegate : MobileConnectManagerDelegate?
    
    //MARK: SDK setters
    ///Mobile connect client key
    public static func setClientKey(clientKey : String)
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
    public static func setClientSecret(clientSecret : String)
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
    public static func setRedirect(redirectURL : NSURL)
    {
        NSException.checkRedirect(redirectURL)
        MobileConnectSDK.redirectURL = redirectURL
    }
    
    static func getRedirectURL() -> NSURL
    {
        NSException.checkRedirect(redirectURL)
        return redirectURL
    }
    
    ///The url of you Mobile Connect application set in the Dashboard
    public static func setApplicationEndpoint(applicationEndpoint : String)
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
    public static func setDelegate(delegate : MobileConnectManagerDelegate)
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
