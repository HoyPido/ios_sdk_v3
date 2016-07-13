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

class ViewController: UIViewController, MobileConnectManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobileConnectSDK.setDelegate(self)
    }
    
    func writeDictionary(dictionary : NSDictionary, withName name : String)
    {
        let documentsDirectory : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let plistPath : NSURL = NSURL(fileURLWithPath: documentsDirectory).URLByAppendingPathComponent(name)
        
        print(plistPath)
        
        dictionary.writeToURL(plistPath, atomically: true)
    }
    
    //MARK: Events
    @IBAction func getAction(sender: AnyObject) {
        
        let discoveryService : DSService = DSService()
        
        
        
        discoveryService.startOperatorDiscoveryForPhoneNumber("+447700200200") { (operatorsData, error) in
            
            print(operatorsData)
        }
        
//        discoveryService.startOperatorDiscoveryInController(self) { (controller, operatorsData, error) in
//            
//        }
        
//        discoveryService.startOperatorDiscoveryForPhoneNumber("+447700200200") { (operatorsData, error) in
//            
//            print(operatorsData?.metadata)
//            
//            if let dictionary = operatorsData?.metadata?.toDictionary()
//            {
//                self.writeDictionary(dictionary, withName: "metadata")
//            }
//            
//            
////            print(operatorsData?.linksInformation?.openIdConfiguration() )
////            
////            request(.GET, operatorsData?.linksInformation?.openIdConfiguration() ?? "").responseJSON(completionHandler: { (response : Response<AnyObject, NSError>) in
////                print(response.result.value)
////            })
//        }
    }
}

