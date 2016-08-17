//
//  AttributeRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 12/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

class AttributeRequestConstructor: NSObject {
  
  let accessToken: String
  
  var headers : [String:String] {
    return ["Authorization" : "Bearer " + accessToken]
  }
  
  init(accessToken: String) {
    self.accessToken = accessToken
  }
  
  func generatePremiumInfoRequest(withURL: String) -> Request {
    return request(.GET, withURL, encoding: .URLEncodedInURL, headers: headers)
  }
  
}