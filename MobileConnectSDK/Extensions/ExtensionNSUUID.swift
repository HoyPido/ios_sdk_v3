//
//  ExtensionNSUUID.swift
//  MobileConnectSDK
//
//  Created by Dan Andoni on 13/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

extension UUID
{
    static var randomUUID : String
    {
        return UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
