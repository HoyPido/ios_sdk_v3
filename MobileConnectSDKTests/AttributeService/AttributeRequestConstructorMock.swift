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

class AttributeRequestConstructorMock : AttributeRequestConstructor  {
  
  var getPremiumInfoMethodAccessed: Bool = false
  
  override func generatePremiumInfoRequest(withURL: String) -> Request {
    self.getPremiumInfoMethodAccessed = true
    return super.generatePremiumInfoRequest(withURL)
  }
  
}