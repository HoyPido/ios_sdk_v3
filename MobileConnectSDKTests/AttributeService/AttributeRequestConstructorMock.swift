//
//  AttributeRequestConstructorMock.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 16/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Nimble
import Quick
import Alamofire

@testable import MobileConnectSDK

class AttributeRequestConstructorMock : InfoRequestConstructor  {
  
  var getPremiumInfoMethodAccessed: Bool = false
  
  override func generateInfoRequest(withURL: String) -> Request {
    self.getPremiumInfoMethodAccessed = true
    return super.generateInfoRequest(withURL)
  }
  
}