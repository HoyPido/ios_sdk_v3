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
      self.checkObjectInititalization()
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
    
  func checkObjectInititalization() {
    context("check service", closure: {
        let tokenResponseModel = Mocker.tokenResponseModel
        it("expect not nil object", closure: {
            tokenResponseModel.tokenData = nil
            expect(AttributeService(tokenResponse: tokenResponseModel)).toNot(beNil())
        })
        Mocker.resetModels()
    })
  }
  
  func checkGetPremiumInfoDetails(isExpectingError: Bool) {
    
    context("get premium info details ", closure: {
        
        let requestConstructor = self.createMockAttributeRequest()
        var connectService = BaseMobileConnectServiceRequestMock()
        
        let mockService = AttributeServiceMock(connectService: connectService, requestConstructor: requestConstructor!, tokenResponse: Mocker.tokenResponseModel)
        
        if(!isExpectingError) {
            connectService.response = Mocker.attributeResponseModel
            connectService.error = nil
        } else {
            connectService.response = nil
            connectService.error = MCErrorCode.NilParameter.error
        }
        
        waitUntil { (done:() -> Void) in
            
            mockService.getAttributeInformation( { (responseModel, error) in
                
                it("should call request contructor", closure: {
                    if let request = mockService.requestConstructor as? AttributeRequestConstructorMock {
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
    })
  }
  
  func createMockAttributeRequest() -> AttributeRequestConstructorMock? {
    if let accessToken = Mocker.tokenResponseModel.tokenData?.access_token {
      return AttributeRequestConstructorMock(accessToken: accessToken)
    } else {
      return nil
    }
  }
  
}