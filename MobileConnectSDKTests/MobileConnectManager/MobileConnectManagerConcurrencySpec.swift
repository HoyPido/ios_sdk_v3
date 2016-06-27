//
//  MobileConnectManagerConcurrencySpec.swift
//  MobileConnectSDK
//
//  Created by jenkins on 27/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class MobileConnectManagerConcurrencySpec: QuickSpec {
    
    override func spec() {
        MobileConnectSDK.setClientKey(kClientKey)
        MobileConnectSDK.setClientSecret(kClientSecret)
        MobileConnectSDK.setRedirect(kRedirectURL)
        MobileConnectSDK.setApplicationEndpoint(kApplicationEndpoint)
        
        describe("mobile connect manager") {
            
            let mockDelegate : MobileConnectManagerDelegateMock = MobileConnectManagerDelegateMock()
            let discoveryService : DiscoveryServiceMock = DiscoveryServiceMock()
            
            let manager : MobileConnectManager = MobileConnectManagerMock(delegate: mockDelegate, discoveryService: discoveryService)
            
            describe("when gets token without client details", closure: {
                let viewController : UIViewController = UIViewController()
                
                //concurrent call
                context("mobile connect is called again before finishing", closure: {
                    
                    mockDelegate.resetFlags()
                    
                    discoveryService.response = nil
                    discoveryService.error = nil
                    mockDelegate.error = nil
                    mockDelegate.response = nil
                    
                    discoveryService.error = MCErrorCode.Unknown.error
                    discoveryService.withDelay = true
                    
                    manager.getTokenInPresenterController(viewController, withCompletitionHandler: { (tokenResponseModel, error) in
                        
                    })
                    
                    manager.getTokenInPresenterController(viewController, withCompletitionHandler: { (tokenResponseModel, error) in
                        
                        it("has a concurrency error", closure: {
                            expect(error?.code).to(be(MCErrorCode.Concurrency.error.code))
                        })
                        
                        it("has a nil model", closure: {
                            expect(tokenResponseModel).to(beNil())
                        })
                    })
                })

            })
        }
    }
}
