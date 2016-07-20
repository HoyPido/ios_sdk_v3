//
//  MobileConnectManagerSpec.swift
//  MobileConnectSDK
//
//  Created by jenkins on 26/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import MobileConnectSDK

class MobileConnectManagerSpec : QuickSpec
{
    //MARK: iVars
    lazy var discoveryService : DiscoveryServiceMock = {
        MobileConnectSDK.setClientKey(kClientKey)
        MobileConnectSDK.setClientSecret(kClientSecret)
        MobileConnectSDK.setRedirect(kRedirectURL)
        MobileConnectSDK.setApplicationEndpoint(kApplicationEndpoint)
        
        return DiscoveryServiceMock()
    }()
    
    let mockDelegate : MobileConnectManagerDelegateMock = MobileConnectManagerDelegateMock()
    var manager : MobileConnectManagerMock!
    let viewController : UIViewController = UIViewController()
    
    //MARK: Quick template functions
    override func spec() {
        
        manager = MobileConnectManagerMock(delegate: mockDelegate, discoveryService: discoveryService)
    
        startTesting()
    }
    
    func startTesting()
    {
        describe("mobile connect manager")
        {
            describe("gets token without client details")
            {
                self.startTesting(){ (completionHandler) in
                    
                    self.manager.getTokenInPresenterController(self.viewController, withCompletionHandler: completionHandler)
                }
            }
            
            describe("gets token with phone number", closure: {
                self.startTesting(){ (completionHandler) in
                    
                    self.manager.getTokenForPhoneNumber("", inPresenterController: self.viewController, withCompletionHandler: completionHandler)
                }
            })
             
            describe("gets authorization token without client details", closure: { 
                
                self.startTesting(true){ (completionHandler) in
                    
                    self.manager.getAuthorizationTokenInPresenterController(self.viewController, withContext: "asdasd", scopes: [OpenIdProductType.Address], bindingMessage: "test", completionHandler: completionHandler)
                }
                
            })
            
            describe("gets authorization token with phone number", closure: { 
                
                self.startTesting(true){ (completionHandler) in
                    
                    self.manager.getAuthorizationTokenForPhoneNumber("", inPresenterController: self.viewController, withScopes: [OpenIdProductType.Address], context: "test", bindingMessage: nil, completionHandler: completionHandler)
                }
                
            })
        }
    }
    
    func startTesting(isAuthorization : Bool = false ,action : (completionHandler : (tokenResponseModel : TokenResponseModel?, error : NSError?) -> Void) -> Void)
    {
        context("is called before finishing", closure: {
            
            self.resetBeforeEach(isAuthorization)
            
            self.discoveryService.error = MCErrorCode.Unknown.error
            self.discoveryService.withDelay = true
            
            action(completionHandler: { (tokenResponseModel, error) in
                
            })
            
            action(completionHandler: { (tokenResponseModel, error) in
                it("has concurrency error", closure: {
                    expect(error?.code).to(be(MCErrorCode.Concurrency.error.code))
                })
            })
        })
        //-----------------
        //user cancelled action or discovery returns error use case
        context("user cancelled action", closure: {
            
            waitUntil(action: { (done : () -> Void) in
                
                self.resetBeforeEach(isAuthorization)
                self.discoveryService.error = MCErrorCode.UserCancelled.error
                
                action(completionHandler: { (tokenResponseModel, error) in
                    
                    self.tryResponse(tokenResponseModel, expectedResponseModel: nil, error: error, withExpectedError: self.discoveryService.error, mockDelegate: self.mockDelegate)
                    
                    done()
                })
            })
        })
        
        //-----------------
        context("good discovery and bad mobile connect response", closure:
            {
                waitUntil(action: { (done : () -> Void) in
                    
                    self.resetBeforeEach(isAuthorization)
                    self.discoveryService.response = Mocker.discoveryResponse
                    self.manager.error = MCErrorCode.Unknown.error
                    
                    action(completionHandler: { (tokenResponseModel, error) in
                        self.tryResponse(tokenResponseModel, expectedResponseModel: nil, error: error, withExpectedError: self.manager.error, mockDelegate: self.mockDelegate)
                        
                        done()
                    })
                })
        })
        
        //-------------------
        context("good discovery and mobile connect response", closure: {
            
            waitUntil(action: { (done : () -> Void) in
                
                self.resetBeforeEach(isAuthorization)
                self.discoveryService.response = Mocker.discoveryResponse
                
                action(completionHandler: { (tokenResponseModel, error) in
                    
                    self.tryResponse(tokenResponseModel, expectedResponseModel: Mocker.tokenResponseModel, error: error, withExpectedError: nil, mockDelegate: self.mockDelegate)
                    
                    done()
                })
            })
        })
    }
    
    //MARK: Helpers
    func tryResponse(tokenResponseModel : TokenResponseModel?, expectedResponseModel : TokenResponseModel?, error : NSError?, withExpectedError expectedError : NSError?, mockDelegate : MobileConnectManagerDelegateMock?)
    {
        itBehavesLike(kNameDefaultMobileConnectManagerConfiguration) { () -> (NSDictionary) in
            
            let dictionary : NSMutableDictionary = NSMutableDictionary()
            
            if let response = tokenResponseModel
            {
                dictionary[kKeyTokenResponse] = response
            }
            
            if let error = error
            {
                dictionary[kKeyError] = error
            }
            
            if let expectedError = expectedError
            {
                dictionary[kKeyExpectedError] = expectedError
            }
            
            if let mockDelegate = mockDelegate
            {
                dictionary[kKeyMockDelegate] = mockDelegate
            }
            
            if let expectedResponseModel  = expectedResponseModel
            {
                dictionary[kKeyExpectedResponse] = expectedResponseModel
            }
            
            return dictionary.copy() as! NSDictionary
        }
    }
    
    func resetBeforeEach(isAuthorization : Bool = false)
    {
        mockDelegate.resetFlags()
        
        discoveryService.withDelay = false
        discoveryService.response = nil
        discoveryService.error = nil
        mockDelegate.error = nil
        mockDelegate.response = nil
        manager.error = nil
        manager.context = nil
        manager.context = nil
        manager.bindingMessage = nil
        
        if isAuthorization
        {
            manager.context = "asdad"
            manager.scopes = [OpenIdProductType.Address]
            manager.bindingMessage = "asdas"
        }
    }
}