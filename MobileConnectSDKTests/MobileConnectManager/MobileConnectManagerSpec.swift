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
import MobileConnectSDK

class MobileConnectManagerSpec : QuickSpec
{
    override func spec() {
        
        MobileConnectSDK.setClientKey(kClientKey)
        MobileConnectSDK.setClientSecret(kClientSecret)
        MobileConnectSDK.setRedirect(kRedirectURL)
        MobileConnectSDK.setApplicationEndpoint(kApplicationEndpoint)
        
        describe("mobile connect manager") {
            
            let mockDelegate : MobileConnectManagerDelegateMock = MobileConnectManagerDelegateMock()
            let discoveryService : DiscoveryServiceMock = DiscoveryServiceMock()
            
            let manager : MobileConnectManagerMock = MobileConnectManagerMock(delegate: mockDelegate, discoveryService: discoveryService)
            
            let viewController : UIViewController = UIViewController()
            
            describe("when gets token without client details", closure: {
                
                discoveryService.response = nil
                discoveryService.error = nil
                mockDelegate.error = nil
                mockDelegate.response = nil
                
                //user cancelled action or discovery returns error use case
                context("user cancelled action", closure: {
                    
                    mockDelegate.resetFlags()
                    
                    discoveryService.error = MCErrorCode.UserCancelled.error
                    
                    manager.getTokenInPresenterController(viewController, withCompletionHandler:
                    { (tokenResponseModel, error) in
                        
                        self.tryResponse(tokenResponseModel, error: error, withDiscoveryService: discoveryService, mockDelegate: mockDelegate)
                    })
                })
            })
        }
    }
    
    func tryResponse(tokenResponseModel : TokenResponseModel?, error : NSError?, withDiscoveryService discoveryService : DiscoveryServiceMock, mockDelegate : MobileConnectManagerDelegateMock)
    {
        it("has a nil response model", closure: {
            expect(tokenResponseModel).to(beNil())
        })
        
        it("has the same error as the one set in mock", closure: {
            expect(error).to(be(discoveryService.error))
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
            expect(mockDelegate.error).to(be(discoveryService.error))
        })

    }
}