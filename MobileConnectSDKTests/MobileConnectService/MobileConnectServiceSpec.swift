//
//  MobileConnectServiceSpec.swift
//  MobileConnectSDK
//
//  Created by jenkins on 19/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class MobileConnectServiceSpec: BaseServiceSpec {
    
    lazy var requestConstructor : MCRequestConstructorMock = {
        return MCRequestConstructorMock(configuration: Mocker.mobileConnectConfiguration , scopeValidator: ScopeValidator(metadata: Mocker.metadata))
    }()
    
    var mockedService : MobileConnectServiceMock
    {
        let service : MobileConnectServiceMock = MobileConnectServiceMock(configuration: Mocker.mobileConnectConfiguration, requestConstructor: requestConstructor)
        
        service.shouldCallSuper = true
        service.isAwaitingResponse = false
        
        return service
    }
    
    override func spec() {
        super.spec()
        
        describe("MobileConnectService") {
            self.concurrency()
            self.noWebController()
            self.checkProducts()
            self.checkMCRequest()
        }
    }
    
    func checkProducts()
    {
        describe("check authentication", closure: {
            self.checkService { (service) -> (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void in
                return service.getAuthenticationTokenInController
            }
        })
        
        describe("check authorization", closure: {
            self.checkService { (service) -> (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void in
                return service.getAuthorizationTokenInController
            }
        })
    }
    
    func checkService(serviceHandler : (service : MobileConnectServiceMock) -> (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void)
    {
        //check for error if redirect returned error
        describe("has error on redirect") {
            
            self.checkService(
                {
                    (service) -> (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void in
                    
                    service.codeResponse = Mocker.errorRedirect
                    
                    return serviceHandler(service: service)
                    
                })
            {
                (tokenModel, error) in
                
                it("has error", closure: {
                    expect(error).toNot(beNil())
                })
            }
        }
        
        describe("has error on redirect success but failed token") {
            
            self.checkService(
                {
                    (service) -> (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void in
                    
                    service.codeResponse = Mocker.authenticationCodeResponse
                    service.error = MCErrorCode.Unknown.error
                    
                    return serviceHandler(service: service)
                    
                })
            {
                (tokenModel, error) in
                
                it("has error", closure: {
                    expect(error).toNot(beNil())
                })
            }
        }
        
        describe("has result on redirect and response success") {
            
            self.checkService(
                {
                    (service) -> (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void in
                    
                    service.codeResponse = Mocker.authenticationCodeResponse
                    let tokenModel = Mocker.tokenResponseModel
                    service.response = tokenModel.tokenData
                    
                    return serviceHandler(service: service)
                })
            {
                (tokenModel, error) in
                
                it("has successfully redirected", closure: {
                    expect(tokenModel).toNot(beNil())
                })
            }
        }
    }
    
    func checkService(creationHandler : (service : MobileConnectServiceMock) -> (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void, expectationHandler : (tokenModel : TokenModel?, error : NSError?) -> Void)
    {
        waitUntil { (done : () -> Void) in
            
            let service : MobileConnectServiceMock = self.mockedService
            
            creationHandler(service: service)(controller: self.viewController, completionHandler : {
                (controller : BaseWebController?, tokenModel : TokenModel?, error : NSError?) -> Void in
                
                expectationHandler(tokenModel: tokenModel, error: error)
                
                done()
            })
        }
    }
    
    func concurrency()
    {
        context("is awaiting response", closure: {
            
            let mobileConnect : MobileConnectServiceMock = self.mockedService
            
            mobileConnect.isAwaitingResponse = true
            mobileConnect.shouldCallSuper = true
            
            waitUntil(action: { (done : () -> Void) in
                
                mobileConnect.getAuthenticationTokenInController(self.viewController, completionHandler:
                    {
                        (controller, tokenModel, error) in
                        
                        it("cant run 2 concurrent requests", closure: {
                            expect(error?.code).to(be(MCErrorCode.Concurrency.error.code))
                        })
                        
                        done()
                })
            })
        })
        
    }
    
    func noWebController()
    {
        context("has nil web controller") {
            
            waitUntil(action: { (done : () -> Void) in
                
                let mobileConnect : MobileConnectServiceMock = self.mockedService
                
                mobileConnect.webController = nil
                mobileConnect.shouldCallSuper = true
                mobileConnect.isAwaitingResponse = false
                mobileConnect.checksForNilWebController = true
                
                mobileConnect.getAuthenticationTokenInController(self.viewController, completionHandler: { (controller, tokenModel, error) in
                    
                    it("not awaiting response", closure: {
                        expect(mobileConnect.isAwaitingResponse).toNot(beTrue())
                    })
                    
                    it("has nil web controller error", closure: {
                        expect(error?.code).to(be(MCErrorCode.WebControllerNil.error.code))
                    })
                    
                    done()
                })
                
            })
        }
    }
    
    func checkMCRequest() {
        let config : AuthorizationConfigurationParameters = AuthorizationConfigurationParameters(version: "1", prompt: "a", uiLocale: "en", idTokenHint: "auth", loginHintToken: "PCR", responseMode: "", claims: "", maxAge: "")
        
        context("check request constructor") {
            it("not to be nil", closure: {
                expect(MCRequestConstructor(configuration: Mocker.mobileConnectConfigurationWithMetadata, scopeValidator: ScopeValidator(metadata: Mocker.metadata)).mobileConnectRequestWithAssuranceLevel(.Level2, subscriberId: "", scopes: [], config: config, url: "www.", clientName: "", context: "a", bindingMessage: "aa", shouldNotStartImmediately: false)).toNot(beNil())
            })
        }
    }
    
}
