//
//  MobileConnectServiceMock.swift
//  MobileConnectSDK
//
//  Created by jenkins on 27/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

@testable import MobileConnectSDK

class MobileConnectServiceMock: MobileConnectService {
    
    var error : NSError?
    var response : TokenModel?
    
    override func getTokenInController(controller: UIViewController, subscriberId: String?, completitionHandler: MobileConnectControllerResponse) {
        completitionHandler(controller: webController, tokenModel: response, error: error)
    }
}
