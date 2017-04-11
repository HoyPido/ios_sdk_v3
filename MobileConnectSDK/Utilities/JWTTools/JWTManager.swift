//
//  JWTManager.swift
//  JWTTools
//
//  Created by Andoni Dan on 21/08/16.
//  Copyright © 2016 carpemeid. All rights reserved.
//

import Foundation
import Heimdall


class JWTManager : NSObject
{
    let decoder : JWTDecoder
    
    init(JWTTokenString : String) {
        
        decoder = JWTDecoder(tokenString: JWTTokenString)

        super.init()
    }
    
    func verifyWithPublicKey(_ publicKey : PublicKey) throws -> Bool
    {
        guard let modulusData = publicKey.modulusData, let exponentData = publicKey.exponentData, publicKey.modulus != "" && publicKey.exponent != "" else
        {
            throw JWTErrorCode.invalidPublicKey.error
        }
        
        guard let message = decoder.message, let signature = decoder.signature else
        {
            throw JWTErrorCode.invalidToken.error
        }
        
        guard let verifier = Heimdall(publicTag: kJWTToolsTag, publicKeyModulus: modulusData, publicKeyExponent: exponentData) else
        {
            throw JWTErrorCode.unknown.error
        }
        
        return verifier.verify(message, signatureBase64: signature, urlEncoded: true)
    }
}
