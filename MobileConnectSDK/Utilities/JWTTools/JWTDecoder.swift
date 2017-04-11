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
@objc open class JWTDecoder : NSObject
{
    let tokenString : String
    
    public init(tokenString : String) {
        self.tokenString = tokenString
    }
    
    // MARK: Properties
    open var decodedHeader : [AnyHashable: Any]?
    {
        return deserializeNullableComponentData(decodedHeaderValue)
    }
    
    open var decodedDictionary : [AnyHashable: Any]?
    {
        return deserializeNullableComponentData(decodedValue)
    }
    
    open var decodedHeaderValue : Data?
    {
        return decodeComponent(header ?? "")
    }
    
    var decodedValue : Data?
    {
        return decodeComponent(dataComponent ?? "")
    }
    
    open var message : String?
    {
        guard let header = headerToken else
        {
            return nil
        }
        
        guard let dataComponent = dataComponentToken else
        {
            return nil
        }
        
        return header + "." + dataComponent
    }
    
    var headerToken : String? {
        return componentAtIndex(kHeaderComponentIndex)
    }
    
    var dataComponentToken : String? {
        return componentAtIndex(kDataComponentIndex)
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
    
    
    // MARK: Helpers
    func deserializeNullableComponentData(_ data : Data?) -> [AnyHashable: Any]?
    {
        guard let data = data else
        {
            return nil
        }
        
        return deserializeComponentData(data)
    }
    
    func deserializeComponentData(_ data : Data) -> [AnyHashable: Any]?
    {
        do
        {
            return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [AnyHashable: Any]
        } catch
        {
            return nil
        }
    }
    
    func decodeComponent(_ string : String) -> Data?
    {
        return Data(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
    }
    
    func convertedComponentAtIndex(_ index : Int) -> String?
    {
        return componentAtIndex(index)?.convertFromBase64URLToBase64()
    }
    
    func componentAtIndex(_ index : Int) -> String?
    {
        let tokenComponents : [String] = tokenString.components(separatedBy: ".")
        
        if tokenComponents.count > index
        {
            return tokenComponents[index]
        }
        
        return nil
    }
}
