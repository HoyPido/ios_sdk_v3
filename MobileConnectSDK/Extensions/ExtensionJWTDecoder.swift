//
//  ExtensionJWTDecoder.swift
//  MobileConnectSDK
//
//  Created by jenkins on 26/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

extension JWTDecoder
{
    var headerModel : TokenIdHeaderModel?
    {
        guard let deserializer = BaseMobileConnectServiceDeserializer<TokenIdHeaderModel>(dictionary: decodedHeader as AnyObject?) else
        {
            return nil
        }
        
        do
        {
            return try deserializer.seriallyDeserializeModel()
        } catch
        {
            return nil
        }
    }
}
