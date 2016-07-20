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
        
        let operatorsData : DiscoveryResponse = modelWithName("testOperatorData")
        
        let configuration : MobileConnectServiceConfiguration = MobileConnectServiceConfiguration(discoveryResponse: operatorsData)
        
        let service : MCService = MCService(configuration: configuration)
        
        service.getTokenInController(self, completionHandler: { (controller, tokenModel, error) in
            
            controller?.dismissViewControllerAnimated(true, completion: nil)
            print(tokenModel)
            
        })
        
//        let manager : MobileConnectManager = MobileConnectManager()
//        manager.delegate = self
//
//        manager.getTokenForPhoneNumber("+923448510272", inPresenterController: self) { (tokenResponseModel, error) in
//            print(tokenResponseModel)
//        }
        
//        manager.getTokenInPresenterController(self) { (tokenResponseModel, error) in
//            print(tokenResponseModel)
//        }
        
//        manager.getAuthorizationTokenForPhoneNumber("+923448510272", inPresenterController: self, withScopes: [OpenIdProductType.Email], context: "asdas", bindingMessage: nil) { (tokenResponseModel, error) in
//            print(tokenResponseModel)
//        }
        
        let discovery : DSService = DSService()
        
        discovery.startOperatorDiscoveryForPhoneNumber("+923448510272") { (operatorsData, error) in
            
            if let operatorsData = operatorsData
            {
                
                self.writeDictionary(operatorsData.toDictionary(), withName: "telenor")
                
//                let configuration : MobileConnectServiceConfiguration = MobileConnectServiceConfiguration(discoveryResponse: operatorsData)
//                
//                let service : MCService = MCService(configuration: configuration)
//                
//                service.getTokenInController(self, completionHandler: { (controller, tokenModel, error) in
//                    
//                    controller?.dismissViewControllerAnimated(true, completion: nil)
//                    print(tokenModel)
//                    
//                })
            }
            
        }
        
        //let mobile : MCService = MCService(configuration: <#T##MobileConnectServiceConfiguration#>)
        
//        manager.getTokenInPresenterController(self) { (tokenResponseModel, error) in
//            print(tokenResponseModel)
//            print(error)
//        }
        
//        manager.getAuthorizationTokenInPresenterController(self, withContext: "asdas", scopes: [OpenIdProductType.Email], bindingMessage: nil) { (tokenResponseModel, error) in
//            
//            print(tokenResponseModel)
//            
//        }
        
//        manager.getTokenInPresenterController(self) { (tokenResponseModel, error) in
//            
//        }
        
//        manager.getAuthorizationTokenForScopes([OpenIdProductType.Address, OpenIdProductType.Email, OpenIdProductType.Phone, OpenIdProductType.Profile], withContext: "bla bla", inPresenterController: self) { (tokenResponseModel, error) in
//            
//        }
        
//        manager.getTokenForPhoneNumber("+447964197453", inPresenterController: self) { (tokenResponseModel, error) in
//            
//        }
        
        //manager.getAuthorizationTokenForScopes([OpenIdProductType.Phone], withContext: "my context", inPresenterController: self) { (tokenResponseModel, error) in
            
            //print(tokenResponseModel)
            //print(error)
        //}
        
//        manager.getTokenInPresenterController(self) { (tokenResponseModel, error) in
////            print(tokenResponseModel)
////            print(error)
//        }
        
//        let discoveryService : DSService = DSService()
//        
//        discoveryService.startOperatorDiscoveryForPhoneNumber("+447700200200") { (operatorsData, error) in
//            
//            
//        }
        
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

