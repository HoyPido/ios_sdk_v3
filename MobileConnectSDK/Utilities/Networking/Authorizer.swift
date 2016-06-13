//
//  Authorizer.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 08/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

class Authorizer: NSObject {
    
    let clientKey : String
    let clientSecret : String
    
    init(clientKey : String, clientSecret : String) {
        
        NSException.checkClientKey(clientKey)
        NSException.checkClientSecret(clientSecret)
        
        self.clientKey = clientKey
        self.clientSecret = clientSecret
        
        super.init()
    }
    
    lazy var headers : [String : String] =
    {
        let credentialsString : String = "\(self.clientKey):\(self.clientSecret)"
        
        if let encodedData : NSData = credentialsString.dataUsingEncoding(NSUTF8StringEncoding)
        {
            let encodedCredentials : String = encodedData.base64EncodedStringWithOptions([])
            
            return ["Authorization" : "Basic \(encodedCredentials)"]
        }
        else
        {
            print("failed while encoding developers credentials")
        }
        
        return [:]
    }()
}
