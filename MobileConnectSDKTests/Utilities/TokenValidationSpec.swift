//
//  TokenValidationSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 24/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Quick
import Nimble

private let configurationName : String = "TokenValidationConfiguration"

class TokenValidationSpec : QuickSpec {
    
}

class TokenValidationConfiguration : QuickConfiguration {
    override class func configure(configuration : Configuration)
    {
        sharedExamples(configurationName) { (context : SharedExampleContext) in
            
        }
    }
}