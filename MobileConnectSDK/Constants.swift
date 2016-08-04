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
    case NoRequestToLoad
    ///In case user cancelled
    case UserCancelled
    ///In case it was not possible to create Mobile Connect's web controllers
    case WebControllerNil
    
    //Generic
    ///In case the response received does not correspond to the expected model
    case SerializationError
    ///In case the same service is launched twice or more times while an existing service is already running
    case Concurrency
    ///In case one or more of the required parameters provided were nil
    case NilParameter
    case Unknown
    
    //Discovery parameters
    /**
        Discovery error
        In case the provided country code was nil
    */
    case NilCountryCode
    /**
        Discovery error
        In case the provided network code was nil
     */
    case NilNetworkCode
    /**
        Discovery error
        In case the provided phone number was nil
     */
    case NilPhoneNumber
    
    //Mobile connect
    /**
        Mobile Connect error
        In case the provided level of assurance was nil
     */
    case NilLevelOfAssurance
    /**
        Mobile Connect error
        In case the client id which is expected from the Discovery response is nil
     */
    case NilClientId
    /**
        Mobile Connect error
        In case the Authorization URL which is expected from the Discovery response is nil
     */
    case NilAuthorizationURL
    /**
        Mobile Connect error
        In case the Token URL which is expected from the Discovery response is nil
     */
    case NilTokenURL
    /**
        Mobile Connect error
        In case the Subscriber id which is expected from the Discovery response is nil
     */
    case NilSubcriberId
    /**
        Mobile Connect error
        In case the Code which is expected from the Mobile connect authorization service is nil
     */
    case NilCode
    
    ///In case an error from the server was received
    case ServerResponse
    
    ///In case the discovery does not return a metadata URL
    case NilMetadataURL
    
    ///In case MobileConnectService tries to access authorization request with incorrect configuration
    case RequiresAuthorizationConfiguration
}

@objc public enum MCLevelOfAssurance : Int
{
    case Level2 = 2
    case Level3 = 3
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
        guard let index = MCErrorCode.errors.indexOf(self) else
        {
            return Localizator.unknownError
        }
        
        assert(MCErrorCode.messages.count == MCErrorCode.errors.count, "The MCErrorCode extension contains messages array and errors array which differ in element count")
        
        return MCErrorCode.messages[index]
    }
    
    static private var messages : [String]
    {
        return [Localizator.nilRequestInWebView, Localizator.userCancelled, Localizator.serializationError, Localizator.nilWebController, Localizator.nilCountryCode, Localizator.nilNetworkCode, Localizator.nilPhoneNumber, Localizator.concurrencyError, Localizator.nilParameterMessage, Localizator.nilLevelOfAssurance, Localizator.nilClientId, Localizator.nilAuthorizationURL, Localizator.nilTokenURL,  "", Localizator.nilSubscriberId, Localizator.nilCode, "", Localizator.nilMetadataURL, Localizator.requiresAuthorizationConfiguration]
    }
    
    static private var errors : [MCErrorCode]
    {
        return [NoRequestToLoad, UserCancelled, SerializationError, WebControllerNil, NilCountryCode, NilNetworkCode, NilPhoneNumber, Concurrency, NilParameter, NilLevelOfAssurance, NilClientId, NilAuthorizationURL, NilTokenURL, ServerResponse, NilSubcriberId, NilCode, Unknown, NilMetadataURL, RequiresAuthorizationConfiguration]
    }
}