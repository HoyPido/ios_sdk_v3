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

enum ExpectedModel {
    case NoChange
    case NullIdToken
    case NullIssuer
    case InvalidMaxAge
    case NullAud
    case InvalidExpiresIn
    case NullClientKey
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
            self.getKeysWithId()
            self.getKeyForAlgorithm("RSA")
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
                
                it("check get valid for invalid key id", closure: {
                    self.getTokenValidationMock(true).getValidKeyWithCompletionHandler({ (key, error) in
                        expect(error).notTo(beNil())
                    })
                })
                
                it("check get valid key for invalid key", closure: {
                    self.getTokenValidationMock(true, withError: MCErrorCode.Unknown.error).getValidKeyWithCompletionHandler({ (key, error) in
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
        
        let tokenValidationMock = TokenValidationMock(configuration: configuration, model: tokenModel)!
        
        if(error != nil) {
            tokenValidationMock.error = error
            tokenValidationMock.response = nil
        } else {
            tokenValidationMock.error = nil
            tokenValidationMock.response = Mocker.publicKeyModel
            let key : PublicKeyModel = Mocker.publicKeyModel.keys![0] as! PublicKeyModel
            key.kid = ""
        }
        
        return tokenValidationMock
    }
    
    func getKeysWithId() {
        let keyId = "PHPOP-00"
        let keysArray : PublicKeyModelArray = Mocker.publicKeyModel
        
        if let publicKey = keysArray.keys?[0] {
            let keys = getTokenValidationMock(true, expectedModel: .NoChange).getKeysWithId(keyId, fromKeys: [publicKey as! PublicKeyModel])
            it("should have no elements", closure: {
                expect(keys.count).to(be(0))
            })
        }
    }
    
    func getKeyForAlgorithm(algorithm : String?) {
        let keysArray : PublicKeyModelArray = Mocker.publicKeyModel
        if let publicKey = keysArray.keys?[0] {
            let key = getTokenValidationMock(true, expectedModel: .NoChange).getKeyForAlgorithm(algorithm, fromKeys: [publicKey as! PublicKeyModel])
            if(algorithm != nil) {
                it("should have a key with algorithm", closure: {
                    expect(key).notTo(beNil())
                })
            } else {
                it("should have no key with algorithm", closure: {
                    expect(key).to(beNil())
                })
            }
        }
        
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

    }
    
}
