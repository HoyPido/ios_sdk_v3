//
//  ViewController.swift
//  Demo
//
//  Created by jenkins on 20/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

private let kSegueToTokenResponseViewer : String = "toTokenInfo"
private let kHasGetIdentityCountNumber : Int = 7

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    //MARK: iVars
    var currentTokenResponse : TokenResponseModel?
    var currentError : NSError?
    
    var stringValues : [String]
    {
        return ["address", "email", "phone", "profile", "national id(identity)", "phone number(identity)", "sign up(identity)"]
    }
    
    var values : [ProductType]
    {
        return [ProductType.Address, ProductType.Email, ProductType.Phone, ProductType.Profile, ProductType.IdentityNationalID, ProductType.IdentityPhoneNumber, ProductType.IdentitySignUp]
    }
    
    //MARK: Events
    @IBAction func segmentChanged(sender: AnyObject) {
        phoneNumberTextField.hidden = segmentedControl.selectedSegmentIndex == 0
    }
    
    
    @IBAction func getTokenAction(sender: AnyObject) {
        
        let discovery : DSService = DSService()
        
        discovery.startOperatorDiscoveryForPhoneNumber("+447700100040", shouldProvideMetadata: true) { (operatorsData, error) in
            print(operatorsData?.metadata)
        }
        
//        let manager : MobileConnectManager = MobileConnectManager()
//        
//        if segmentedControl.selectedSegmentIndex == 0
//        {
//            actionWithoutPhoneWithManager(manager)
//        }
//        else
//        {
//            actionWithPhoneAndWithManager(manager)
//        }
    }
    
    //MARK: To be overriden
    func actionWithoutPhoneWithManager(manager : MobileConnectManager)
    {
        
    }
    
    func actionWithPhoneAndWithManager(manager : MobileConnectManager)
    {
        
    }
    
    //MARK: Navigation
    func launchTokenViewerWithTokenResponseModel(tokenResponseModel : TokenResponseModel?, error : NSError?)
    {
        currentTokenResponse = tokenResponseModel
        currentError = error
        
        performSegueWithIdentifier(kSegueToTokenResponseViewer, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? TokenInfoViewController
        {
            var model : [String : String] = [:]
            
            if let error = currentError
            {
                model["message"] = error.localizedDescription
            }
            
            if let tokenResponse = currentTokenResponse
            {
                model["message"] = "Success"
                model["application short name"] = tokenResponse.discoveryResponse?.applicationShortName ?? ""
                model["access token"] = tokenResponse.tokenData?.access_token
                model["token id"] = tokenResponse.tokenData?.id_token
            }
            
            controller.model = currentTokenResponse
            controller.dataModel = model
            controller.hasGetIdentity = values.count == kHasGetIdentityCountNumber
        }
    }
}

