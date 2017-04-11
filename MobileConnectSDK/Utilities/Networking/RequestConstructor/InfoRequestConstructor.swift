//
//  InfoRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 12/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

class InfoRequestConstructor: NSObject {
  
  let accessToken: String
  
  var headers : [String:String] {
    return ["Authorization" : "Bearer " + accessToken]
  }
  
  init(accessToken: String) {
    self.accessToken = accessToken
  }
  
  func generateInfoRequest(_ withURL: String) -> Request {

    return request(withURL, method: .get, parameters: [:], encoding: URLEncoding.methodDependent, headers: headers)
  }
  
}
