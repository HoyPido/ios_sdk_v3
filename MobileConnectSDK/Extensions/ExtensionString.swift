//
//  StringExtension.swift
//  JWTTools
//
//  Created by Andoni Dan on 21/08/16.
//  Copyright © 2016 carpemeid. All rights reserved.
//

import Foundation

extension String
{
    func convertFromBase64URLToBase64() -> String
    {
        return stringByReplacingOccurrencesOfString("-", withString: "+").stringByReplacingOccurrencesOfString("_", withString: "/").stringWithBase64Padding()
    }
    
    func stringWithBase64Padding() -> String
    {
        let characterOffset : Int = 4 - characters.count % 4
        let charactersToAdd : Int = characterOffset > 3 ? 0 : characterOffset
        
        let paddedStringToAdd : String = "".stringByPaddingToLength(charactersToAdd, withString: "=", startingAtIndex: 0)
        
        return stringByAppendingString(paddedStringToAdd)
    }
}