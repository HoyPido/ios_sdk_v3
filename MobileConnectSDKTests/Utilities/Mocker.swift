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

class Mocker: NSObject {
    
    class var tokenResponseModel : TokenResponseModel
    {
        return modelWithName(kTokenResponseModelPlistName)
        
//        let bundle : NSBundle = NSBundle(forClass: Mocker.classForCoder())
//        
//        let url : NSURL = bundle.URLForResource(kTokenResponseModelPlistName, withExtension: kPlistExtension)!
//        
//        let dictionary : NSDictionary = NSDictionary(contentsOfURL: url)!
//        
//        return try! TokenResponseModel(dictionary: dictionary as [NSObject : AnyObject])
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
}
