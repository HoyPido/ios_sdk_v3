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
  
  func webControllerDidCancel(controller : BaseWebController) {
    isAwaitingResponse = false
    controllerResponse?(controller: webController, model : nil, error: MCErrorCode.UserCancelled.error)
  }
  
  func webController(controller : BaseWebController, shouldRedirectToURL url : NSURL) -> Bool {
    return !isValidRedirectURL(url, inController: controller)
  }
  
  func webController(controller : BaseWebController, failedLoadingRequestWithError error : NSError?) {
    isAwaitingResponse = false
    controllerResponse?(controller : nil, model: nil, error: error)
  }
  
  //MARK: Web view helpers
  
  func isValidRedirectURL(url : NSURL, inController controller : BaseWebController) -> Bool {
    var isTheSameHost : Bool = false
    
    if let urlHost = url.host, redirectHost = redirectURL.host {
      isTheSameHost = urlHost == redirectHost
    }
    
    let parameters : [NSObject : AnyObject] = keyValuesFromString(url.query)
    
    if isTheSameHost && parameters.count > 0 {
      isAwaitingResponse = false
      
      didReceiveResponseWithParameters(parameters, fromController: controller)
      
      return true
    }
    
    return false
  }
  
  func didReceiveResponseWithParameters(parameters : [NSObject : AnyObject], fromController controller : BaseWebController) {
    isAwaitingResponse = false
    
    treatWebRedirectParameters(parameters)
  }
  
  func treatWebRedirectParameters(parameters : [NSObject : AnyObject]) {
    
    let deserializeObject = BaseMobileConnectServiceDeserializer<RedirectModel>(dictionary: parameters)
    
    deserializeObject!.deserializeModel { (model : RedirectModel?, error : NSError?) in
      guard let model = model else {
        self.controllerResponse?(controller: self.webController, model: nil, error : error)
        return
      }
      self.didReceiveResponseFromController(self.webController, withRedirectModel: model, error: error)
    }
  }
  
  func keyValuesFromString(string : String?) -> [NSObject : AnyObject] {
    var keyValueDictionary : [NSObject : AnyObject] = [:]
    
    if let string = string {
      let components : [[String]] = string.componentsSeparatedByString("&").map({$0.componentsSeparatedByString("=")})
      
      components.forEach { (component : [String]) in
        
        if let first = component.first, last = component.last {
          keyValueDictionary[first] = last
        }
      }
    }
    
    return keyValueDictionary
  }
  
}