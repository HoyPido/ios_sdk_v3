//
//  JWTErrorCodeSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 31/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

import Foundation
import Quick
import Nimble

@testable import MobileConnectSDK

class JWTErrorCodeSpec: QuickSpec {
    override func spec() {
        describe("JWTErrorCode") {
            context("check error", closure: {
                it("expect not to be nil", closure: {
                    expect(self.checkJWTErrorCode(0)).notTo(beNil())
                })
                it("expect to be nil", closure: {
                    expect(self.checkJWTErrorCode(-1)).to(beNil())
                })
            })
        }
    }
    
    func checkJWTErrorCode(index : Int) -> NSError? {
        let error = JWTErrorCode.init(rawValue: index)
        return error?.error
    }
    
}