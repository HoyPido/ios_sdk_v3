//
//  MobileConnectManagerWrongMCResponse.swift
//  MobileConnectSDK
//
//  Created by jenkins on 27/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class MobileConnectManagerWrongMCResponse: QuickSpec {
    
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
                context("good discovery response and bad mobile connect response", closure: {
                    
                    mockDelegate.resetFlags()
                    discoveryService.response = Mocker.discoveryResponse
                    manager.willProvideGoodMobileConnectResponse = false
                    
                    manager.getTokenInPresenterController(viewController, withCompletionHandler: { (tokenResponseModel, error) in
                        
                        it("has a nil response model", closure: {
                            expect(tokenResponseModel).to(beNil())
                        })
                        
                        it("received an error", closure: {
                            expect(error).notTo(beNil())
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
                        
                        it("called did fail on delegate", closure: {
                            expect(mockDelegate.mobileConnectFailedGettingTokenResponseWasCalled).to(beTrue())
                        })
                        
                        it("passed the error to the delegate", closure: {
                            expect(mockDelegate.error).notTo(beNil())
                        })
                    })
                })
            })
        }
    }
}
