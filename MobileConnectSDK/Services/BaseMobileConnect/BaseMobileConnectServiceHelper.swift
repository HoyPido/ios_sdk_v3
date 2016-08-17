//
//  BaseMobileConnectServiceHelper.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 05/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

class BaseMobileConnectServiceDeserializer<RedirectModel:MCModel>: NSObject {
  
  let modelDictionary : [NSObject : AnyObject]
  
  init?(dictionary: AnyObject?) {
    if let dictionary = dictionary as? [NSObject : AnyObject] {
      self.modelDictionary = dictionary
    } else {
      return nil
    }
  }
  
  func deserializeModel(completionHandler : (model : RedirectModel? , error : NSError?) -> Void) {
    //if server responds with error, create an NSError instance and send in completion handler
    if self.modelDictionary.keys.contains({$0 == "error"}) {
      
      let errorDescription : String = (self.modelDictionary["error_description"] as? String) ?? (self.modelDictionary["description"] as? String) ?? ""
      
      completionHandler(model: nil, error: NSError(domain: kMobileConnectErrorDomain, code: MCErrorCode.ServerResponse.rawValue, userInfo: [NSLocalizedDescriptionKey : errorDescription]))
      return
    }
    
    var model : RedirectModel?
    
    do {
      model = try RedirectModel(dictionary: self.modelDictionary)
    }
    catch {
      completionHandler(model: nil, error: MCErrorCode.SerializationError.error)
    }
    
    completionHandler(model: model, error: nil)
  }
  
}