//
//  ExtensionDiscoveryResponse.swift
//  MobileConnectSDK
//
//  Created by jenkins on 29/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

extension DiscoveryResponse {
    
    ///In case the passed services argument contains scopes which are not contained in the metadata, the function will return nil
    func isMobileConnectServiceSupported(services : String) -> Bool?
    {
        guard services.characters.count > 0 else
        {
            return nil
        }
        
        let searchedServices : [String] = services.componentsSeparatedByString(" ").map({$0.lowercaseString})
        let existingServices : [String] = (metadata?.scopes_supported ?? []).map({$0.lowercaseString})
        
        return searchedServices.filter({existingServices.contains($0)}).count == searchedServices.count
    }
    
    public var authorizationEndpoint : String?
    {
        return metadata?.authorization_endpoint ?? response?.apis?.operatorid?.authorizationLink()
    }
    
    public var tokenEndpoint : String?
    {
        return metadata?.token_endpoint ?? response?.apis?.operatorid?.tokenLink()
    }
    
    public var userInfoEndpoint : String?
    {
        return metadata?.userinfo_endpoint ?? response?.apis?.operatorid?.userInfoLink()
    }
    
    public var premiumInfoEndpoint : String?
    {
        return  metadata?.premiuminfo_endpoint ?? response?.apis?.operatorid?.premiumInfo()
    }
    
    public var tokenRevocation : String?
    {
        return metadata?.revoke_endpoint ?? response?.apis?.operatorid?.tokenRevocation()
    }
    
    public var applicationShortName : String?
    {
        return response?.apis?.operatorid?.applicationShortName()
    }
}
