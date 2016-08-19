//
//  TokenValidation.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 18/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

class TokenValidation<T:MCModel>: NSObject {
  
  let configuration: MobileConnectServiceConfiguration
  let model: TokenModel
  
  init(configuration: MobileConnectServiceConfiguration, model: TokenModel) {
    self.configuration = configuration
    self.model = model
  }
  
  func checkIdTokenIsValid(completionHandler:(NSError?)->Void) {
    
    self.decodeTokenSignature()
    
    initialCheckTokenIsValid { (error) in
      if(error != MCErrorCode.NoError.error) {
        completionHandler(MCErrorCode.Unknown.error)
      }
    }
    
    getPublicKeys { (model, error) in
      guard let model = model else {
        completionHandler(error)
        return
      }
      
      if let error = error {
        completionHandler(error)
      } else {
        completionHandler(MCErrorCode.NoError.error)
      }
    }
  }
  
  func initialCheckTokenIsValid(completion:(NSError)->Void) {
    
    if let id_token = model.id_token, decodedTokenDictionary = JWTDecoder(tokenString: id_token).decodedDictionary {
      
      guard let metadata = configuration.metadata else {
        completion(MCErrorCode.MetadataInvalidError.error)
        return
      }
      
      do {
        let decodedToken = try DecodedTokenModel(dictionary: decodedTokenDictionary)
        if model.access_token == nil {
          completion(MCErrorCode.InvalidAccessTokenError.error)
        }
        
        let authDate = NSDate(timeIntervalSince1970: decodedToken.auth_time)
        
        if let expiresIn = model.expires_in {
          if(authDate.timeIntervalSinceNow > Double(expiresIn)) {
            completion(MCErrorCode.TokenExpiredError.error)
          }
        }
        
        if(decodedToken.iss != metadata.issuer ) {
          completion(MCErrorCode.InvalidIssuerError.error)
        }
        
        if let aud = decodedToken.aud {
          if(aud[0] != configuration.clientKey) {
            completion(MCErrorCode.InvalidAudError.error)
          }
        } else {
          completion(MCErrorCode.InvalidAudError.error)
        }
        
        if let azp = decodedToken.azp {
          if(azp != configuration.clientKey) {
            completion(MCErrorCode.InvalidAzpError.error)
          }
        } else {
          completion(MCErrorCode.InvalidAudError.error)
        }
        
        if configuration.nonce != decodedToken.nonce {
          completion(MCErrorCode.InvalidNonce.error)
        }
        
        if(authDate.timeIntervalSinceNow > Double(configuration.maxAge)) {
          completion(MCErrorCode.MaxAgeError.error)
        }
        
      }
      catch {
      }
      
    }
    completion(MCErrorCode.NoError.error)
  }
  
  func getPublicKeys(completion:(model:PublicKeyModelArray?, error:NSError?)->Void) {
    guard let jwksURL = configuration.metadata?.jwks_uri else {
      return
    }
    
    let requestJson = request(.GET, jwksURL, parameters: nil, encoding: .URL, headers: nil)
    requestJson.responseJSON { (response:Response<AnyObject, NSError>) in
    
      let deserializerObject = BaseMobileConnectServiceDeserializer<PublicKeyModelArray>(dictionary: response.result.value)
      deserializerObject?.deserializeModel(completion)
    }
  }
  
  func decodeTokenSignature() {
    let tokenComponents = self.model.id_token?.componentsSeparatedByString(".")
    
    if let encodedSignature : NSData = tokenComponents![2].dataUsingEncoding(NSUTF8StringEncoding)
    {
      let encodedCredentials : String = encodedSignature.base64EncodedStringWithOptions([])
      var x = 1
    }

  }
  
}