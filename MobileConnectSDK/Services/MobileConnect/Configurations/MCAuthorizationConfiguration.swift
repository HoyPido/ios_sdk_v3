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
open class MCAuthorizationConfiguration : MobileConnectServiceConfiguration
{
    let clientName : String //aka application short name from discovery response
    let context : String //context value required while authorizing
    let bindingMessage : String?
    
    public init(clientKey: String,
         clientSecret: String,
         authorizationURLString: String,
         tokenURLString: String,
         assuranceLevel: MCLevelOfAssurance,
         subscriberId: String?,
         metadata: MetadataModel?,
         authorizationScopes : [String],
         clientName : String,
         context : String,
         bindingMessage : String?,
         config : AuthorizationConfigurationParameters?,
         loginHint : String?,
         correlationId: String?)
    {
        NSException.checkClientName(clientName)
        NSException.checkContext(context)
        
        self.bindingMessage = bindingMessage
        self.clientName = clientName
        self.context = context

        var stringValuedScopes : [String] = authorizationScopes
        
        if (authorizationScopes.count == 0) {
            stringValuedScopes = [MobileConnectAuthorization]
        } else if (!authorizationScopes.contains(MobileConnectAuthorization)) {
            stringValuedScopes.append(MobileConnectAuthorization)
        }
        
        super.init(clientKey: clientKey,
                   clientSecret: clientSecret,
                   authorizationURLString: authorizationURLString,
                   tokenURLString: tokenURLString,
                   assuranceLevel: assuranceLevel,
                   subscriberId: subscriberId,
                   metadata: metadata,
                   authorizationScopes: stringValuedScopes,
                   config: config,
                   loginHint: loginHint,
                   correlationId: correlationId)
    }
    
    
    //login_hint_token init
    public init(clientKey: String,
                clientSecret: String,
                authorizationURLString: String,
                tokenURLString: String,
                assuranceLevel: MCLevelOfAssurance,
                subscriberId: String?,
                metadata: MetadataModel?,
                authorizationScopes : [String],
                clientName : String,
                context : String,
                bindingMessage : String?,
                config : AuthorizationConfigurationParameters?)
    {
        NSException.checkClientName(clientName)
        NSException.checkContext(context)
        
        self.bindingMessage = bindingMessage
        self.clientName = clientName
        self.context = context
        
        var stringValuedScopes : [String] = authorizationScopes
        
        if (authorizationScopes.count == 0) {
            stringValuedScopes = [MobileConnectAuthorization]
        } else if (!authorizationScopes.contains(MobileConnectAuthorization)) {
            stringValuedScopes.append(MobileConnectAuthorization)
        }
        
        super.init(clientKey: clientKey,
                   clientSecret: clientSecret,
                   authorizationURLString: authorizationURLString,
                   tokenURLString: tokenURLString,
                   assuranceLevel: assuranceLevel,
                   subscriberId: subscriberId,
                   metadata: metadata,
                   authorizationScopes: stringValuedScopes,
                   config: config)
    }
    
    
    convenience public init(discoveryResponse : DiscoveryResponse,
                            assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.level2,
                            context : String,
                            bindingMessage : String?,
                            authorizationScopes : [ProductType],
                            config : AuthorizationConfigurationParameters?,
                            loginHint : String?,
                            clientName: String?)
    {
        self.init(discoveryResponse : discoveryResponse,
                  assuranceLevel: assuranceLevel,
                  context:  context,
                  bindingMessage: bindingMessage,
                  stringAuthorizationScopes: authorizationScopes.map({$0.stringValue}),
                  config: config,
                  loginHint: loginHint,
                  clientName:clientName)
    }
    
    convenience public init(discoveryResponse : DiscoveryResponse,
         assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.level2,
         context : String,
         bindingMessage : String?,
         stringAuthorizationScopes : [String],
         config : AuthorizationConfigurationParameters?,
         loginHint: String?,
         clientName: String?)
    {
        let localClientName : String = clientName ?? ""
        
        let localClientKey : String = discoveryResponse.response?.client_id ?? ""
        
        let localClientSecret : String = discoveryResponse.response?.client_secret ?? ""
        
        let localAuthorizationURLString : String = discoveryResponse.authorizationEndpoint ?? ""
        
        let localTokenURLString : String = discoveryResponse.tokenEndpoint ?? ""
        
        let localSubscriberId : String? = discoveryResponse.subscriber_id
        
        let localMetadata : MetadataModel? = discoveryResponse.metadata
        
        let localCorrelationId : String? = discoveryResponse.correlation_id ?? ""
        
        self.init(clientKey: localClientKey,
                  clientSecret: localClientSecret,
                  authorizationURLString: localAuthorizationURLString,
                  tokenURLString: localTokenURLString,
                  assuranceLevel: assuranceLevel,
                  subscriberId: localSubscriberId,
                  metadata: localMetadata,
                  authorizationScopes : stringAuthorizationScopes,
                  clientName : localClientName,
                  context : context,
                  bindingMessage: bindingMessage,
                  config: config,
                  loginHint: loginHint,
                  correlationId: localCorrelationId)
    }
    
    //login_hint_token constructor
    convenience public init(discoveryResponse : DiscoveryResponse,
                            assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.level2,
                            context : String,
                            bindingMessage : String?,
                            stringAuthorizationScopes : [String],
                            config : AuthorizationConfigurationParameters?,
                            clientName: String?)
    {
        let localClientName : String = clientName ?? ""
        
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
                  authorizationScopes : stringAuthorizationScopes,
                  clientName : localClientName,
                  context : context,
                  bindingMessage: bindingMessage,
                  config: config)
    }
}
