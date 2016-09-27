//
//  BaseMobileConnectServiceHelper.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 05/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

class BaseMobileConnectServiceDeserializer<T:MCModel>: NSObject {
  
  let modelDictionary : [NSObject : AnyObject]
  
  init?(dictionary: AnyObject?) {
    if let dictionary = dictionary as? [NSObject : AnyObject] {
      self.modelDictionary = dictionary
    } else {
        self.modelDictionary = [:]
        
    }
  }
  
    func seriallyDeserializeModel() throws -> T?
    {
        if self.modelDictionary.keys.contains({$0 == "error"}) {
            
            let errorDescription : String = (self.modelDictionary["error_description"] as? String) ?? (self.modelDictionary["description"] as? String) ?? ""
            
            throw NSError(domain: kMobileConnectErrorDomain, code: MCErrorCode.ServerResponse.rawValue, userInfo: [NSLocalizedDescriptionKey : errorDescription])
        }
        
        let model = try T(dictionary: self.modelDictionary)

        return model
    }
    
  func deserializeModel(completionHandler : (model : T? , error : NSError?) -> Void) {
    do
    {
        completionHandler(model: try seriallyDeserializeModel(), error: nil)
    }
    catch
    {
        completionHandler(model: nil, error: error as NSError)
    }
  }
  
}