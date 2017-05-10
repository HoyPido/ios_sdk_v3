//
//  BaseMobileConnectServiceExtensions.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 05/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

//BaseMobileConnectService extension where I separate the logic for dealing with WebControllerDelegate methods
extension BaseMobileConnectService : WebControllerDelegate {
  
  func webControllerDidCancel(_ controller : BaseWebController) {
    isAwaitingResponse = false
    controllerResponse?(webController, nil, MCErrorCode.userCancelled.error)
  }
  
  func webController(_ controller : BaseWebController, shouldRedirectToURL url : URL) -> Bool {
    return !isValidRedirectURL(url, inController: controller)
  }
  
  func webController(_ controller : BaseWebController, failedLoadingRequestWithError error : NSError?) {
    isAwaitingResponse = false
    controllerResponse?(nil, nil, error)
  }
  
  // MARK: Web view helpers
  
    func isValidRedirectURL(_ url : URL, inController controller : BaseWebController, redirect : URL? = nil) -> Bool {
       
        
    var isTheSameHost : Bool = false
        print (redirect)

    print("\(url.host)")
    
    let redirectURL : URL
        
    if let redirect = redirect {
       redirectURL = redirect
    } else {
        redirectURL = self.redirectURL as URL
    }
        
//                var test = url.absoluteString
//                var test1 = redirectURL.absoluteString
//                if test.hasPrefix(test1) {
//                    isTheSameHost = true
//                }
//        print(redirectURL)
    if let urlHost = url.host, let redirectHost = redirectURL.host {
      isTheSameHost = urlHost == redirectHost
    }
    
        
        
    let parameters : [AnyHashable: Any] = BaseMobileConnectService.keyValuesFromString(url.query)
    
    if isTheSameHost && parameters.count > 0 {
      isAwaitingResponse = false
      didReceiveResponseWithParameters(parameters, fromController: controller)
      
      return true
    }
    
    return false
  }
  
   func didReceiveResponseWithParameters(_ parameters : [AnyHashable: Any], fromController controller : BaseWebController) {
    isAwaitingResponse = false
    treatWebRedirectParameters(parameters)
  }
  
  func treatWebRedirectParameters(_ parameters : [AnyHashable: Any]) {
    print("parameters")
    print(parameters)
    let deserializeObject = BaseMobileConnectServiceDeserializer<RedirectModel>(dictionary: parameters as AnyObject?)
    deserializeObject?.deserializeModel { (model : RedirectModel?, error : NSError?) in
      guard let model = model else {
        self.controllerResponse?(self.webController, nil, error)
        return
      }
      self.didReceiveResponseFromController(self.webController, withRedirectModel: model, error: error)
    }
  }
  
  class func keyValuesFromString(_ string : String?) -> [AnyHashable: Any] {
    var keyValueDictionary : [AnyHashable: Any] = [:]
    
    if let string = string {
      let components : [[String]] = string.components(separatedBy: "&").map({$0.components(separatedBy: "=")})
      
      components.forEach { (component : [String]) in
        
        if let first = component.first, let last = component.last {
          keyValueDictionary[first] = last
        }
      }
    }
    return keyValueDictionary
  }
  
}
