//
//  MobileConnectManagerDelegateMock.swift
//  MobileConnectSDK
//
//  Created by jenkins on 26/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

import Quick
import Nimble

@testable import MobileConnectSDK

class MobileConnectManagerDelegateMock: NSObject, MobileConnectManagerDelegate {
    
    var mobileConnectWillStartWasCalled : Bool = false
    var mobileConnectWillDismissWebControllerWasCalled : Bool = false
    var mobileConnectWillPresentWebControllerWasCalled : Bool = false
    var mobileConnectFailedGettingTokenResponseWasCalled : Bool = false
    var mobileConnectDidGetTokenResponseWasCalled : Bool = false
    
    var error : NSError?
    var response : TokenResponseModel?
    
    func mobileConnectWillStart() {
         mobileConnectWillStartWasCalled = true
    }
    
    func mobileConnectWillDismissWebController() {
         mobileConnectWillDismissWebControllerWasCalled = true
    }
    
    func mobileConnectWillPresentWebController() {
         mobileConnectWillPresentWebControllerWasCalled = true
    }
    
    func mobileConnectFailedGettingTokenResponseWithError(error: NSError) {
         mobileConnectFailedGettingTokenResponseWasCalled = true
         self.error = error
    }
    
    func mobileConnectDidGetTokenResponse(tokenResponse: TokenResponseModel) {
         mobileConnectDidGetTokenResponseWasCalled = true
         self.response = tokenResponse
    }
    
    func resetFlags()
    {
        mobileConnectDidGetTokenResponseWasCalled = false
        mobileConnectWillDismissWebControllerWasCalled = false
        mobileConnectWillPresentWebControllerWasCalled = false
        mobileConnectFailedGettingTokenResponseWasCalled = false
        mobileConnectDidGetTokenResponseWasCalled = false
    }
}
