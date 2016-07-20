//
//  MCRequestConstructorMock.swift
//  MobileConnectSDK
//
//  Created by jenkins on 19/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Nimble
import Quick
import Alamofire

@testable import MobileConnectSDK

class MCRequestConstructorMock: MCRequestConstructor {

    var authenticationRequestAccessed : Bool = false
    var authorizationRequestAccessed : Bool = false
    var tokenRequestAtURLAccessed : Bool = false
    
    override var authenticationRequest: Request
    {
        authorizationRequestAccessed = true
        
        return super.authenticationRequest
    }
    
    override var authorizationRequest: Request?
    {
        authorizationRequestAccessed = true
        
        return super.authorizationRequest
    }
    
    override func tokenRequestAtURL(url: String, withCode code: String) -> Request {
        
        tokenRequestAtURLAccessed = true
        
        return super.tokenRequestAtURL(url, withCode: code)
    }
}
