//
//  JWTManager.swift
//  JWTTools
//
//  Created by Andoni Dan on 21/08/16.
//  Copyright © 2016 carpemeid. All rights reserved.
//

import Foundation
import Heimdall


public class JWTManager : NSObject
{
    public let decoder : JWTDecoder
    
    public init(JWTTokenString : String) {
        
        decoder = JWTDecoder(tokenString: JWTTokenString)

        super.init()
    }
    
    public func verifyWithPublicKey(publicKey : PublicKey) throws -> Bool
    {
        guard let modulusData = publicKey.modulusData, exponentData = publicKey.exponentData else
        {
            throw JWTErrorCode.InvalidPublicKey.error
        }
        
        guard let message = decoder.message, signature = decoder.signature else
        {
            throw JWTErrorCode.InvalidToken.error
        }
        
        guard let verifier = Heimdall(publicTag: kJWTToolsTag, publicKeyModulus: modulusData, publicKeyExponent: exponentData) else
        {
            throw JWTErrorCode.Unknown.error
        }
        
        return verifier.verify(message, signatureBase64: signature, urlEncoded: true)
    }
}