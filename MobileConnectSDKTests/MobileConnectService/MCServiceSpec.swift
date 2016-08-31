//
//  MCServiceSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 30/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class MCServiceSpec: BaseServiceSpec {
    
    override func spec() {
        super.spec()
        getTokenInController()
        getAuthorizationTokenInController()
        checkMCServiceObjectInit()
    }
    
    
    func getTokenInController() {
        let mockService = MCServiceMock(configuration: Mocker.mobileConnectConfiguration)
        let service = MCService(service: mockService)
        
        context("check if method is called") {
            waitUntil(timeout:10) { (done:() -> Void) in
                service.getTokenInController(self.viewController) {
                    (controller, tokenModel, error) in
                    it("should call method", closure: {
                        expect(mockService.getAuthenticationTokenIsCalled).to(beTrue())
                    })
                    done()
                }
            }
        }
    }
    
    func getAuthorizationTokenInController() {
        let mockService = MCServiceMock(configuration: Mocker.mobileConnectConfiguration)
        let service = MCService(service: mockService)
        
        context("check if method is called") {
            waitUntil(timeout:10) { (done:() -> Void) in
                service.getAuthorizationTokenInController(self.viewController) {
                    (controller, tokenModel, error) in
                    it("should call method", closure: {
                        expect(mockService.getAuthorizationTokenIsCalled).to(beTrue())
                    })
                    done()
                }
            }
        }
    }
    
    func checkMCServiceObjectInit() {
        context("check MCService object") {
            it("expect not to be nil", closure: {
                expect(MCService(configuration: Mocker.mobileConnectConfiguration)).notTo(beNil())
            })
        }
    }
    
}