//
//  BaseServiceSpec.swift
//  MobileConnectSDK
//
//  Created by jenkins on 15/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class BaseServiceSpec: QuickSpec {
    
    lazy var viewController : UIViewController = {
        
        let tmpController : UIViewController = UIViewController()
        
        tmpController.beginAppearanceTransition(true, animated: false)
        
        return tmpController
    }()
    
    //let viewController : UIViewController = UIViewController()
    
    let webControllerMock : WebControllerMock = WebControllerMock()
    
    override func spec() {
        
        initConfig()
        
        
    }
    
    func initConfig()
    {
        MobileConnectSDK.setClientKey(kClientKey)
        MobileConnectSDK.setClientSecret(kClientSecret)
        MobileConnectSDK.setRedirect(kRedirectURL)
        MobileConnectSDK.setApplicationEndpoint(kApplicationEndpoint)
    }
}