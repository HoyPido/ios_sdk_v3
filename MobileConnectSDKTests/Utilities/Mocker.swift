//
//  Mocker.swift
//  MobileConnectSDK
//
//  Created by jenkins on 27/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
@testable import MobileConnectSDK

private let kTokenResponseModelPlistName : String = "tokenResponseModel"
private let kPlistExtension : String = "plist"
private let kMetadataModelPlistName : String = "metadata"

class Mocker: NSObject {
    
    static var tokenResponseModel : TokenResponseModel = {
        return Mocker.modelWithName(kTokenResponseModelPlistName)
        
//        let bundle : NSBundle = NSBundle(forClass: Mocker.classForCoder())
//        
//        let url : NSURL = bundle.URLForResource(kTokenResponseModelPlistName, withExtension: kPlistExtension)!
//        
//        let dictionary : NSDictionary = NSDictionary(contentsOfURL: url)!
//        
//        return try! TokenResponseModel(dictionary: dictionary as [NSObject : AnyObject])
    }()
    
    class var metadata : MetadataModel
    {
        return modelWithName(kMetadataModelPlistName)
    }
    
    class var discoveryResponse : DiscoveryResponse
    {
        return modelWithName("DiscoveryDataResponse")
    }

    class func modelWithName<T : MCModel>(name : String) -> T
    {
        let bundle : NSBundle = NSBundle(forClass: Mocker.classForCoder())
        
        let url : NSURL = bundle.URLForResource(name, withExtension: kPlistExtension)!
        
        let dictionary : NSDictionary = NSDictionary(contentsOfURL: url)!
        
        return try! T(dictionary: dictionary as [NSObject : AnyObject])
    }
    
    //MARK: Metadata mocks
    class var metadataServicesMock : [String]
    {
        return ["service1", "service2"]
    }
    
    class var metadataAuthorizationEndpointMock : String
    {
        return "authorizationEndpoint"
    }
    
    class var metadataTokenEndpointMock : String
    {
        return "tokenEndpoint"
    }
    
    class var metadataUserInfoEndpointMock : String
    {
        return "userInfoEndpoint"
    }
    
    class var metadataPremiumInfoEndpointMock : String
    {
        return "premiumEndpoint"
    }
    
    class var metadataRevokeEndpointMock : String
    {
        return "revokeEndpoint"
    }
}
