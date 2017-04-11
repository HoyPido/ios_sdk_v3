//
//  PublicKey.swift
//  JWTTools
//
//  Created by Andoni Dan on 21/08/16.
//  Copyright © 2016 carpemeid. All rights reserved.
//

import Foundation

open class PublicKey : NSObject
{
    let exponent : String
    let modulus : String
    
    public init(exponentString : String, modulusString : String) {
        
        self.exponent = exponentString
        self.modulus = modulusString
        
        super.init()
    }
    
    var modulusData : Data?
    {
        return encodeAndTransformToData(modulus)
    }
    
    var exponentData : Data?
    {
        return encodeAndTransformToData(exponent)
    }
    
    func encodeAndTransformToData(_ string : String) -> Data?
    {
        return Data(base64Encoded: string.convertFromBase64URLToBase64(), options: [])
    }
}
