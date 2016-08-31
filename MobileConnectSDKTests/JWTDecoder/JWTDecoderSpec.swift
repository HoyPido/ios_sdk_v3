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

private let kTestToken : String = "eyJhbGciOiJSUzI1NiIsImtpZCI6IlBIUE9QLTAwIn0.eyJpc3MiOiJodHRwczpcL1wvcmVmZXJlbmNlLm1vYmlsZWNvbm5lY3QuaW9cL21vYmlsZWNvbm5lY3QiLCJzdWIiOiIxNThFNUJBMS1FRDYxLTc2RUQtRDdFMC1DMDg2MjlDRDQwMUMiLCJhdWQiOlsieC1aV1JoTmpVM09XSTNNR0l3WVRSaCJdLCJleHAiOjE0NzI1NzU0MTIsImlhdCI6MTQ3MjU3NTExMiwibm9uY2UiOiI3REI1QTE5MjM0NEQ0OTFDQjZGNEJDQjIzODc5NEQ0NSIsImF0X2hhc2giOiJjakc1MUJKcnUtWm5tZXpPVkQ4WGV3IiwiYXV0aF90aW1lIjoxNDcyNTc1MTEyLCJhY3IiOiIyIiwiYW1yIjpbIlNJTV9QSU4iXSwiZGlzcGxheWVkX2RhdGEiOiJ0ZXN0MS0tYmxhYmxhIiwiYXpwIjoieC1aV1JoTmpVM09XSTNNR0l3WVRSaCJ9.udZVdctUDNmh1F6QMShQcDWZmo4yTPnet3-8jVRIkkMUlAmibXR5JOUmDmXs22PYAnG3TWhiturPjS7uJGhr7a_Z7hqDHR1D96nyLT4x8xObCTaH9b63K05nt29GQtJJbqfqgNwaGdqffzM-JKk4Oi157RqyMwtJM731JIMyTX0"

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
            
            context("check message", closure: {
                it("should to be nil", closure:{
                    expect(self.testMessage("")).to(beNil())
                })
                
                it("should not be nil", closure:{
                    expect(self.testMessage(kTestToken)).notTo(beNil())
                })
            })
            
            context("check headerModel", closure: {
                it("should to be nil", closure:{
                    expect(self.testHeaderModel("")).to(beNil())
                })
                
                it("should not be nil", closure:{
                    expect(self.testHeaderModel(kTestToken)).notTo(beNil())
                })
            })
            
            context("check signature", closure: {
                it("should to be nil", closure:{
                    expect(self.testSignature("")).to(beNil())
                })
                
                it("should not be nil", closure:{
                    expect(self.testSignature(kTestToken)).notTo(beNil())
                })
            })
            
            context("check deserialize nullable", closure: {
                it("should to be nil", closure:{
                    expect(self.testDeserializeNullableComponentData(nil)).to(beNil())
                })
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
    
    func testMessage(string : String) -> String? {
        let jwtDecoder: JWTDecoder = JWTDecoder(tokenString: string)
        return jwtDecoder.message
    }
    
    func testDeserializeNullableComponentData(data : NSData?) -> [NSObject : AnyObject]? {
        let jwtDecoder: JWTDecoder = JWTDecoder(tokenString:"")
        return jwtDecoder.deserializeNullableComponentData(data)
    }
    
    func testSignature(string : String) -> String? {
        let jwtDecoder: JWTDecoder = JWTDecoder(tokenString: string)
        return jwtDecoder.signature
    }
    
    func testHeaderModel(string : String) -> TokenIdHeaderModel? {
        let jwtDecoder: JWTDecoder = JWTDecoder(tokenString: string)
        return jwtDecoder.headerModel
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
                        expect(decoder.decodedDictionary).toNot(beNil())
                    })
                }
                else
                {
                    it("has nil data value and dictionary", closure: {
                        expect(decoder.decodedDictionary).to(beNil())
                    })
                }
            }
        }
    }
}
