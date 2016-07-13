//
//  ExtensionMetadataModel.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 13/07/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

extension MetadataModel
{
    var supportedVersionsPairs : [ProductVersion]
    {
        return mobile_connect_version_supported?.flatMap({ProductVersion(dictionary: $0)}) ?? []
    }
}