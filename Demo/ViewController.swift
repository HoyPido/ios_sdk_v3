//
//  ViewController.swift
//  Demo
//
//  Created by Andoni Dan on 06/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

let kClientKey : String = "a25e91c5-ab1e-4f9e-9fd9-4cd1482c0a48"
//private let kClientKey : String = "e058eeb3-8813-417e-b258-4a02729dcf41"
let kClientSecret : String = "1d95d440-49fe-455e-8fd4-b5903b8c78ec"
//private let kClientSecret : String = "235c44a5-51e0-44b1-92e9-e425206206d8"
let kSandboxEndpoint : String = "http://discovery.sandbox2.mobileconnect.io/v2/discovery"
//private let kSandboxEndpoint : String = "http://discovery.dev.sandbox.mobileconnect.io/v2/discovery"

let kRedirectURL : String = "http://test.test.com"

let kSubscriberId : String = "463d919dbf92d25892727eec51172a5f92ee458f697b34703c730785f1f7269b905bb7b813180f81b183de5659f79728ba7af93cbb29b3a6dd3d229973194e003c545633dab0ff9d3cb4916619f64e567a91494e3426db925d7765d3fdb9b045d01b03e5a87248cfda9df67ccaccb9a29b1faf87b7ed6f24bb47f4dc355d7f1c331bf3e8bff8bf3deed4119430fbc2558cbefd99a4efdb25dbdde6a2595d8e2e5a87552b1118953396913b49cbfeb79d341b086b1404581a17c11f61b2f95cc9089dee5c1c643140d365a5800c862716ef58e0de5f48e6e40984df4631420779f4e346718e0b5fda9cc8b27bd0ee0a4b82bbdd944b61dc461d7aed54ea3d27ab"

let kClientId : String = "a25e91c5-ab1e-4f9e-9fd9-4cd1482c0a48"
let kAuthorizationURL : String = "http://operator_a.sandbox2.mobileconnect.io/oidc/authorize"
let kTokenURL : String = "http://operator_a.sandbox2.mobileconnect.io/oidc/accesstoken"


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        MobileConnectSDK.setRedirect(NSURL(string: kRedirectURL)!)
        MobileConnectSDK.setClientKey(kClientKey)
        MobileConnectSDK.setClientSecret(kClientSecret)
        MobileConnectSDK.setApplicationEndpoint(kSandboxEndpoint)
        
        let service : MobileConnectService = MobileConnectService(clientId: kClientId, authorizationURL: kAuthorizationURL, tokenURL: kTokenURL)

//        service.getTokenInController(self, subscriberId: nil) { (controller, tokenModel, error) in
//            
//            controller?.dismissViewControllerAnimated(true, completion: nil)
//            print(tokenModel)
//            
//        }
        
//        service.getTokenWithSubscriberId(kSubscriberId) { (tokenModel, error) in
//            
//            print(tokenModel)
//            print(error)
//        }
        
//        service.getTokenInController(self) { (controller, tokenModel, error) in
//            
//            
//        }
        
//        let service : MobileConnectService = MobileConnectService()

//        service.startOperatorDiscoveryWithCountryCode("91", networkCode: "01") { (operatorsData, error) in
//            
//            print(error)
//            print(operatorsData)
//            
//        }
        
//        service.startOperatorDiscoveryForPhoneNumber("+4474038307") { (operatorsData, error) in
//            print(operatorsData?.toDictionary())
//            print(error)
//        }
        
//        service.startOperatorDiscoveryInController(self) { (controller, operatorsData, error) in
//            print(operatorsData)
//        }
    }
    
    //MARK: WebController delegate
    func webControllerDidCancel(controller: BaseWebController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webController(controller: BaseWebController, shouldRedirectToURL url: NSURL) -> Bool {
        return false
    }
    
    func webController(controller: BaseWebController, failedLoadingRequestWithError error: NSError?) {
        
    }
}

