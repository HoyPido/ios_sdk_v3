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
        return Float(stringValue.stringByReplacingOccurrencesOfString("mc_v", withString: ""))
    }
}

class ProductVersion
{
    var key : String
    var version : Float?
    
    init?(dictionary : [NSObject : AnyObject])
    {
        if let first = dictionary.first, key = first.0 as? String, value = first.1 as? String
        {
            self.key = key
            version = VersionGenerator(stringValue: value).version
        }
        else
        {
            return nil
        }
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
    func scopeForStringValue(stringValue : String) -> String
    {
        //if passed values is openid, change to openid mc_authn if supported by metadata
        if stringValue == MobileConnect || stringValue == MobileConnectAuthentication
        {
            return (metadata?.supportedVersionsPairs.contains({$0.key == MobileConnectAuthentication}) ?? false) ? MobileConnectAuthentication : MobileConnect
        }
        
        //create a product from the passed scope
        let productType : ProductType = ProductType(stringValue: stringValue)
        
        //define the scopes which are equivalent with the passed one
        let productScopes : [String] = productType == .Unknown ? [stringValue] : productType.keySet
        
        //check the equivalent scopes against metadata
        let versionPairs : [ProductVersion] = versionPairsForStringValues(productScopes)
        
        //if they are not in metadata return as is
        if versionPairs.count == 0
        {
            return stringValue
        }
        
        //check if there are both openid and openid mc_auth
        let authenticationKeySet : [String] = ProductType.Authentication.keySet
        
        if versionPairs.filter({authenticationKeySet.contains($0.key)}).count == authenticationKeySet.count
        {
            return MobileConnectAuthentication
        }
        
        return versionPairs.maxElement({($1.version ?? 0) > ($0.version ?? 0)})?.key ?? ""
    }
    
    //checks the metadata for passed scopes and extracts pairs of scope : version
    func versionPairsForStringValues(productScopes : [String]) -> [ProductVersion]
    {
        return metadata?.supportedVersionsPairs.filter({productScopes.contains($0.key)}) ?? []
    }
    
    func validatedScopes(scopes : [String]) -> String
    {
        return scopes.map({scopeForStringValue($0)}).joinWithSeparator(" ")
    }
}
