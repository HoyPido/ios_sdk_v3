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
            print("mc_v1.2")
            return "mc_v1.2"
            // return "mc_v\(roundedVersion)"
        }
        return nil
    }
}

class ScopeValidator: NSObject {
    
    var metadata : MetadataModel?
    
    let openidScope = "openid"
    let authorizationScope = "mc_authz"
    let authenticationScope = "mc_authn"
    
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
    
    public var validatedScopeValue = ""
    public var flag = true
    
    func validatedScopes(_ scopes : [String]) -> String
    {
        let temporaryScopeValue = scopes.map({scopeForStringValue($0)}).joined(separator: " ")
        isDuplicatedScope(temporaryScopeValue)
        checkScopePosition(validatedScopeValue)
        print(validatedScopeValue)
        return validatedScopeValue
    }

    func isDuplicatedScope(_ scopeValues: String) {
        let array = scopeValues.components(separatedBy: " ")
        for scope in array {
            let arrayofscopes : [String] = validatedScopeValue.components(separatedBy: " ")
            for arr in arrayofscopes {
                if(arr.contains(scope)) {
                    flag = false
                    break
                } else {
                    flag = true
                }
            }
            if (flag == true) {
                if validatedScopeValue.characters.count == 0 {
                   validatedScopeValue += scope
                } else {
                    validatedScopeValue += " " + scope
                }
            }
        }
    }
    
    func checkScopePosition(_ scopeValues: String) {
        var scopeArray = scopeValues.components(separatedBy: " ")
        for (index, element) in scopeArray.enumerated() {
            if (element.contains(openidScope)) {
                scopeArray.remove(at: index)
                scopeArray.insert(element, at: 0)
            } else if (element.contains(authorizationScope) || element.contains(authenticationScope)) {
                scopeArray.remove(at: index)
                scopeArray.insert(element, at: 1)
            }
        }
        validatedScopeValue = scopeArray.joined(separator: " ")
    }
}
