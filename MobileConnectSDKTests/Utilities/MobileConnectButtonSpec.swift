//
//  MobileConnectButtonSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 31/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import MobileConnectSDK

class MobileConnectButtonSpec : QuickSpec {
    
    override func spec() {
        
        context("check MobileConnectButton", closure : {
            it("expect object not to be nil", closure : {
                expect(MobileConnectButton(type: .System)).notTo(beNil())
                
            })
        })
        
    }
    
}