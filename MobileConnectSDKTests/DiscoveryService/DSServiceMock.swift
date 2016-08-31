//
//  DSServiceMock.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 29/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Alamofire

@testable import MobileConnectSDK

class DSServiceMock : DSService {
    
    var response : DiscoveryResponse?
    var error : NSError?
    var metadata : MetadataModel?
    var withDelay : Bool = false
    
    override func startOperatorDiscoveryInController(controller : UIViewController, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryResponseBlock) {
        super.startOperatorDiscoveryInController(controller, shouldProvideMetadata: shouldProvideMetadata, completionHandler: completionHandler)
    }
    
    override func startOperatorDiscoveryWithCountryCode(countryCode : String, networkCode : String, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryDataResponse) {
        super.startOperatorDiscoveryWithCountryCode(countryCode, networkCode: networkCode, shouldProvideMetadata: shouldProvideMetadata, completionHandler: completionHandler)
    }
    
    override func startOperatorDiscoveryForPhoneNumber(phoneNumber : String, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryDataResponse) {
        super.startOperatorDiscoveryForPhoneNumber(phoneNumber, shouldProvideMetadata: shouldProvideMetadata, completionHandler: completionHandler)
    }
}
