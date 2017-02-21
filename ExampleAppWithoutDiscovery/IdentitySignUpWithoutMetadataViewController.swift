//
//  IdentitySignUpViewController.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 04/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

class IdentitySignUpWithoutMetadataViewController : UIViewController {
    
    @IBOutlet weak var segmentedControll : UISegmentedControl!
    @IBOutlet weak var viewControllerNameLabel : UILabel!
    @IBOutlet weak var controllDistance : NSLayoutConstraint!
    
    @IBOutlet weak var getTokenButton: UIButton!
    @IBOutlet weak var clientIDField: UITextField!
    @IBOutlet weak var subscriberIdField: UITextField!
    @IBOutlet weak var clientSecretField: UITextField!
    
    var isCalledDiscoveryWithPhoneNumber : Bool = true
    var currentResponse : AttributeResponseModel?
    var currentError : NSError?
    var discoveryResponse: DiscoveryResponse = DiscoveryResponse()
    
    var currentTokenResponse : TokenResponseModel?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Mobile Connect Example App"
        commonInit()
    }
    
    func launchTokenViewerWithTokenResponseModel(userInfo : UserInfoResponse?, tokenResponseModel : TokenResponseModel?, error : NSError?)
    {
        currentTokenResponse = tokenResponseModel
        currentError = error
        self.performSegueWithIdentifier("showResult", sender: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func commonInit() {
        self.viewControllerNameLabel.text = "signUpWithoutProviderMetadata"
        
        let pathToConfigutationFile = NSBundle.mainBundle().pathForResource("config", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToConfigutationFile!)
        subscriberIdField.text = itemsDictionaryRoot?.valueForKey("subscriberId") as? String
        clientSecretField.text = itemsDictionaryRoot?.valueForKey("clientSecret") as? String
        clientIDField.text = itemsDictionaryRoot?.valueForKey("clientId") as? String
        
        getTokenButton.layer.cornerRadius = 5
        getTokenButton.layer.borderWidth = 1
        
        getTokenButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    
    
    @IBAction func getToken() {
        
        
        let subId: String = subscriberIdField.text ?? ""
        let clientSecret: String = clientSecretField.text ?? ""
        let clientId: String = clientIDField.text ?? ""
        
        let discoveryResponseLinks: OperatorIdModel = OperatorIdModel()
        
        let pathToOperatorUrls = NSBundle.mainBundle().pathForResource("operatorUrls", ofType: "plist")
        let itemsDictionaryRoot = NSDictionary(contentsOfFile: pathToOperatorUrls!)
        
        discoveryResponseLinks.setAuthorizationLink(itemsDictionaryRoot!.valueForKey("authorization") as? String)
        discoveryResponseLinks.setTokenLink(itemsDictionaryRoot!.valueForKey("token") as? String)
        discoveryResponseLinks.setUserInfoLink(itemsDictionaryRoot!.valueForKey("userinfo") as? String)
        discoveryResponseLinks.setPremiumInfo(itemsDictionaryRoot!.valueForKey("premiuminfo") as? String)
        discoveryResponseLinks.revokeTokenLink(itemsDictionaryRoot!.valueForKey("tokenrevoke") as? String)
        
        let withoutCallManager: MobileConnectManagerWithoutCall = MobileConnectManagerWithoutCall()
        
        discoveryResponse = withoutCallManager.makeDiscoveryResponse(subId, clientSecret: clientSecret, clientKey: clientId, name: "", linksRecieved: discoveryResponseLinks)
        withoutCallManager.getTokenInPresenterController(self, withScopes: [], withCompletionHandler: launchTokenViewerWithTokenResponseModel, discoveryResponse: discoveryResponse)
    }
    
    @IBAction func segmentedControllTapped(segmentedControll : UISegmentedControl) {
        
    }
    
    @IBAction func tapGestureAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Navigation
    func launchTokenViewerWithAttributeServiceResponse(attributeResponseModel : AttributeResponseModel?, tokenResponseModel : TokenResponseModel?, error : NSError?) {
        currentResponse = attributeResponseModel
        currentError = error
        self.performSegueWithIdentifier("showResult", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? ResultViewController {
            var model : [String : String] = [:]
             
            if let currentResponse = currentTokenResponse
            {
                model["message"] = "Validation skipped because metadata not supported by provider."
                model["access token"] = currentResponse.tokenData?.access_token
                model["token id"] = currentResponse.tokenData?.id_token
            }
            controller.datasource = model
        }
    }
    
    // MARK: Handle display/dismiss alert view
    
    @IBAction func alertViewDisplay() {
        let alert = UIAlertController(title: "signUpWithoutProviderMetadata", message: "signUpWithoutProviderMetadata -  represents the view controller file name in Project navigator.", preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion:{
            alert.view.superview?.userInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func alertControllerBackgroundTapped()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
