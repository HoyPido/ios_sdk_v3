//
//  JWTDecoder.swift
//  MobileConnectSDK
//
//  Created by jenkins on 15/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

private let kDataComponentIndex : Int = 1

///Decodes the java web token
@objc public class JWTDecoder : NSObject
{
    let tokenString : String
    
    public init(tokenString : String) {
        self.tokenString = tokenString
    }
    
    public var decodedDictionary : [NSObject : AnyObject]?
    {
        guard let decodedValue = decodedValue else {return nil}
        
        do
        {
            return try NSJSONSerialization.JSONObjectWithData(decodedValue, options: NSJSONReadingOptions.AllowFragments) as? [NSObject : AnyObject]
        }
        catch
        {
            return nil
        }
    }
    
    public var decodedValue : NSData?
    {
        guard let correctedDataComponent = correctedDataComponent else
        {
            return nil
        }
        
        return NSData(base64EncodedString: correctedDataComponent, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    }
    
    var correctedDataComponent : String?
    {
        guard let dataComponent = dataComponent else
        {
            return nil
        }
        
        let characterOffset : Int = 4 - dataComponent.characters.count % 4
        let charactersToAdd : Int = characterOffset > 3 ? 0 : characterOffset
        
        let paddedStringToAdd : String = "".stringByPaddingToLength(charactersToAdd, withString: "=", startingAtIndex: 0)
        
        return dataComponent.stringByAppendingString(paddedStringToAdd)
    }
    
    var dataComponent : String?
    {
        let tokenComponents : [String] = tokenString.componentsSeparatedByString(".")
        
        if tokenComponents.count > 2
        {
            return tokenComponents[kDataComponentIndex]
        }
        
        return nil
    }
}