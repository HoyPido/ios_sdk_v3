//
//  ScopeValidator.swift
//  MobileConnectSDK
//
//  Created by jenkins on 11/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

class VersionGenerator
{
    let stringValue : String
    
    init(stringValue : String)
    {
        self.stringValue = stringValue
    }
    
    var version : Float?
    {
        return Float(stringValue.replacingOccurrences(of: "mc_v", with: ""))
    }
}

class ProductVersion
{
    var key : String
    var version : Float?
    
    init?(dictionary : [AnyHashable: Any])
    {
        if let first = dictionary.first, let key = first.0 as? String, let value = first.1 as? String
        {
            self.key = key
            version = VersionGenerator(stringValue: value).version
        } else
        {
            return nil
        }
    }
    
    func versionString()->String? {
        if let version = version {
            let roundedVersion = Double(Int(10*version))/10
            return "mc_v\(roundedVersion)"
        }
        return nil
    }
}

class ScopeValidator: NSObject {
    
    var metadata : MetadataModel?
    
    init(metadata : MetadataModel?)
    {
        self.metadata = metadata
        
        super.init()
    }
    
    //given a scope string identifies the other possible values and searches them in the metadata
    //returns the scope with the highest supported version
    func scopeForStringValue(_ stringValue : String) -> String
    {
        //if passed values is openid, change to openid mc_authn if supported by metadata
        if stringValue == MobileConnect || stringValue == MobileConnectAuthentication
        {
            return (metadata?.supportedVersionsPairs.contains(where: {$0.key == MobileConnectAuthentication}) ?? false) ? MobileConnectAuthentication : MobileConnect
        }
        
        //create a product from the passed scope
        let productType : ProductType = ProductType(stringValue: stringValue)
        
        //define the scopes which are equivalent with the passed one
        let productScopes : [String] = productType == .unknown ? [stringValue] : productType.keySet
        
        //check the equivalent scopes against metadata
        let versionPairs : [ProductVersion] = versionPairsForStringValues(productScopes)
        
        //if they are not in metadata return as is
        if versionPairs.count == 0
        {
            return stringValue
        }
        
        //check if there are both openid and openid mc_auth
        let authenticationKeySet : [String] = ProductType.authentication.keySet
        
        if versionPairs.filter({authenticationKeySet.contains($0.key)}).count == authenticationKeySet.count
        {
            return MobileConnectAuthentication
        }
        
        return versionPairs.max(by: {($1.version ?? 0) > ($0.version ?? 0)})?.key ?? ""
    }
    
    //checks the metadata for passed scopes and extracts pairs of scope : version
    func versionPairsForStringValues(_ productScopes : [String]) -> [ProductVersion]
    {
        return metadata?.supportedVersionsPairs.filter({productScopes.contains($0.key)}) ?? []
    }
    
    func validatedScopes(_ scopes : [String]) -> String
    {
        return scopes.map({scopeForStringValue($0)}).joined(separator: " ")
    }
}
