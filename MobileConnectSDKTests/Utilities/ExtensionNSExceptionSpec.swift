//
//  ExtensionNSExceptionSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 31/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import MobileConnectSDK

class ExtensionNSExceptionSpec : QuickSpec {
    
    override func spec() {
        context("check NSException extension not to throw exception", closure : {
            NSException.checkController(UIViewController())
            NSException.checkParameters([], withErrorMessage: "aa", exceptionName: "dd")
            NSException.checkAuthorizationProperty("a", withErrorName: "a", andErrorMessage: "a")
        })
        
    }
    
}