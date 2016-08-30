//
//  JWTDecoder.swift
//  JWTTools
//
//  Created by Andoni Dan on 21/08/16.
//  Copyright © 2016 carpemeid. All rights reserved.
//

import Foundation

private let kHeaderComponentIndex : Int = 0
private let kDataComponentIndex : Int = 1
private let kSignatureComponentIndex : Int = 2

///Decodes the java web token
@objc public class JWTDecoder : NSObject
{
    let tokenString : String
    
    public init(tokenString : String) {
        self.tokenString = tokenString
    }
    
    //MARK: Properties
    public var decodedHeader : [NSObject : AnyObject]?
    {
        return deserializeNullableComponentData(decodedHeaderValue)
    }
    
    public var decodedDictionary : [NSObject : AnyObject]?
    {
        return deserializeNullableComponentData(decodedValue)
    }
    
    var decodedHeaderValue : NSData?
    {
        return decodeComponent(header ?? "")
    }
    
    var decodedValue : NSData?
    {
        return decodeComponent(dataComponent ?? "")
    }
    
    var message : String?
    {
        guard let header = header else
        {
            return nil
        }
        
        guard let dataComponent = dataComponent else
        {
            return nil
        }
        
        return header + "." + dataComponent
    }
    
    var header : String?
    {
        return convertedComponentAtIndex(kHeaderComponentIndex)
    }
    
    var dataComponent : String?
    {
        return convertedComponentAtIndex(kDataComponentIndex)
    }
    
    var signature : String?
    {
        return convertedComponentAtIndex(kSignatureComponentIndex)
    }
    
    
    //MARK: Helpers
    func deserializeNullableComponentData(data : NSData?) -> [NSObject : AnyObject]?
    {
        guard let data = data else
        {
            return nil
        }
        
        return deserializeComponentData(data)
    }
    
    func deserializeComponentData(data : NSData) -> [NSObject : AnyObject]?
    {
        do
        {
            return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [NSObject : AnyObject]
        }
        catch
        {
            return nil
        }
    }
    
    func decodeComponent(string : String) -> NSData?
    {
        return NSData(base64EncodedString: string, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    }
    
    func convertedComponentAtIndex(index : Int) -> String?
    {
        return componentAtIndex(index)?.convertFromBase64URLToBase64()
    }
    
    func componentAtIndex(index : Int) -> String?
    {
        let tokenComponents : [String] = tokenString.componentsSeparatedByString(".")
        
        if tokenComponents.count > index
        {
            return tokenComponents[index]
        }
        
        return nil
    }
}