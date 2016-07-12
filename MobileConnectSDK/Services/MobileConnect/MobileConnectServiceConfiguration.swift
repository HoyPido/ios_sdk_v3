//
//  MobileConnectServiceConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 11/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

///Configuration needed for instantiating the MCService instance
public class MobileConnectServiceConfiguration: BaseServiceConfiguration {
    
    let authorizationURLString : String
    let tokenURLString : String
    let assuranceLevel : MCLevelOfAssurance
    let metadata : MetadataModel?
    let scopes : [String]
    
    /**
     This constructor may change with addition of new features in future versions.
     It is recommended to use the init with discovery response if possible.
    */
    public required init(clientKey : String, clientSecret : String, authorizationURLString : String, tokenURLString : String, assuranceLevel : MCLevelOfAssurance, metadata : MetadataModel?, scopes : [String] = [MobileConnectAuthentication])
    {
        self.scopes = scopes
        self.authorizationURLString = authorizationURLString
        self.tokenURLString = tokenURLString
        self.assuranceLevel = assuranceLevel
        self.metadata = metadata
        
        super.init(clientKey: clientKey, clientSecret: clientSecret, redirectURL: MobileConnectSDK.getRedirectURL())
    }
    
    public convenience init(discoveryResponse : DiscoveryResponse, assuranceLevel : MCLevelOfAssurance = MCLevelOfAssurance.Level2, scopes : [String] = [MobileConnectAuthorization, MobileConnectIdentityPhone]) {
        
        let localClientKey : String = discoveryResponse.response?.client_id ?? ""
        
        let localClientSecret : String = discoveryResponse.response?.client_secret ?? ""
        
        let localAuthorizationURLString : String = discoveryResponse.authorizationEndpoint ?? ""
        
        let localTokenURLString : String = discoveryResponse.tokenEndpoint ?? ""
        
        let localAssuranceLevel : MCLevelOfAssurance = assuranceLevel
        
        let localMetadata : MetadataModel? = discoveryResponse.metadata
        
        self.init(clientKey: localClientKey, clientSecret: localClientSecret, authorizationURLString: localAuthorizationURLString, tokenURLString: localTokenURLString, assuranceLevel: localAssuranceLevel, metadata: localMetadata, scopes: scopes)
    }
}
