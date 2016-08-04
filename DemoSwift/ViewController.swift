//
//  ViewController.swift
//  DemoSwift
//
//  Created by jenkins on 26/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK
import Alamofire

private let kPlistExtension : String = "plist"

class ViewController: UIViewController, MobileConnectManagerDelegate {
    
    func writeDictionary(dictionary : NSDictionary, withName name : String)
    {
        let documentsDirectory : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let plistPath : NSURL = NSURL(fileURLWithPath: documentsDirectory).URLByAppendingPathComponent(name)
        
        print(plistPath)
        
        dictionary.writeToURL(plistPath, atomically: true)
    }
    
    func modelWithName<T : MCModel>(name : String) -> T
    {
        let bundle : NSBundle = NSBundle(forClass: ViewController.classForCoder())
        
        let url : NSURL = bundle.URLForResource(name, withExtension: kPlistExtension)!
        
        let dictionary : NSDictionary = NSDictionary(contentsOfURL: url)!
        
        return try! T(dictionary: dictionary as [NSObject : AnyObject])
    }
    
    //MARK: Events
    @IBAction func getAction(sender: AnyObject) {
        
        let manager : MobileConnectManager = MobileConnectManager()

        manager.getTokenInPresenterController(self, withScopes: [ProductType.Email]) { (tokenResponseModel, error) in
            print(tokenResponseModel)
        }
    }
}

