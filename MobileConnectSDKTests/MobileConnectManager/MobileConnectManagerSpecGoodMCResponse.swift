//
//  MobileConnectManagerSpecGoodMCResponse.swift
//  MobileConnectSDK
//
//  Created by jenkins on 27/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class MobileConnectManagerSpecGoodMCResponse: QuickSpec {
    
    override func spec() {
        
        MobileConnectSDK.setClientKey(kClientKey)
        MobileConnectSDK.setClientSecret(kClientSecret)
        MobileConnectSDK.setRedirect(kRedirectURL)
        MobileConnectSDK.setApplicationEndpoint(kApplicationEndpoint)
        
        describe("mobile connect manager") {
            
            let mockDelegate : MobileConnectManagerDelegateMock = MobileConnectManagerDelegateMock()
            let discoveryService : DiscoveryServiceMock = DiscoveryServiceMock()
            
            let manager : MobileConnectManagerMock = MobileConnectManagerMock(delegate: mockDelegate, discoveryService: discoveryService)
            
            describe("when gets token without client details", closure: {
                
                let viewController : UIViewController = UIViewController()
                
                discoveryService.response = nil
                discoveryService.error = nil
                mockDelegate.error = nil
                mockDelegate.response = nil
                
                //good disc response && bad mobile connect response
                context("good discovery and mobile connect response", closure: {
                    
                    mockDelegate.resetFlags()
                    discoveryService.response = Mocker.discoveryResponse
                    manager.willProvideGoodMobileConnectResponse = true
                    
                    manager.getTokenInPresenterController(viewController, withCompletionHandler: { (tokenResponseModel, error) in
                        
                        it("has a valid response model", closure: {
                            expect(tokenResponseModel).toNot(beNil())
                        })
                        
                        it("did not receive an error", closure: {
                            expect(error).to(beNil())
                        })
                        
                        it("called will start on delegate", closure: {
                            expect(mockDelegate.mobileConnectWillStartWasCalled).to(beTrue())
                        })
                        
                        it("called will present on delegate", closure: {
                            expect(mockDelegate.mobileConnectWillPresentWebControllerWasCalled).to(beTrue())
                        })
                        
                        it("called will dismiss on delegate", closure: {
                            expect(mockDelegate.mobileConnectWillDismissWebControllerWasCalled).to(beTrue())
                        })
                        
                        it("did not call did fail on delegate", closure: {
                            expect(mockDelegate.mobileConnectFailedGettingTokenResponseWasCalled).toNot(beTrue())
                        })
                        
                        it("passed the valid model to the delegate", closure: { 
                            expect(mockDelegate.response).toNot(beNil())
                        })
                        
                        it("did not pass an error to the delegate", closure: {
                            expect(mockDelegate.error).to(beNil())
                        })
                    })
                })
            })
        }
    }
    
}
