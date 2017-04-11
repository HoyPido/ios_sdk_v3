//
//  BaseServiceConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 11/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

open class BaseServiceConfiguration: NSObject {
    
    var clientKey : String
    let clientSecret : String
    let redirectURL : URL
    
    init(clientKey : String = MobileConnectSDK.getClientKey(), clientSecret : String = MobileConnectSDK.getClientSecret(), redirectURL : URL = MobileConnectSDK.getRedirectURL() as URL) {
    
        NSException.checkClientKey(clientKey)
        NSException.checkClientSecret(clientSecret)
        NSException.checkRedirect(redirectURL)
    
        self.clientKey = clientKey
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
        
        super.init()
    }
}
