//
//  WebControllerMock.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 06/07/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

@testable import MobileConnectSDK

class WebControllerMock: WebController {

    var redirectURLMockValue : NSURL?
    
    override func viewDidAppear(animated: Bool) {
        
        if let url = redirectURLMockValue
        {
            delegate?.webController(self, shouldRedirectToURL: url)
        }
        else
        {
            super.viewDidAppear(animated)
        }
    }
}
