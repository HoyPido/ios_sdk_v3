//
//  AttributeServiceSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 16/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class AttributeServiceSpec : BaseServiceSpec {
  
  var attributeRequestConstructor: AttributeRequestConstructorMock?
  
  var mockedService : AttributeServiceMock?
 
  override func spec() {
    
    super.spec()
    
    describe("AttributeService") {
      self.setupVariables()
      self.checkGetPremiumInfoDetails(true)
      self.checkGetPremiumInfoDetails(false)
    }
  }
  
   func setupVariables() {
    if let accessToken = Mocker.tokenResponseModel.tokenData?.access_token {
      self.attributeRequestConstructor = AttributeRequestConstructorMock(accessToken: accessToken)
    } else {
      self.attributeRequestConstructor = nil
    }

    self.mockedService = AttributeServiceMock(tokenResponse: Mocker.tokenResponseModel)
  
  }
  
  func checkGetPremiumInfoDetails(isExpectingError: Bool) {
    
    let requestConstructor = createMockAttributeRequest()
    let mockService = createMockService(requestConstructor)
    
    if(!isExpectingError) {
      mockService?.response = Mocker.attributeResponseModel
      mockService?.error = nil
    } else {
      mockService?.response = nil
      mockService?.error = MCErrorCode.NilParameter.error
    }
    requestConstructor?.getPremiumInfoMethodAccessed = false
    
    waitUntil { (done:() -> Void) in
      mockService?.getAttributeInformation({ (responseModel, error) in
        
        it("should call request contructor", closure: {
          if let request = mockService?.requestConstructor as? AttributeRequestConstructorMock {
            expect(request.getPremiumInfoMethodAccessed).to(beTrue())
          }
        })
        
        it("has response", closure: {
          if(isExpectingError) {
            expect(error).toNot(beNil())
          } else {
            expect(responseModel).toNot(beNil())
          }
          
        })
        
        done()

      })
    }
  }

  func createMockService(attributeRequest: AttributeRequestConstructorMock?) -> AttributeServiceMock? {
    return AttributeServiceMock(tokenResponse: Mocker.tokenResponseModel)
  }
  
  func createMockAttributeRequest() -> AttributeRequestConstructorMock? {
    if let accessToken = Mocker.tokenResponseModel.tokenData?.access_token {
      return AttributeRequestConstructorMock(accessToken: accessToken)
    } else {
      return nil
    }
  }
  
}