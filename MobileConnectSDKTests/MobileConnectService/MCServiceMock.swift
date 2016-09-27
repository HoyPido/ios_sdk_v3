//
//  MCServiceMock.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 30/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

@testable import MobileConnectSDK

class MCServiceMock : MobileConnectService {
    
    var getAuthenticationTokenIsCalled = false
    var getAuthorizationTokenIsCalled = false
    
    override func getAuthenticationTokenInController(controller : UIViewController, completionHandler : MobileConnectControllerResponse) {
        getAuthenticationTokenIsCalled = true
        completionHandler(controller: nil, tokenModel: nil, error: nil)
    }
    
    override func getAuthorizationTokenInController(controller : UIViewController, completionHandler : MobileConnectControllerResponse) {
        getAuthorizationTokenIsCalled = true
        completionHandler(controller: nil, tokenModel: nil, error: nil)
    }
    
}