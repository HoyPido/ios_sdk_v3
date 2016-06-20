//
//  Resources.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 03/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

//MARK: Local constants
private let kResourceBundleIdentifier : String = "com.GSMA.MobileConnectSDK"
private let kImageName : String = "mobileConnectButtonImage"

class Resources
{
    class var bundle : NSBundle?
    {
        return NSBundle(forClass: WebController.classForCoder())
    }
    
    class var mobileConnectImage : UIImage?
    {
        guard let bundle = bundle else
        {
            return nil
        }
        
        return UIImage(named: kImageName, inBundle: bundle, compatibleWithTraitCollection: nil)
    }
}