//
//  AutheViewController.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 04/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

class AuthenticationViewController : UIViewController {
    
    @IBOutlet weak var segmentedControll : UISegmentedControl!
    @IBOutlet weak var getTokenButton : UIButton!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var viewControllerNameLabel : UILabel!
    @IBOutlet weak var controllDistance : NSLayoutConstraint!
    
    var isCalledDiscoveryWithPhoneNumber : Bool = true
    var currentTokenResponse : TokenResponseModel?
    var currentError : NSError?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Mobile Connect Example App"
        commonInit()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isCalledDiscoveryWithPhoneNumber{
            self.phoneNumberTextField.becomeFirstResponder()
        }
    }
    
    func commonInit() {
        self.viewControllerNameLabel.text = "AuthenticationViewController"
        getTokenButton.layer.cornerRadius = 5
        getTokenButton.layer.borderWidth = 1
        getTokenButton.layer.borderColor = UIColor.blackColor().CGColor
    }

    @IBAction func getToken() {
        let manager : MobileConnectManager = MobileConnectManager()
        if isCalledDiscoveryWithPhoneNumber {
            manager.getTokenForPhoneNumber(phoneNumberTextField.text ?? "", clientIP: "", inPresenterController: self, withScopes: [], withCompletionHandler: launchTokenViewerWithTokenResponseModel)
        } else {
            manager.getTokenInPresenterController(self, withScopes: [], withCompletionHandler: launchTokenViewerWithTokenResponseModel)
        }
    }
    
    @IBAction func segmentedControllTapped(segmentedControll : UISegmentedControl) {
        
        if segmentedControll.selectedSegmentIndex == 0 {
            self.phoneNumberTextField.becomeFirstResponder()
            self.controllDistance.constant = 108
            self.view.setNeedsUpdateConstraints()
            UIView.animateWithDuration(0.5, animations: {
                self.view.layoutIfNeeded()
                UIView.transitionWithView(self.phoneNumberTextField, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.phoneNumberTextField.hidden = false
                    }, completion: nil)
                
            })
            isCalledDiscoveryWithPhoneNumber = true
            
        } else {
            self.phoneNumberTextField.resignFirstResponder()
            self.controllDistance.constant = 60
            self.view.setNeedsUpdateConstraints()
            UIView.animateWithDuration(0.5, animations: {
                self.view.layoutIfNeeded()
                
                UIView.transitionWithView(self.phoneNumberTextField, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.phoneNumberTextField.hidden = true
                    }, completion: nil)
            })
            
            isCalledDiscoveryWithPhoneNumber = false
        }
    }
    
    @IBAction func tapGestureAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Navigation
    func launchTokenViewerWithTokenResponseModel(userInfo : UserInfoResponse?, tokenResponseModel : TokenResponseModel?, error : NSError?)
    {
        currentTokenResponse = tokenResponseModel
        currentError = error
        self.performSegueWithIdentifier("showResult", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? ResultViewController {
            var model : [String : String] = [:]
            
            if let error = currentError
            {
                model["message"] = error.localizedDescription
            }
            
            if let tokenResponse = currentTokenResponse
            {
                if model["message"] == nil {
                    model["message"] = "Success"
                }
                model["client name"] = tokenResponse.discoveryResponse?.clientName ?? ""
                model["access token"] = tokenResponse.tokenData?.access_token
                model["token id"] = tokenResponse.tokenData?.id_token
            }
            
            controller.datasource = model
        }
    }
    
    
    // MARK: Handle display/dismiss alert view
    
    @IBAction func alertViewDisplay() {
        let alert = UIAlertController(title: "AuthenticationViewController", message: "AuthenticationViewController -  represents the view controller file name in Project navigator.", preferredStyle: .Alert)
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
