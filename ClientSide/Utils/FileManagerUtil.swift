//
//  FileManager.swift
//  MobileConnectSDK
//
//  Created by user on 1/20/18.
//  Copyright © 2018 GSMA. All rights reserved.
//

import Foundation

open class FileManager : NSObject {
    var operatorParameters : OperatorParametersModel?
    
    public func readOperatorData(filePath: String)->OperatorParametersModel {
        
        let pathToConfigutationFile = Bundle.main.path(forResource: filePath, ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        
        operatorParameters?.clientId = (itemsDictionaryRoot?.value(forKey: "clientID") as? String)!
        operatorParameters?.clientSecret = (itemsDictionaryRoot?.value(forKey: "clientSecret") as? String)!
        operatorParameters?.discoveryURL = (itemsDictionaryRoot?.value(forKey: "discoveryURL"))! as! String
        operatorParameters?.redirectURL = (itemsDictionaryRoot?.value(forKey: "redirectUrl") as? String)!
        operatorParameters?.xRedirect = (itemsDictionaryRoot?.value(forKey: "xRedirect") as? Bool)!
        operatorParameters?.includeRequestIp = (itemsDictionaryRoot?.value(forKey: "includeRequestIP") as? Bool)!
        operatorParameters?.apiVersion = (itemsDictionaryRoot?.value(forKey: "apiVersion") as? String)!
        operatorParameters?.scope = (itemsDictionaryRoot?.value(forKey: "scope") as? String)!
        
        return operatorParameters!
    }
}
