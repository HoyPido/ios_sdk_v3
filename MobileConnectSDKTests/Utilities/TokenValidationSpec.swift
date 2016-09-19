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

@testable import MobileConnectSDK

private let kTestConfigurationName : String = "TokenValidationConfiguration"
private let kIdTokenDifferentAlgString : String = "eyJraWQiOiJQSFBPUC0wMCIsImFsZyI6IkhTMjU2In0.eyJub25jZSI6IjgzQ0M3MjZENzUxODQ2M0M5RDQ2ODA5NTA5MDhBM0E3Iiwic3ViIjoiNWU0Nzg3ZGI1MjFhNDAzNzBjNWIyMGQ2N2I5MGY3YTgiLCJhbXIiOlsiU0lNX1BJTiJdLCJhdXRoX3RpbWUiOjE0NjY5ODE4MzYsImFjciI6IjIiLCJhenAiOiJhMjVlOTFjNS1hYjFlLTRmOWUtOWZkOS00Y2QxNDgyYzBhNDgiLCJpYXQiOjE0NjY5ODE4MzUsImV4cCI6MTQ2Njk4NTQzNSwiYXVkIjpbImEyNWU5MWM1LWFiMWUtNGY5ZS05ZmQ5LTRjZDE0ODJjMGE0OCJdLCJpc3MiOiJodHRwOi8vb3BlcmF0b3JfYS5zYW5kYm94Mi5tb2JpbGVjb25uZWN0LmlvL29pZGMvYWNjZXNzdG9rZW4ifQ.xHwV1oDXeCfqnnsapFHsU-tV1Xmsm0-jeOh92ZjEONk"

private let kIdTokenDifferentKidString : String = "eyJraWQiOiJQLTAwIiwiYWxnIjoiSFMyNTYifQ.eyJub25jZSI6IjgzQ0M3MjZENzUxODQ2M0M5RDQ2ODA5NTA5MDhBM0E3Iiwic3ViIjoiNWU0Nzg3ZGI1MjFhNDAzNzBjNWIyMGQ2N2I5MGY3YTgiLCJhbXIiOlsiU0lNX1BJTiJdLCJhdXRoX3RpbWUiOjE0NjY5ODE4MzYsImFjciI6IjIiLCJhenAiOiJhMjVlOTFjNS1hYjFlLTRmOWUtOWZkOS00Y2QxNDgyYzBhNDgiLCJpYXQiOjE0NjY5ODE4MzUsImV4cCI6MTQ2Njk4NTQzNSwiYXVkIjpbImEyNWU5MWM1LWFiMWUtNGY5ZS05ZmQ5LTRjZDE0ODJjMGE0OCJdLCJpc3MiOiJodHRwOi8vb3BlcmF0b3JfYS5zYW5kYm94Mi5tb2JpbGVjb25uZWN0LmlvL29pZGMvYWNjZXNzdG9rZW4ifQ.btUC2JoY0J5BPQtT8LXCnRbxkxKMIpQX_7Q9ZORnRp0"

enum ExpectedModel {
    case NoChange
    case NullIdToken
    case NullIssuer
    case InvalidMaxAge
    case NullAud
    case InvalidExpiresIn
    case NullClientKey
    case EmptyKid
}

class TokenValidationSpec : QuickSpec {
    
    override func spec() {
        describe("Token Validation"){
            self.getPublicKey()
            self.initialTokenValidation(withMetadata: false, expectedModel: .NoChange)
            self.initialTokenValidation(withMetadata: true, expectedModel: .NoChange)
            self.initialTokenValidation(withMetadata: true, expectedModel: .InvalidMaxAge)
            self.initialTokenValidation(withMetadata: true, expectedModel: .NullClientKey)
            self.initialTokenValidation(withMetadata: true, expectedModel: .NullIssuer)
            self.initialTokenValidation(withMetadata: true, expectedModel: .InvalidExpiresIn)
            self.initialTokenValidation(withMetadata: true, expectedModel: .NullIdToken)
            self.getKeysWithId("PHPOP-00")
            self.getKeysWithId("")
            self.getKeyForAlgorithm("RSA")
            self.getKeyForAlgorithm("")
            self.getKeyForAlgorithm(nil)
            self.checkKey(false)
        }
    }
    
    func getPublicKey(){
        
        let mockTokenValidation = getTokenValidationMock(true)
        
        waitUntil { (done:() -> Void) in
            mockTokenValidation.getPublicKeys({ (model, err) in
                it("should call method", closure: { 
                    expect(mockTokenValidation.getPublicKeysMethodIsCalled).to(beTrue())
                })
                
                it("should have error", closure: {
                    expect(err).to(beNil())
                })
                
                it("check get valid key for invalid key", closure: {
                    self.getTokenValidationMock(true, withError: MCErrorCode.NoValidAlgorithmFound.error).getValidKeyWithCompletionHandler({ (key, error) in
                        expect(error).notTo(beNil())
                    })
                })
                
                it("check get valid for valid key id", closure: {
                    self.getTokenValidationMock(true).getValidKeyWithCompletionHandler({ (key, error) in
                        expect(error).to(beNil())
                    })
                })
                
                it("check get valid key for invalid key", closure: {
                    self.getTokenValidationMock(true, withError: MCErrorCode.Unknown.error).getValidKeyWithCompletionHandler({ (key, error) in
                        expect(error).notTo(beNil())
                    })
                })
                
                it("check get valid key for invalid key", closure: {
                    self.getTokenValidationMock(true, withError: MCErrorCode.NoValidKeyFound.error).getValidKeyWithCompletionHandler({ (key, error) in
                        expect(error).notTo(beNil())
                    })
                })
                
                done()
            })
        }
    }
    
    
    func checkIdTokenIsValid() {
        let mockTokenValidation = getTokenValidationMock(true, expectedModel:.NoChange)
        
        waitUntil { (done:() -> Void) in
            mockTokenValidation.checkIdTokenIsValid({ (err:NSError?) in
                
            })
        }
    }
    
    func initialTokenValidation(withMetadata metadata:Bool, expectedModel: ExpectedModel ) {
        
        let mockTokenValidation = getTokenValidationMock(metadata, expectedModel: expectedModel)
        
        waitUntil { (done:() -> Void) in
            mockTokenValidation.initialCheckTokenIsValid({ (err:NSError?) in
                it("should call method", closure: {
                    expect(mockTokenValidation.initialCheckMethodCalled).to(beTrue())
                })
                
                it("should have error", closure: {
                    if(expectedModel != .NoChange) {
                        expect(err).notTo(beNil())
                    }
                })
                done()
            })
            
        }
    }
    
    func getTokenValidationMock(withMetadata : Bool, expectedModel : ExpectedModel? = .NoChange, withError error : NSError? = nil) -> TokenValidationMock {
        
        let tokenModel = Mocker.tokenResponseModel.tokenData!
        let configuration : MobileConnectServiceConfiguration
        
        Mocker.resetModels()
        
        if(withMetadata) {
            configuration = Mocker.mobileConnectConfigurationWithMetadata
        } else {
            configuration = Mocker.mobileConnectConfiguration
        }
        
        if expectedModel == .NullIdToken {
            //tokenModel.id_token = nil
        } else if expectedModel == .InvalidMaxAge {
            configuration.maxAge = -10000000
        } else if expectedModel == .InvalidExpiresIn {
            tokenModel.expires_in = "-10000000000"
        } else if expectedModel == .NullClientKey {
            configuration.clientKey = ""
        } else if expectedModel == .NullIssuer {
            configuration.metadata?.issuer = nil
        }
        
        if (error == MCErrorCode.NoValidAlgorithmFound.error){
            tokenModel.id_token = kIdTokenDifferentAlgString
        } else if (error == MCErrorCode.NoValidKeyFound.error) {
            tokenModel.id_token = kIdTokenDifferentKidString
        }
        
        let tokenValidationMock = TokenValidationMock(configuration: configuration, model: tokenModel)!
        
        if(error != nil && error != MCErrorCode.NoValidAlgorithmFound.error && error != MCErrorCode.NoValidKeyFound.error) {
            tokenValidationMock.error = error
            tokenValidationMock.response = nil
        } else {
            tokenValidationMock.error = nil
            tokenValidationMock.response = Mocker.publicKeyModel
            let key : PublicKeyModel = Mocker.publicKeyModel.keys![0] as! PublicKeyModel
            if expectedModel == .EmptyKid {
                key.kid = nil
            }
        }
        
        return tokenValidationMock
    }

    
    
    func getKeysWithId(keyId : String) {
        
        var tokenValidationMock : TokenValidationMock
        
        if(keyId == "") {
            tokenValidationMock = getTokenValidationMock(true, expectedModel: .EmptyKid)
        } else {
            tokenValidationMock = getTokenValidationMock(true, expectedModel: .NoChange)
        }
        
        let keysArray = tokenValidationMock.response
        
        if let publicKey = keysArray!.keys?[0] {
            let keys = tokenValidationMock.getKeysWithId(keyId, fromKeys: [publicKey as! PublicKeyModel])
            if(keyId != "") {
                it("should have elements", closure: {
                    expect(keys.count).to(be(1))
                })
            } else {
                it("should have no elements", closure: {
                    expect(keys.count).to(be(0))
                })
            }
        }
    }
    
    
    
//    func getKeysWithId(keyId : String) {
//        let keyId = keyId
//        let keysArray : PublicKeyModelArray = Mocker.publicKeyModel
//        
//        if let publicKey = keysArray.keys?[0] {
//            let keys = getTokenValidationMock(true, expectedModel: .NoChange).getKeysWithId(keyId, fromKeys: [publicKey as! PublicKeyModel])
//            //print((publicKey.kid ) + " ----  " + keyId + "/n")
//            if(keyId != "") {
//                it("should have elements", closure: {
//                    expect(keys.count).to(be(1))
//                })
//            } else {
//                it("should have no elements", closure: {
//                    expect(keys.count).to(be(0))
//                })
//            }
//            
//            getTokenValidationMock(true, expectedModel: .EmptyKid).getKeysWithId(keyId, fromKeys: [publicKey as! PublicKeyModel])
//        }
//    }
    
    func getKeyForAlgorithm(algorithm : String?) {
        let keysArray : PublicKeyModelArray = Mocker.publicKeyModel
        
        let publicKey : PublicKeyModel = keysArray.keys![0] as! PublicKeyModel
        //if let publicKey = keysArray.keys?[0] {
            if(algorithm == "") {
                publicKey.kty = nil
            }
            
            let key = getTokenValidationMock(true, expectedModel: .NoChange).getKeyForAlgorithm(algorithm, fromKeys: [publicKey as! PublicKeyModel])
        
            if(algorithm != nil) {
                if(publicKey.kty != nil) {
                    it("should have a key with algorithm", closure: {
                        expect(key).notTo(beNil())
                    })
                } else {
                    it("should have no key with algorithm", closure: {
                        expect(key).to(beNil())
                    })
                }
            } else {
                it("should have no key with algorithm", closure: {
                    expect(key).to(beNil())
                })
            }
        //}
        
    }
    
    func checkKey(withError : Bool) {
        let keysArray : PublicKeyModelArray = Mocker.publicKeyModel
        
        let publicKey : PublicKeyModel = keysArray.keys![0] as! PublicKeyModel
        if(withError) {
            publicKey.e = nil
            publicKey.n = nil
        }
        getTokenValidationMock(true).checkKey(publicKey, withCompletionHandler: { (error) in
            it("should have error", closure: {
                expect(error).notTo(beNil())
            })
        })
        
        publicKey.e = ""
        publicKey.n = "0"
        
        //de revizuit
        getTokenValidationMock(true).checkKey(publicKey, withCompletionHandler: { (error) in
            it("should have error", closure: {
                expect(error).notTo(beNil())
            })
        })

    }
    
}
