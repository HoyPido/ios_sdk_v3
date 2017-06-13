//
//  Localizator.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

private let kWebViewHasNilRequest : String = "Webview could not load nil request"
private let kUserCancelled : String = "User cancelled action"

private let kNilApplicationEndpointName : String = "MobileConnectException.NillEndpoint"
private let kNilApplicationEndpointMessage : String = "A nil application endpoint is not allowed"

private let kSerializationError : String = "Could not deserialize object"

private let kNilWebController : String = "Web controller could not be instantiated"

private let kNilCountryCode : String = "The provided country code was nil"
private let kNilNetworkCode : String = "The provided network code was nil"
private let kNilPhoneNumber : String = "The provided phone number was nil"

private let kUnknownError : String = "Unknown error"

private let kConcurrencyError : String = "Concurrent requests are not supported"

private let kNilRedirectMessage : String = "No redirect parameter"
private let kNilRedirectName : String = "MobileConnectException.NilRedirectParameter"

private let kNilParameterMessage : String = "One or more of the passed parameters were nil"

private let kNilClientKeyName : String = "MobileConnectException.NilClientKeyProvided"
private let kNilClientKeyMessage : String = "The provided client key is nil"

private let kNilClientSecretName : String = "MobileConnectException.NilClientSecretProvided"
private let kNilClientSecretMessage : String = "The provided client secret is nil"

private let kNilLevelOfAssurance : String = "The provided level of assurance is nil"
private let kNilClientId : String = "The provided client id was nil"
private let kNilAuthorizationURL : String = "The provided authorization url was nil"
private let kNilTokenURL : String = "The provided token url was nil"
private let kNilSubcriberId : String = "The provided subcriber id was nil"

private let kNilCode : String = "Received code was nil"

private let kIncorrectDelegateName : String = "MobileConnectException.IncorrectDelegateClass"
private let kIncorrectDelegateMessage = "MobileConnectManager delegate should conform to protocol MobileConnectManagerDelegate"

private let kNilPresentereName : String = "MobileConnectException.NilPresenterController"
private let kNilPresenterMessage : String = "The buttons container controller cant be found. Please use the MobileConnectManager."

private let kNilMetadataURL : String = "There was no metadata URL"

private let kNilClientName : String = "NilClientName"
private let kNilClientNameMessage : String = "Authorization request requires a client name"

private let kNilContext : String = "NilContext"
private let kNilContextMessage : String = "Authorization request requires a context value"

private let kNoScopes : String = "NoScopes"
private let kNoScopesMessage : String = "Authorization requests require scopes specified"

private let kRequiresAuthorizationConfiguration : String = "Using authorization requires initializing mobile connect services with MCAuthorizationConfiguration instead of MobileConnectConfiguration"

private let kNoTokenIdInJWT : String = "There was no token id token response"

// MARK: Token validation errors

private let kInvalidDiscoveryMetadata : String = "Validation skipped because metadata not supported by provider."
private let kInvalidAccessToken: String = "Invalid access token"
private let kTokenExpiredError: String = "Token expired"
private let kInvalidIssuer: String = "Invalid issuer"
private let kInvalidAud: String = "Invalid aud"
private let kInvalidAzp: String = "Invalid azp"
private let kInvalidNonce: String = "Invalid nonce"
private let kMaxAgeError: String = "Max age outdated"
private let kNoKeyFound : String = "There is no key with specified id"
private let kKeyAlgorithmNotSupported : String = "Key Algorithm is Not Supported"
private let kInvalidKey : String = "Invalid key"
private let kInvalidRefreshTokenError : String = "Invalid refresh token"

// MARK: UUID validation 
private let kDifferentUUID : String = "UUID is different"
private let kEmptyUUID : String = "UUID is empty"

class Localizator: NSObject {
    
    class var invalidAlgorithm : String
    {
        return localized(kKeyAlgorithmNotSupported)
    }
    
    // MARK: Exception related strings
    class var requiresAuthorizationConfiguration : String
    {
        return localized(kRequiresAuthorizationConfiguration)
    }
    
    class var noScopesMessage : String
    {
        return localized(kNoScopesMessage)
    }
    
    class var noScopes : String
    {
        return localized(kNoScopes)
    }
    
    class var nilContextMessage : String
    {
        return localized(kNilContextMessage)
    }
    
    class var nilContext : String
    {
        return localized(kNilContext)
    }
    
    class var nilClientNameMessage : String
    {
        return localized(kNilClientNameMessage)
    }
    
    class var nilClientName : String
    {
        return localized(kNilClientName)
    }
    
    class var nilMetadataURL : String
    {
        return localized(kNilMetadataURL)
    }
    
    class var nilPresenterName : String
    {
        return localized(kNilPresentereName)
    }
    
    class var nilPresenterMessage : String
    {
        return localized(kNilPresenterMessage)
    }
    
    class var incorrectDelegateName : String
    {
        return localized(kIncorrectDelegateName)
    }
    
    class var incorrectDelegateMessage : String
    {
        return localized(kIncorrectDelegateMessage)
    }
    
    class var nilClientSecretName : String
    {
        return localized(kNilClientSecretName)
    }
    
    class var nilClientSecretMessage : String
    {
        return localized(kNilClientSecretMessage)
    }
    
    class var nilClientKeyName : String
    {
        return localized(kNilClientKeyName)
    }
    
    class var nilClientKeyMessage : String
    {
        return localized(kNilClientKeyMessage)
    }
    
    class var nilRedirectName : String
    {
        return localized(kNilRedirectName)
    }
    
    class var nilRedirectMessage : String
    {
        return localized(kNilRedirectMessage)
    }
    
    class var nilApplicationEndpointName : String
    {
        return localized(kNilApplicationEndpointName)
    }
    
    class var nilApplicationEndpointMessage : String
    {
        return localized(kNilApplicationEndpointMessage)
    }
    
    class var nilParameterMessage : String
    {
        return localized(kNilParameterMessage)
    }
    
    // MARK: Error related messages
    class var invalidKey : String
    {
        return localized(kInvalidKey)
    }
    
    class var noKeyFound : String
    {
        return localized(kNoKeyFound)
    }
    
    class var keyAlgorithmNotSupported : String {
        return localized(kKeyAlgorithmNotSupported)
    }
    
    class var noTokenIdInTokenResponse : String
    {
        return localized(kNoTokenIdInJWT)
    }
    
    class var concurrencyError : String
    {
        return localized(kConcurrencyError)
    }
    
    class var unknownError : String
    {
        return localized(kUnknownError)
    }
    
    class var nilWebController : String
    {
        return localized(kNilWebController)
    }
    
    class var serializationError : String
    {
        return localized(kSerializationError)
    }
    
    class var userCancelled : String
    {
        return localized(kUserCancelled)
    }
    
    class var nilRequestInWebView : String
    {
        return localized(kWebViewHasNilRequest)
    }
    
    //Discovery errors
    class var nilPhoneNumber : String
    {
        return localized(kNilPhoneNumber)
    }
    
    class var nilNetworkCode : String
    {
        return localized(kNilNetworkCode)
    }
    
    class var nilCountryCode : String
    {
        return localized(kNilCountryCode)
    }
    
    //Mobile connect errors
    class var nilCode : String
    {
        return localized(kNilCode)
    }
    
    class var nilSubscriberId : String
    {
        return localized(kNilSubcriberId)
    }
    
    class var nilLevelOfAssurance : String
    {
        return localized(kNilLevelOfAssurance)
    }
    
    class var nilClientId : String
    {
        return localized(kNilClientId)
    }
    
    class var nilAuthorizationURL : String
    {
        return localized(kNilAuthorizationURL)
    }
    
    class var nilTokenURL : String
    {
        return localized(kNilTokenURL)
    }
    
    // MARK: main method
    fileprivate class func localized(_ key : String) -> String
    {
        return NSLocalizedString(key, comment: "")
    }
  
    // MARK: Token validation error
  
    class var invalidDiscoveryMetadata : String {
      return localized(kInvalidDiscoveryMetadata)
    }
    
    class var invalidAccessToken : String {
        return localized(kInvalidAccessToken)
    }
    
    class var tokenExpiredError : String {
        return localized(kTokenExpiredError)
    }
    
    class var invalidIssuer : String {
        return localized(kInvalidIssuer)
    }
    
    class var invalidAud : String {
        return localized(kInvalidAud)
    }
    
    class var invalidAzp : String {
        return localized(kInvalidAzp)
    }
    
    class var invalidNonce : String {
        return localized(kInvalidNonce)
    }
    
    class var maxAgeError : String {
        return localized(kMaxAgeError)
    }
    
    class var refreshToken : String {
        return localized(kInvalidRefreshTokenError)
    }
    
    class var differentUUID : String {
        return localized(kInvalidRefreshTokenError)
    }
    
    class var emptyUUID : String {
        return localized(kInvalidRefreshTokenError)
    }
  
}
