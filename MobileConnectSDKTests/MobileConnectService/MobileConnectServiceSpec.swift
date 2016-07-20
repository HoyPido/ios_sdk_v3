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
            //self.noWebController()
            //self.checkRedirect()
            //self.checkAuthorizationToken()
            //self.checkAuthenticationToken()
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
    
    func checkRedirect()
    {
//        describe("catching redirect") {
//            
//            context("error redirect", closure: {
//                
//                waitUntil(action: { (done : () -> Void) in
//                    
//                    let service : MobileConnectServiceMock = self.mockedService
//                    service.codeResponse = Mocker.errorRedirect
//                    
//                    print("before calling method")
//                    
//                    service.getAuthenticationTokenInController(self.viewController, completionHandler: { (controller, tokenModel, error) in
//                        
//                        print("after calling method")
//                        it("has error", closure: {
//                            
//                            print("inside it method")
//                            expect(error).toNot(beNil())
//                        })
//                        
//                        done()
//                    })
//                    
//                })
        
//                self.checkServiceForRedirect(service, redirectModel: Mocker.errorRedirect, action: service.getAuthenticationTokenInController, withExpectationHandler: { (tokenModel, error) in
//                    it("has error", closure: {
//                        expect(error).toNot(beNil())
//                    })
//                })
            //})
            
//            context("correct redirect", closure: {
//                
//                
//                
//            })
        //}
    }
    
    func checkServiceForRedirect(service : MobileConnectServiceMock, redirectModel : [NSObject : AnyObject], action : (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void, withExpectationHandler expectationHandler : (tokenModel : TokenModel?, error : NSError?) -> Void)
    {
        service.codeResponse = Mocker.errorRedirect
        
        self.checkService(action, withExpectationHandler: expectationHandler)
    }
    
    func checkService(action : (controller: UIViewController, completionHandler: MobileConnectControllerResponse) -> Void, withExpectationHandler expectationHandler : (tokenModel : TokenModel?, error : NSError?) -> Void)
    {
        waitUntil { (done : () -> Void) in
            
            action(controller: self.viewController, completionHandler: { (controller, tokenModel, error) in
                
                expectationHandler(tokenModel: tokenModel, error: error)
                
                done()
            })
        }
    }
    
    func checkAuthorizationToken()
    {
        describe("getting authorization token") { 
            
            let service : MobileConnectServiceMock = self.mockedService
            service.response = Mocker.tokenResponseModel.tokenData
            
        }
        
        //check request constructor in completion handler
        checkTokenWithActionWithRequestConstructor()
    }
    
    func checkAuthenticationToken()
    {
        describe("getting authentication token") {
            
            let service : MobileConnectServiceMock = self.mockedService
            service.response = Mocker.tokenResponseModel.tokenData
            
            waitUntil(action: { (done : () -> Void) in
                
                service.getAuthenticationTokenInController(self.viewController, completionHandler:
                {
                    (controller, tokenModel, error) in
                    
                    it("should have called request constructor authentication request", closure: {
                        expect(self.requestConstructor.authenticationRequestAccessed).to(beTrue())
                    })
                    
                    it("should have a response", closure: { 
                        expect(tokenModel).toNot(beNil())
                    })
                    
                    //will it call error handler if error model sent?
                    //will it call response handler if correct model sent?
                    it("should have presented web controller", closure: {
                        expect(service.hasPresentedWebController).to(beTrue())
                    })
                    
                    it("should have called request for token", closure: { 
                        expect(service.hasCalledRequestForToken).to(beTrue())
                    })
                    
                    done()
                })
            })
        }
        
        //check request constructor in completion handler
        checkTokenWithActionWithRequestConstructor()
    }
    
    func checkTokenWithActionWithRequestConstructor()
    {
        //check if nil response + error
        //check if response
        //check redirect flag
        self.checkRedirect()
    }
    
    func noWebController()
    {
        context("has nil web controller") {
            
            let mobileConnect : MobileConnectServiceMock = self.mockedService
            
            mobileConnect.webController = nil
            mobileConnect.shouldCallSuper = true
            
            waitUntil(action: { (done : () -> Void) in
                
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
}
