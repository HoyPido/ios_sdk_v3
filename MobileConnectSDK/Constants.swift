//
//  Constants.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

let kMobileConnectErrorDomain : String = "com.GSMA.MobileConnect"

///The error enum used by the Mobile Connect classes
@objc public enum MCErrorCode : Int
{
    //Web controller
    ///In case the request provided to Mobile Connect web controllers was nil
    case noRequestToLoad
    ///In case user cancelled
    case userCancelled
    ///In case it was not possible to create Mobile Connect's web controllers
    case webControllerNil
    
    //Generic
    ///In case the response received does not correspond to the expected model
    case serializationError
    ///In case the same service is launched twice or more times while an existing service is already running
    case concurrency
    ///In case one or more of the required parameters provided were nil
    case nilParameter
    case unknown
    
    //Discovery parameters
    /**
        Discovery error
        In case the provided country code was nil
    */
    case nilCountryCode
    /**
        Discovery error
        In case the provided network code was nil
     */
    case nilNetworkCode
    /**
        Discovery error
        In case the provided phone number was nil
     */
    case nilPhoneNumber
    
    //Mobile connect
    /**
        Mobile Connect error
        In case the provided level of assurance was nil
     */
    case nilLevelOfAssurance
    /**
        Mobile Connect error
        In case the client id which is expected from the Discovery response is nil
     */
    case nilClientId
    /**
        Mobile Connect error
        In case the Authorization URL which is expected from the Discovery response is nil
     */
    case nilAuthorizationURL
    /**
        Mobile Connect error
        In case the Token URL which is expected from the Discovery response is nil
     */
    case nilTokenURL
    /**
        Mobile Connect error
        In case the Subscriber id which is expected from the Discovery response is nil
     */
    case nilSubcriberId
    /**
        Mobile Connect error
        In case the Code which is expected from the Mobile connect authorization service is nil
     */
    case nilCode
    
    ///In case an error from the server was received
    case serverResponse
    
    ///In case the discovery does not return a metadata URL
    case nilMetadataURL
    
    ///In case MobileConnectService tries to access authorization request with incorrect configuration
    case requiresAuthorizationConfiguration
    
    //Token validation errors
    
    //Invalid metadata
    case metadataInvalidError
    
    //Invalid token
    case invalidAccessTokenError
    
    //Token expired
    case tokenExpiredError
    
    //Invalid issuer
    case invalidIssuerError
    
    //Invalid Aud
    case invalidAudError
    
    //Invalid Azp
    case invalidAzpError
    
    //Invalid nonce
    case invalidNonce
    
    //Max_age expired
    case maxAgeError
    
    //Invalid signature
    case invalidSignature
    
    case noTokenID
    
    case noValidKeyFound
    
    case noValidAlgorithmFound
    
    case invalidKey
    
    case invalidRefreshToken
    
    case emptyUUID
    
    case differentUUID
}

@objc public enum MCLevelOfAssurance : Int
{
    case level2 = 2
    case level3 = 3
}

extension MCErrorCode
{
    ///The error related to the MCErrorCode enum value
    public var error : NSError
    {
        return NSError(domain: kMobileConnectErrorDomain, code: rawValue, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
    ///The error message related to the MCErrorCode enum value
    public var message : String
    {
        guard let index = MCErrorCode.errors.index(of: self) else
        {
            return Localizator.unknownError
        }
        
        assert(MCErrorCode.messages.count == MCErrorCode.errors.count, "The MCErrorCode extension contains messages array and errors array which differ in element count")
        
        return MCErrorCode.messages[index]
    }
    
    static fileprivate var messages : [String]
    {
        return [Localizator.nilRequestInWebView, Localizator.userCancelled, Localizator.serializationError, Localizator.nilWebController, Localizator.nilCountryCode, Localizator.nilNetworkCode, Localizator.nilPhoneNumber, Localizator.concurrencyError, Localizator.nilParameterMessage, Localizator.nilLevelOfAssurance, Localizator.nilClientId, Localizator.nilAuthorizationURL, Localizator.nilTokenURL, "", Localizator.nilSubscriberId, Localizator.nilCode, "", Localizator.nilMetadataURL, Localizator.requiresAuthorizationConfiguration, Localizator.noTokenIdInTokenResponse, Localizator.noKeyFound, Localizator.keyAlgorithmNotSupported, Localizator.invalidKey, Localizator.invalidDiscoveryMetadata, Localizator.invalidAccessToken, Localizator.tokenExpiredError, Localizator.invalidIssuer, Localizator.invalidAud, Localizator.invalidAzp, Localizator.invalidNonce, Localizator.maxAgeError, Localizator.refreshToken, Localizator.emptyUUID, Localizator.differentUUID]
    }
    
    static fileprivate var errors : [MCErrorCode]
    {
        return [noRequestToLoad, userCancelled, serializationError, webControllerNil, nilCountryCode, nilNetworkCode, nilPhoneNumber, concurrency, nilParameter, nilLevelOfAssurance, nilClientId, nilAuthorizationURL, nilTokenURL, serverResponse, nilSubcriberId, nilCode, unknown, nilMetadataURL, requiresAuthorizationConfiguration, MCErrorCode.noTokenID, MCErrorCode.noValidKeyFound, MCErrorCode.noValidAlgorithmFound, MCErrorCode.invalidKey, .metadataInvalidError, .invalidAccessTokenError, .tokenExpiredError, .invalidIssuerError, .invalidAudError, .invalidAzpError, .invalidNonce, .maxAgeError, .invalidRefreshToken, .emptyUUID, .differentUUID]
    }
}

public var SDKVersion: String = "3.3.3"
