//
//  BaseServiceConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 11/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

public class BaseServiceConfiguration: NSObject {
    
    let clientKey : String
    let clientSecret : String
    let redirectURL : NSURL
    
    init(clientKey : String = MobileConnectSDK.getClientKey(), clientSecret : String = MobileConnectSDK.getClientSecret(), redirectURL : NSURL = MobileConnectSDK.getRedirectURL()) {
    
        NSException.checkClientKey(clientKey)
        NSException.checkClientSecret(clientSecret)
        NSException.checkRedirect(redirectURL)
    
        self.clientKey = clientKey
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
        
        super.init()
    }
}
