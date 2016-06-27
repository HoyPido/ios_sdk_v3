//
//  DiscoveryServiceMock.swift
//  MobileConnectSDK
//
//  Created by jenkins on 26/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class DiscoveryServiceMock: DiscoveryService {
    
    var response : DiscoveryResponse?
    var error : NSError?
    
    var withDelay : Bool = false
    
    override func startOperatorDiscoveryInController(controller: UIViewController, completitionHandler: DiscoveryResponseBlock)
    {
        callHandlerWithDelay {
            completitionHandler(controller: self.webController, operatorsData: self.response, error: self.error)
        }
    }
    
    override func startOperatorDiscoveryForPhoneNumber(phoneNumber: String, completitionHandler: DiscoveryDataResponse)
    {
        callHandlerWithDelay {
            completitionHandler(operatorsData: self.response, error: self.error)
        }
    }
    
    func callHandlerWithDelay(handelr : () -> Void)
    {
        if withDelay
        {
            NSThread.sleepForTimeInterval(2)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            handelr()
        }
    }
}
