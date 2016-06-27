//
//  ViewController.swift
//  DemoSwift
//
//  Created by jenkins on 26/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

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
        
        let discoveryService : DiscoveryService = DiscoveryService()
        
        discoveryService.startOperatorDiscoveryForPhoneNumber("+447403830781") { (operatorsData, error) in
            
            let viewController : UIViewController = UIViewController()
            
            discoveryService.response = nil
            discoveryService.error = nil
            mockDelegate.error = nil
            mockDelegate.response = nil
            
            //concurrent call
            context("mobile connect is called again before finishing", closure: {
                
                mockDelegate.resetFlags()
                
                discoveryService.response = nil
                discoveryService.error = nil
                mockDelegate.error = nil
                mockDelegate.response = nil
                
                discoveryService.error = MCErrorCode.Unknown.error
                discoveryService.withDelay = true
                
                manager.getTokenInPresenterController(viewController, withCompletitionHandler: { (tokenResponseModel, error) in
                    
                })
                
                manager.getTokenInPresenterController(viewController, withCompletitionHandler: { (tokenResponseModel, error) in
                    
                    it("has a concurrency error", closure: {
                        expect(error?.code).to(be(MCErrorCode.Concurrency.error.code))
                    })
                    
                    it("has a nil model", closure: {
                        expect(tokenResponseModel).to(beNil())
                    })
                })
            })

        }
    }
}

