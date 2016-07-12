//
//  DiscoveryServiceConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 11/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

class DiscoveryServiceConfiguration: BaseServiceConfiguration {
    
    let applicationEndpoint : String
    
    init(applicationEndpoint : String = MobileConnectSDK.getApplicationEndpoint(), clientKey : String = MobileConnectSDK.getClientKey(), clientSecret : String = MobileConnectSDK.getClientSecret(), redirectURL :  NSURL = MobileConnectSDK.getRedirectURL())
    {
        NSException.checkEndpoint(applicationEndpoint)
        
        self.applicationEndpoint = applicationEndpoint
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: redirectURL)
    }
}
