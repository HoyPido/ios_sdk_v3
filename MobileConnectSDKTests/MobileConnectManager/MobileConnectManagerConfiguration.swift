//
//  MobileConnectManagerConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 04/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

let kNameDefaultMobileConnectManagerConfiguration : String = "MCManager"

let kKeyTokenResponse : String = "tokenResponse"
let kKeyError : String = "error"
let kKeyExpectedError : String = "expectedError"
let kKeyMockDelegate : String = "mockDelegate"
let kKeyExpectedResponse : String = "expectedTokenResponse"

class MobileConnectManagerConfiguration: QuickConfiguration {
    
    override class func configure(configuration : Configuration)
    {
        sharedExamples(kNameDefaultMobileConnectManagerConfiguration) { (sharedExampleContext : SharedExampleContext) in
            
            let tokenResponseModel : TokenResponseModel? = sharedExampleContext()[kKeyTokenResponse] as? TokenResponseModel
            let error : NSError? = sharedExampleContext()[kKeyError] as? NSError
            let expectedError : NSError? = sharedExampleContext()[kKeyExpectedError] as? NSError
            let mockDelegate : MobileConnectManagerDelegateMock? = sharedExampleContext()[kKeyMockDelegate] as? MobileConnectManagerDelegateMock
            let expectedTokenResponseModel : TokenResponseModel? = sharedExampleContext()[kKeyExpectedResponse] as? TokenResponseModel

            if let delegate = mockDelegate
            {
                describe("response in delegate", closure: { 
                    it("called will start on delegate", closure: {
                        expect(delegate.mobileConnectWillStartWasCalled).to(beTrue())
                    })
                    
                    it("called will present on delegate", closure: {
                        expect(delegate.mobileConnectWillPresentWebControllerWasCalled).to(beTrue())
                    })
                    
                    it("called will dismiss on delegate", closure: {
                        expect(delegate.mobileConnectWillDismissWebControllerWasCalled).to(beTrue())
                    })
                    
                    checkBothError(delegate.error, expectedError: expectedError, response: delegate.response, expectedResponse: expectedTokenResponseModel)
                })
            }
            
            describe("response from callback", closure: { 
                checkBothError(error, expectedError: expectedError, response: tokenResponseModel, expectedResponse: expectedTokenResponseModel)
            })
        }
    }
    
    class private func checkBothError(error : NSError?, expectedError : NSError?, response : TokenResponseModel?, expectedResponse : TokenResponseModel?)
    {
        if let expectedResponse = expectedResponse
        {
            it("has a valid response model", closure: {
                expect(response).to(be(expectedResponse))
            })
        }
        else
        {
            it("has no response", closure: {
                expect(response).to(beNil())
            })
        }
        
        if let expectedError = expectedError
        {
            it("has a valid error", closure: { 
                expect(error).to(be(expectedError))
            })
        }
        else
        {
            it("has no error", closure: { 
                expect(error).to(beNil())
            })
        }
    }
}
