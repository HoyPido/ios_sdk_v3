//
//  BaseMobileConnectServiceHelper.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 05/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

class BaseMobileConnectServiceDeserializer<T:MCModel>: NSObject {
  
  let modelDictionary : [AnyHashable: Any]
  
  init?(dictionary: AnyObject?) {
    if let dictionary = dictionary as? [AnyHashable: Any] {
      self.modelDictionary = dictionary
    } else {
        self.modelDictionary = [:]
        
    }
  }
  
    func seriallyDeserializeModel() throws -> T?
    {
        let keys = modelDictionary.keys.first
        print("dictionary")
        print(modelDictionary)
        if keys?.description == "error" {
            let errorDescription : String = (self.modelDictionary["error_description"] as? String) ?? (self.modelDictionary["description"] as? String) ?? ""
            
            throw NSError(domain: kMobileConnectErrorDomain, code: MCErrorCode.serverResponse.rawValue, userInfo: [NSLocalizedDescriptionKey : errorDescription])

        }
        
        let model = try T(dictionary: self.modelDictionary)

        return model
    }
    
  func deserializeModel(_ completionHandler : (_ model : T?, _ error : NSError?) -> Void) {
    do
    {
        completionHandler(try seriallyDeserializeModel(), nil)
    } catch
    {
        completionHandler(nil, error as NSError)
    }
  }  
}
