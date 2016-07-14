//
//  OpenIdProductType.swift
//  MobileConnectSDK
//
//  Created by jenkins on 14/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

@objc public enum OpenIdProductType : Int
{
    case Profile
    case Email
    case Address
    case Phone
}

extension OpenIdProductType
{
    var stringValue : String
    {
        switch self {
        case .Profile:
            return "profile"
        case .Email:
            return "email"
        case .Address:
            return "address"
        case .Phone:
            return "phone"
        }
    }
}