//
//  PublicKey.swift
//  JWTTools
//
//  Created by Andoni Dan on 21/08/16.
//  Copyright © 2016 carpemeid. All rights reserved.
//

import Foundation

public class PublicKey : NSObject
{
    let exponent : String
    let modulus : String
    
    public init(exponentString : String, modulusString : String) {
        
        self.exponent = exponentString
        self.modulus = modulusString
        
        super.init()
    }
    
    var modulusData : NSData?
    {
        return encodeAndTransformToData(modulus)
    }
    
    var exponentData : NSData?
    {
        return encodeAndTransformToData(exponent)
    }
    
    func encodeAndTransformToData(string : String) -> NSData?
    {
        return NSData(base64EncodedString: string.convertFromBase64URLToBase64(), options: [])
    }
}
