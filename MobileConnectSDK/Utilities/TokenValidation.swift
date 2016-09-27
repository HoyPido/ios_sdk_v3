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
    
    func checkIdTokenIsValid(completionHandler: (NSError?) -> Void) {
        
        initialCheckTokenIsValid { (error) in
            if let error = error {
                completionHandler(error)
                return
            } else {
                self.checkIfHasValidKeyWithCompletionHandler(completionHandler)
            }
        }
    }
    
    func checkIfHasValidKeyWithCompletionHandler(completionHandler : (error : NSError?) -> Void)
    {
        getValidKeyWithCompletionHandler { (key, error) in
            
            guard let key = key else
            {
                completionHandler(error: error)
                return
            }
            
            self.checkKey(key, withCompletionHandler: completionHandler)
        }
    }
    
    func checkKey(key : PublicKeyModel, withCompletionHandler completionHandler : (error : NSError?) -> Void)
    {
        do
        {
            guard let exponent = key.e, modulus = key.n else
            {
                completionHandler(error: MCErrorCode.InvalidKey.error)
                
                return
            }
            
            let validKey : Bool = try self.verifier.verifyWithPublicKey(PublicKey(exponentString: exponent, modulusString: modulus))
            
            completionHandler(error: validKey ? nil : MCErrorCode.InvalidKey.error)
        }
        catch
        {
            completionHandler(error: error as NSError)
        }
    }
    
  
  func initialCheckTokenIsValid(completion:(NSError?)->Void) {
    
    if let decodedTokenDictionary = verifier.decoder.decodedDictionary {
        
      guard let metadata = configuration.metadata else {
        completion(MCErrorCode.MetadataInvalidError.error)
        return
      }
      
      do {
        let decodedToken = try DecodedTokenModel(dictionary: decodedTokenDictionary)
        if model.access_token == nil {
           completion(MCErrorCode.InvalidAccessTokenError.error)
           return
        }
        
        let authDate = NSDate(timeIntervalSince1970: decodedToken.auth_time)
        
        if let expiresIn = model.expires_in {
          if(authDate.timeIntervalSinceNow > Double(expiresIn)) {
            completion(MCErrorCode.TokenExpiredError.error)
            return
          }
        }
        
        if(decodedToken.iss != metadata.issuer ) {
          completion(MCErrorCode.InvalidIssuerError.error)
          return
        }
        
        if let aud = decodedToken.aud {
          if(aud[0] != configuration.clientKey) {
            completion(MCErrorCode.InvalidAudError.error)
            return
          }
        } else {
          completion(MCErrorCode.InvalidAudError.error)
          return
        }
        
        if let azp = decodedToken.azp {
          if(azp != configuration.clientKey) {
            completion(MCErrorCode.InvalidAzpError.error)
            return
          }
        } else {
            completion(MCErrorCode.InvalidAudError.error)
            return
        }
        
        if(authDate.timeIntervalSinceNow > Double(configuration.maxAge)) {
          completion(MCErrorCode.MaxAgeError.error)
          return
        }
        
        if configuration.nonce != decodedToken.nonce {
            completion(MCErrorCode.InvalidNonce.error)
            return
        }
        
      }
      catch {
      }
      
    } else {
        completion(MCErrorCode.InvalidAccessTokenError.error)
        return
    }
    completion(nil)
  }
  
    func getPublicKeys(completion:(model:PublicKeyModelArray?, error:NSError?)->Void) {
        guard let jwksURL = configuration.metadata?.jwks_uri else {
            //completion(model: nil, error: MCErrorCode.Unknown.error)
            return
        }
        
        let requestJson = request(.GET, jwksURL, parameters: nil, encoding: .URL, headers: nil)
        requestJson.responseJSON { (response:Response<AnyObject, NSError>) in
    
            let deserializerObject = BaseMobileConnectServiceDeserializer<PublicKeyModelArray>(dictionary: response.result.value)
            deserializerObject?.deserializeModel(completion)
        }
    }
    
}