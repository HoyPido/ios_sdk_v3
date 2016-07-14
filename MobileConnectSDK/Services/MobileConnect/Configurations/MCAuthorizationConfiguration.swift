//
//  MCAuthorizationConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 13/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

//In the future the Objective C available new and init constructors should be disallowed
///Use this class to create MobileConnect service for getting Authorization products (phone, email, etc.)
public class MCAuthorizationConfiguration : MobileConnectServiceConfiguration
{
    let clientName : String //aka application short name from discovery response
    let context : String //context value required while authorizing
    
    init(clientKey: String,
         clientSecret: String,
         authorizationURLString: String,
         tokenURLString: String,
         assuranceLevel: MCLevelOfAssurance,
         subscriberId: String?,
         metadata: MetadataModel?,
         scopes : [String],
         clientName : String,
         context : String)
    {
        NSException.checkClientName(clientName, forProducts: scopes)
        NSException.checkContext(context, forProducts: scopes)
        NSException.checkScopes(scopes)
        
        self.clientName = clientName
        self.context = context
        
        super.init(clientKey: clientKey,
                   clientSecret: clientSecret,
                   authorizationURLString: authorizationURLString,
                   tokenURLString: tokenURLString,
                   assuranceLevel: assuranceLevel,
                   subscriberId: subscriberId,
                   metadata: metadata,
                   scopes: scopes)
    }
    
    convenience init(discoveryResponse : DiscoveryResponse,
         assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.Level2,
         context : String,
         scopes : [String])
    {
        let localClientName : String = discoveryResponse.applicationShortName ?? ""
        
        let localClientKey : String = discoveryResponse.response?.client_id ?? ""
        
        let localClientSecret : String = discoveryResponse.response?.client_secret ?? ""
        
        let localAuthorizationURLString : String = discoveryResponse.authorizationEndpoint ?? ""
        
        let localTokenURLString : String = discoveryResponse.tokenEndpoint ?? ""
        
        let localSubscriberId : String? = discoveryResponse.subscriber_id
        
        let localMetadata : MetadataModel? = discoveryResponse.metadata
        
        
        self.init(clientKey: localClientKey,
                  clientSecret: localClientSecret,
                  authorizationURLString: localAuthorizationURLString,
                  tokenURLString: localTokenURLString,
                  assuranceLevel: assuranceLevel,
                  subscriberId: localSubscriberId,
                  metadata: localMetadata,
                  scopes : scopes,
                  clientName : localClientName,
                  context : context)
    }
}