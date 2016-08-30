//
//  Constants.swift
//  JWTTools
//
//  Created by jenkins on 24/08/2016.
//  Copyright © 2016 carpemeid. All rights reserved.
//

import Foundation

let kJWTToolsTag : String = "com.carpemeid.JWTTools"

@objc public enum JWTErrorCode : Int
{
    case InvalidPublicKey
    case InvalidToken
    case Unknown
}

extension JWTErrorCode
{
    ///The error related to the MCErrorCode enum value
    public var error : NSError
    {
        return NSError(domain: kJWTToolsTag, code: rawValue, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
    ///The error message related to the MCErrorCode enum value
    public var message : String
    {
        guard let index = JWTErrorCode.errors.indexOf(self) else
        {
            return "Unknown error has occured"
        }
        
        assert(JWTErrorCode.messages.count == JWTErrorCode.errors.count, "The MCErrorCode extension contains messages array and errors array which differ in element count")
        
        return JWTErrorCode.messages[index]
    }
    
    static private var messages : [String]
    {
        return ["Invalid public key provided", "Invalid token provided", "Unknown error occured"]
    }
    
    static private var errors : [JWTErrorCode]
    {
        return [InvalidPublicKey, InvalidToken, Unknown]
    }
}