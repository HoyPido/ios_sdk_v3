//
//  TokenValidationMock.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 25/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

@testable import MobileConnectSDK

class TokenValidationMock : TokenValidation {
    
    var error : NSError?
    var response : PublicKeyModelArray?
    var initialCheckMethodCalled = false
    var checkIdTokenMethodIsCalled = false
    var getPublicKeysMethodIsCalled = false
    
    override func initialCheckTokenIsValid(completion: (NSError) -> Void) {
        self.initialCheckMethodCalled = true
        super.initialCheckTokenIsValid({ (error:NSError?) in
            completion(error!)
        })
        
    }
    
    override func checkIdTokenIsValid(completionHandler: (NSError?) -> Void) {
        self.checkIdTokenMethodIsCalled = true
        
        super.checkIdTokenIsValid { (err:NSError?) in
            completionHandler(err)
        }
        
        completionHandler(self.error)
    }
    
    override func getPublicKeys(completion:(model:PublicKeyModelArray?, error:NSError?)->Void) {
        self.getPublicKeysMethodIsCalled = true
        completion(model: self.response, error: self.error)
    }
    
    override func getKeysWithId(keyId: String?, fromKeys keys: [PublicKeyModel]) -> [PublicKeyModel] {
        return super.getKeysWithId(keyId, fromKeys: keys)
    }
    
    override func getKeyForAlgorithm(algorithm: String?, fromKeys keys: [PublicKeyModel]) -> PublicKeyModel? {
        return super.getKeyForAlgorithm(algorithm, fromKeys: keys)
    }
    
    override func checkKey(key: PublicKeyModel, withCompletionHandler completionHandler: (error: NSError?) -> Void) {
        return super.checkKey(key, withCompletionHandler: completionHandler)
    }
    
}