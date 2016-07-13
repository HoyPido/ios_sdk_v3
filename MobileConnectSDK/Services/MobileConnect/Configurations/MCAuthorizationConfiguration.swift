//
//  MCAuthorizationConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 13/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

public class MCAuthorizationConfiguration : MobileConnectServiceConfiguration
{
    let scopes : [String]
    let clientName : String? //aka application short name from discovery response
    let context : String? //context value required while authorizing
    
    //NSException.checkClientName(clientName, forProducts: scopes)
    //NSException.checkContext(context, forProducts: scopes)
}