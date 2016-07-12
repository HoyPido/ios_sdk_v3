//
//  ProductType.swift
//  MobileConnectSDK
//
//  Created by jenkins on 12/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

@objc enum ProductType : Int
{
    case Authentication
    case Authorization
    case IdentityPhoneNumber
    case IdentitySignUp
    case IdentitySignUpPlus
    case IdentityNationalID
    case Unknown
}

extension ProductType
{
    init(stringValue : String)
    {
        if let indexOfKeySet = ProductType.keySets.indexOf({$0.contains(stringValue)})
        {
            assert(ProductType.enumValues.count == ProductType.keySets.count, "The enum values array should reflect the enum values of the strings arrays inside the keysets property. Please check in the product type enum!!!")
            
            self = ProductType.enumValues[indexOfKeySet]
        }
        else
        {
            self = .Unknown
        }
    }
    
    private var enumIndex : Int?
    {
        return ProductType.enumValues.indexOf(self)
    }
    
    var keySet : [String]
    {
        if let enumIndex = enumIndex
        {
            return ProductType.keySets[enumIndex]
        }
        
        return []
    }
    
    static var enumValues : [ProductType]
    {
        return [.Authentication, .Authorization, .IdentityPhoneNumber, .IdentitySignUp, .IdentitySignUpPlus, .IdentityPhoneNumber, .IdentityNationalID]
    }
    
    static var keySets : [[String]]
    {
        return [[MobileConnect, MobileConnectAuthentication], [MobileConnectAuthorization], [MobileConnectIdentityPhone], [MobileConnectIdentitySignup], [MobileConnectIdentitySignupPlus],[MobileConnectIdentityPhone], [MobileConnectIdentityNationalID]]
    }
}