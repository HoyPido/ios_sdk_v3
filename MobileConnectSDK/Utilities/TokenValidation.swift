//
//  TokenValidation.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 18/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire
import Heimdall
 
class TokenValidation : NSObject {
  
  let configuration: MobileConnectServiceConfiguration
  let model: TokenModel
  let verifier : JWTManager
  
  init?(configuration: MobileConnectServiceConfiguration, model: TokenModel) {
        self.configuration = configuration
        self.model = model
    
        guard let tokenId = model.id_token else
        {
            return nil
        }
    
        verifier = JWTManager(JWTTokenString: tokenId)
    }
    
    func checkIdTokenIsValid(_ completionHandler: @escaping (NSError?) -> Void) {
        
        initialCheckTokenIsValid { (error) in
            if let error = error {
                completionHandler(error)
                return
            } else {
                self.checkIfHasValidKeyWithCompletionHandler(completionHandler)
            }
        }
    }
    
    func checkIfHasValidKeyWithCompletionHandler(_ completionHandler : @escaping (_ error : NSError?) -> Void)
    {
        getValidKeyWithCompletionHandler { (key, error) in
            
            guard let key = key else
            {
                completionHandler(error)
                return
            }
            
            self.checkKey(key, withCompletionHandler: completionHandler)
        }
    }
    
    func checkKey(_ key : PublicKeyModel, withCompletionHandler completionHandler : (_ error : NSError?) -> Void)
    {
        do
        {
            guard let exponent = key.e, let modulus = key.n else
            {
                completionHandler(MCErrorCode.invalidKey.error)
                
                return
            }
            
            let validKey : Bool = try self.verifier.verifyWithPublicKey(PublicKey(exponentString: exponent, modulusString: modulus))
            
            completionHandler(validKey ? nil : MCErrorCode.invalidKey.error)
        } catch
        {
            completionHandler(error as NSError)
        }
    }
    
  
    func initialCheckTokenIsValid(_ completion:(NSError?) -> Void) {
        
        if let decodedTokenDictionary = verifier.decoder.decodedDictionary {
            
            guard let metadata = configuration.metadata else {
                completion(MCErrorCode.metadataInvalidError.error)
                return
            }
            
            do {
                let decodedToken = try DecodedTokenModel(dictionary: decodedTokenDictionary)
                if model.access_token == nil {
                    completion(MCErrorCode.invalidAccessTokenError.error)
                    return
                }
                
                let authDate = Date(timeIntervalSince1970: decodedToken.auth_time)
                
                if let expiresIn = model.expires_in {
                    if authDate.timeIntervalSinceNow > (expiresIn as NSString).doubleValue {
                        completion(MCErrorCode.tokenExpiredError.error)
                        return
                    }
                }
                
                if decodedToken.iss != metadata.issuer {
                    completion(MCErrorCode.invalidIssuerError.error)
                    return
                }
                
                if let aud = decodedToken.aud {
                    if aud[0] != configuration.clientKey {
                        completion(MCErrorCode.invalidAudError.error)
                        return
                    }
                } else {
                    completion(MCErrorCode.invalidAudError.error)
                    return
                }
                
                if let azp = decodedToken.azp {
                    if azp != configuration.clientKey {
                        completion(MCErrorCode.invalidAzpError.error)
                        return
                    }
                } else {
                    completion(MCErrorCode.invalidAudError.error)
                    return
                }
                
                if authDate.timeIntervalSinceNow > Double(configuration.maxAge) {
                    completion(MCErrorCode.maxAgeError.error)
                    return
                }
                
                if configuration.nonce != decodedToken.nonce {
                    completion(MCErrorCode.invalidNonce.error)
                    return
                }
                
            } catch {}
            
        } else {
            completion(MCErrorCode.invalidAccessTokenError.error)
            return
        }
        completion(nil)
    }

    func getPublicKeys(completion:@escaping (_ model:PublicKeyModelArray?, _ error:NSError?) -> Void) {
        guard let jwksURL = configuration.metadata?.jwks_uri else {
            //completion(model: nil, error: MCErrorCode.Unknown.error)
            return
        }
        
        let requestJson = request(jwksURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        requestJson.responseJSON { (response: DataResponse<Any>) in
            
            let deserializerObject = BaseMobileConnectServiceDeserializer<PublicKeyModelArray>(dictionary: response.result.value as AnyObject?)
            deserializerObject?.deserializeModel(completion)
        }
    }
    
}
