//
//  ExtensionNSUUID.swift
//  MobileConnectSDK
//
//  Created by Dan Andoni on 13/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

extension NSUUID
{
    class var randomUUID : String
    {
        return NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
    }
}