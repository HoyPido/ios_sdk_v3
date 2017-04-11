//
//  ProductType.swift
//  MobileConnectSDK
//
//  Created by jenkins on 12/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

@objc public enum ProductType : Int
{
    case authentication
    case authorization
    case identityPhoneNumber
    case identitySignUp
    case identitySignUpPlus
    case identityNationalID
    case unknown
    case phone
    case address
    case profile
    case email
}

extension ProductType
{
    init(stringValue : String)
    {
        if let indexOfKeySet = ProductType.keySets.index(where: {$0.contains(stringValue)})
        {
            assert(ProductType.enumValues.count == ProductType.keySets.count, "The enum values array should reflect the enum values of the strings arrays inside the keysets property. Please check in the product type enum!!!")
            
            self = ProductType.enumValues[indexOfKeySet]
        } else
        {
            self = .unknown
        }
    }
    
    var stringValue : String
    {
        if let indexOfKeySet = ProductType.enumValues.index(of: self)
        {
            assert(ProductType.enumValues.count == ProductType.keySets.count, "The enum values array should reflect the enum values of the strings arrays inside the keysets property. Please check in the product type enum!!!")
            
            return  ProductType.keySets[indexOfKeySet].first ?? ""
        }
        
        return ""
    }
    
    fileprivate var enumIndex : Int?
    {
        return ProductType.enumValues.index(of: self)
    }
    
    var keySet : [String]
    {
        if let enumIndex = enumIndex
        {
            return ProductType.keySets[enumIndex]
        }
        
        return []
    }
    
    fileprivate static var enumValues : [ProductType]
    {
        return [.authentication, .authorization, .identityPhoneNumber, .identitySignUp, .identitySignUpPlus, .identityPhoneNumber, .identityNationalID, .phone, .address, .profile, .email]
    }
    
    fileprivate static var keySets : [[String]]
    {
        return [[MobileConnect, MobileConnectAuthentication], [MobileConnectAuthorization], [MobileConnectIdentityPhone], [MobileConnectIdentitySignup], [MobileConnectIdentitySignupPlus], [MobileConnectIdentityPhone], [MobileConnectIdentityNationalID], [MobileConnectPhone], [MobileConnectAddress], [MobileConnectProfile], [MobileConnectEmail]]
    }
}
