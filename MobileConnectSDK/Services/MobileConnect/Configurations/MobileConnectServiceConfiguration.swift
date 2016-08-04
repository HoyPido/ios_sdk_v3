//
//  MobileConnectServiceConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 11/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

//In the future the Objective C available new and init constructors should be disallowed
///Configuration needed for instantiating the MCService instance
public class MobileConnectServiceConfiguration: BaseServiceConfiguration {
    
    let authorizationURLString : String
    let tokenURLString : String
    let assuranceLevel : MCLevelOfAssurance
    let metadata : MetadataModel?
    let subscriberId : String?
    let scopes : [String]
    /**
     This constructor may change with addition of new features in future versions.
     It is recommended to use the init with discovery response if possible.
     - Parameter clientKey: the client id received from the discovery OperatorData model
     - Parameter clientSecret: the client secret received from the discovery OperatorData model
     - Parameter authorizationURLString: the authorization url received from the discovery OperatorData model
     - Parameter tokenURLString: the token url received from the discovery OperatorData model
     - Parameter subscriberId: the subscriber id received from the Discovery service operatorData model
     */
    public init(clientKey : String,
                         clientSecret : String,
                         authorizationURLString : String,
                         tokenURLString : String,
                         assuranceLevel : MCLevelOfAssurance,
                         subscriberId : String?,
                         metadata : MetadataModel?,
                         authorizationScopes : [String])
    {
        self.authorizationURLString = authorizationURLString
        self.tokenURLString = tokenURLString
        self.assuranceLevel = assuranceLevel
        self.subscriberId = subscriberId
        self.metadata = metadata
        scopes = authorizationScopes + [MobileConnectAuthentication]
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: MobileConnectSDK.getRedirectURL())
    }
    
    public convenience init(discoveryResponse : DiscoveryResponse, assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.Level2, authorizationScopes : [String])
    {
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
                  subscriberId : localSubscriberId,
                  metadata: localMetadata,
                  authorizationScopes: authorizationScopes)
    }
}
