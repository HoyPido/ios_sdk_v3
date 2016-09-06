//
//  ExtensionTokenValidation.swift
//  MobileConnectSDK
//
//  Created by jenkins on 26/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

extension TokenValidation
{
    func getKeysWithId(keyId : String?, fromKeys keys : [PublicKeyModel]) -> [PublicKeyModel]
    {
        let identifiedKeys : [PublicKeyModel] = keys.filter({ (publicKey : PublicKeyModel) -> Bool in
            
            guard let keyId = publicKey.kid else
            {
                return false
            }
            
            return keyId == self.verifier.decoder.headerModel?.kid
        })
        
        return identifiedKeys
    }
    
    func getKeyForAlgorithm(algorithm : String?, fromKeys keys : [PublicKeyModel]) -> PublicKeyModel?
    {
        guard let algorithm = algorithm else
        {
            return nil
        }
        
        return keys.filter { (publicKey : PublicKeyModel) -> Bool in
            
            guard let keyAlgorithm = publicKey.kty else
            {
                return false
            }
            
            return (algorithm == keyAlgorithm || (algorithm == "RS256" && publicKey.kty == "RSA"))
            }.first
    }
    
    func getValidKeyWithCompletionHandler(handler : (key : PublicKeyModel? ,error : NSError?) -> Void)
    {
        getPublicKeys { (model, error) in
            guard let model = model, publicKeys = model.keys as? [PublicKeyModel] else {
                handler(key: nil, error: error)
                return
            }
            
            let identifiedKeys : [PublicKeyModel] = self.getKeysWithId(self.verifier.decoder.headerModel?.kid, fromKeys: publicKeys)
            
            guard identifiedKeys.count != 0 else
            {
                handler(key: nil, error: MCErrorCode.NoValidKeyFound.error)
                
                return
            }
            
            guard let validKey = self.getKeyForAlgorithm(self.verifier.decoder.headerModel?.alg, fromKeys: identifiedKeys) else
            {
                handler(key: identifiedKeys.first, error: MCErrorCode.NoValidAlgorithmFound.error)
                
                return
            }
            
            handler(key: validKey, error: nil)
        }
    }
}