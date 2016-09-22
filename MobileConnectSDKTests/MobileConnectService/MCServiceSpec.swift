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
        checkIsLoginHintSupported(true)
        checkIsLoginHintSupported(false)
        checkLoginHint(withMetadata: true)
        checkLoginHint(withMetadata: false)
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
    
    func checkIsLoginHintSupported(isTrue : Bool) {
        
        var checkBoolMethod : ()->NonNilMatcherFunc<Bool>
        var config = Mocker.mobileConnectConfigurationWithMetadata
        
        if(isTrue) {
            checkBoolMethod = beTrue
        } else {
            checkBoolMethod = beFalse
            config = Mocker.mobileConnectConfiguration
        }
    
        if config is MCAuthorizationConfiguration {
            if let config = config as? MCAuthorizationConfiguration {
                context("check if login hint supports PCR") {
                    it("expect to be true", closure: {
                        expect(config.isLoginHintPCRSupported()).to(checkBoolMethod())
                    })
                }
                
                context("check if login hint supports MSISDN") {
                    it("expect to be true", closure: {
                        expect(config.isLoginHintMSISDNSupported()).to(checkBoolMethod())
                        
                    })
                }
                
                context("check if login hint supports encrypted MSISDN") {
                    it("expect to be true", closure: {
                        expect(config.isLoginHintEncryptedMSISDNSupported()).to(checkBoolMethod())
                    })
                }
                
            }
        }
        
    }
    
    func checkLoginHint(withMetadata flag : Bool) {
        
        var mockService : MobileConnectService
        var expectMessageString : String
        var checkBoolMethod : ()->NonNilMatcherFunc<Bool>
        
        if(flag) {
            expectMessageString = "expect to be true"
            checkBoolMethod = beTrue
            mockService = MCServiceMock(configuration: Mocker.mobileConnectConfigurationWithMetadata)
        } else {
            expectMessageString = "expect to be false"
            checkBoolMethod = beFalse
            mockService = MCServiceMock(configuration: Mocker.mobileConnectConfiguration)
        }
        
        context("check if login hint supports PCR") {
            it(expectMessageString, closure: {
                expect(mockService.requestConstructor.checkLoginHint("PCR")).to(checkBoolMethod())
            })
        }
        
        context("check if login hint supports MSISDN") {
            it(expectMessageString, closure: {
                expect(mockService.requestConstructor.checkLoginHint("MSISDN")).to(checkBoolMethod())
            })
        }
        
        context("check if login hint supports ENCR_MSISDN") {
            it(expectMessageString, closure: {
                expect(mockService.requestConstructor.checkLoginHint("ENCR_MSISDN")).to(checkBoolMethod())
            })
        }

    }
    
}