//
//  ExtensionMetadataModel.swift
//  MobileConnectSDK
//
//  Created by jenkins on 06/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

@testable import MobileConnectSDK

extension MetadataModel
{
    func insertMockData(supportedServices : [String]?, authorizationEndpoint : String?, tokenEndpoint : String?, userInfoEndpoint : String?, premiumInfoEndpoint : String?, tokenRevocation : String?)
    {
        scopes_supported = supportedServices
        authorization_endpoint = authorizationEndpoint
        token_endpoint = tokenEndpoint
        userinfo_endpoint = userInfoEndpoint
        premiuminfo_endpoint = premiumInfoEndpoint
        revoke_endpoint = tokenRevocation
    }
}