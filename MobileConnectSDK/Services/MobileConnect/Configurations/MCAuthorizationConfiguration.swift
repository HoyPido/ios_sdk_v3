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
    let bindingMessage : String?
    
    init(clientKey: String,
         clientSecret: String,
         authorizationURLString: String,
         tokenURLString: String,
         assuranceLevel: MCLevelOfAssurance,
         subscriberId: String?,
         metadata: MetadataModel?,
         authorizationScopes : [OpenIdProductType],
         clientName : String,
         context : String,
         bindingMessage : String?)
    {
        NSException.checkClientName(clientName)
        NSException.checkContext(context)
        
        self.bindingMessage = bindingMessage
        self.clientName = clientName
        self.context = context
        
        let stringValuedScopes : [String] = authorizationScopes.map({$0.stringValue}) + [MobileConnectAuthorization]
        
        super.init(clientKey: clientKey,
                   clientSecret: clientSecret,
                   authorizationURLString: authorizationURLString,
                   tokenURLString: tokenURLString,
                   assuranceLevel: assuranceLevel,
                   subscriberId: subscriberId,
                   metadata: metadata,
                   authorizationScopes: stringValuedScopes)
    }
    
    convenience init(discoveryResponse : DiscoveryResponse,
         assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.Level2,
         context : String,
         bindingMessage : String?,
         authorizationScopes : [OpenIdProductType])
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
                  authorizationScopes : authorizationScopes,
                  clientName : localClientName,
                  context : context,
                  bindingMessage: bindingMessage)
    }
}