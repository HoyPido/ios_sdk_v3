//
//  JWTDecoderSpec.swift
//  MobileConnectSDK
//
//  Created by jenkins on 15/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

import Foundation
import Quick
import Nimble

private let kTestToken : String = "aa.eyJpc3MiOiJodHRwczpcL1wvcmVmZXJlbmNlLm1vYmlsZWNvbm5lY3QuaW9cL21vYmlsZWNvbm5lY3QiLCJzdWIiOiIxNThFNUJBMS1FRDYxLTc2RUQtRDdFMC1DMDg2MjlDRDQwMUMiLCJhdWQiOlsieC1aV1JoTmpVM09XSTNNR0l3WVRSaCJdLCJleHAiOjE0Njg1Nzk3MTksImlhdCI6MTQ2ODU3OTQxOSwibm9uY2UiOiJCMEEzNDI5Q0I4NEY0MEJFQTM5RUQxRkJFRTlBMjk1MyIsImF0X2hhc2giOiI5QU1CV1NEckQyem5LU0c4ekNBdVFRIiwiYXV0aF90aW1lIjoxNDY4NTc5NDE5LCJhY3IiOiIyIiwiYW1yIjpbIlNJTV9QSU4iXSwiZGlzcGxheWVkX2RhdGEiOiJ0ZXN0MS0tYXNkYXMiLCJhenAiOiJ4LVpXUmhOalUzT1dJM01HSXdZVFJoIn0.aa"

private let kTestConfigurationName : String = "JWTConfiguration"
private let kTestConfigurationKeyDecoder : String = "decoder"
private let kTestConfigurationKeyHasResult : String = "hasResult"

@testable import MobileConnectSDK

class JWTDecoderSpec: QuickSpec {
    
    override func spec() {
        
        describe("JWTDecoder") { 
            
            context("empty test token", closure: {
                
                self.testWithDecoder(JWTDecoder(tokenString: ""), hasResult: false)
            })
            
            context("invalid token", closure: { 
                
                self.testWithDecoder(JWTDecoder(tokenString: "aa"), hasResult: false)
            })
            
            context("valid token", closure: { 
                self.testWithDecoder(JWTDecoder(tokenString: kTestToken), hasResult: true)
            })
        }
    }
    
    func testWithDecoder(decoder : JWTDecoder, hasResult : Bool)
    {
        itBehavesLike(kTestConfigurationName) { () -> (NSDictionary) in
            
            var dictionary : [NSObject : AnyObject] = [:]
            
            dictionary[kTestConfigurationKeyDecoder] = decoder
            dictionary[kTestConfigurationKeyHasResult] = hasResult
            
            return dictionary
        }
    }
}

class JWTConfiguration : QuickConfiguration
{
    override class func configure(configuration : Configuration)
    {
        sharedExamples(kTestConfigurationName) { (context : SharedExampleContext) in
            
            let decoder : JWTDecoder? = context()[kTestConfigurationKeyDecoder] as? JWTDecoder
            
            let hasResult : Bool? = context()[kTestConfigurationKeyHasResult] as? Bool
            
            if let decoder = decoder, hasResult = hasResult
            {
                if hasResult
                {
                    it("has data value and dictionary", closure: {
                        expect(decoder.decodedValue).toNot(beNil())
                        expect(decoder.decodedDictionary).toNot(beNil())
                    })
                }
                else
                {
                    it("has nil data value and dictionary", closure: {
                        expect(decoder.decodedValue).to(beNil())
                        expect(decoder.decodedDictionary).to(beNil())
                    })
                }
            }
        }
    }
}
