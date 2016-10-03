//
//  IdentitySignUpViewController.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 04/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

class IdentitySignUpViewController : UIViewController {
    
    @IBOutlet weak var segmentedControll : UISegmentedControl!
    @IBOutlet weak var getTokenButton : UIButton!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var viewControllerNameLabel : UILabel!
    @IBOutlet weak var controllDistance : NSLayoutConstraint!

    var isCalledDiscoveryWithPhoneNumber : Bool = true
    var currentResponse : AttributeResponseModel?
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
        self.viewControllerNameLabel.text = "IdentitySignUpViewController"
        getTokenButton.layer.cornerRadius = 5
        getTokenButton.layer.borderWidth = 1
        getTokenButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    @IBAction func getToken() {
        let manager : MobileConnectManager = MobileConnectManager()
        if isCalledDiscoveryWithPhoneNumber {
            manager.getAttributeServiceResponseWithPhoneNumber(phoneNumberTextField.text ?? "", inPresenterController: self, withStringValueScopes: [ProductType.IdentitySignUp], context: "MC", bindingMessage: nil, completionHandler: launchTokenViewerWithAttributeServiceResponse)
        } else {
            manager.getAttributeServiceResponse(self, context: "MC", scopes: [ProductType.IdentitySignUp], withCompletionHandler: launchTokenViewerWithAttributeServiceResponse)
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
    //MARK: Navigation
    
    func launchTokenViewerWithAttributeServiceResponse(attributeResponseModel : AttributeResponseModel?, tokenResponseModel : TokenResponseModel?, error : NSError?) {
        currentResponse = attributeResponseModel
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
            
            if let currentResponse = currentResponse
            {
                model["message"] = "Success"
                model["sub"] = currentResponse.sub ?? ""
                model["preferred_username"] = currentResponse.preferred_username ?? ""
                model["family_name"] = currentResponse.family_name ?? ""
                model["given_name"] = currentResponse.given_name ?? ""
                model["email"] = currentResponse.email ?? ""
                model["email_verified"] = currentResponse.email_verified.description
                model["gender"] = currentResponse.gender ?? ""
                model["locale"] = currentResponse.locale ?? ""
                model["updated_at"] = currentResponse.updated_at ?? ""
                model["birth_date"] = currentResponse.birth_date ?? ""
            }

            controller.datasource = model
        }
    }
    
    //MARK: Handle display/dismiss alert view
    
    @IBAction func alertViewDisplay() {
        let alert = UIAlertController(title: "IdentitySignUpViewController", message: "IdentitySignUpViewController -  represents the view controller file name in Project navigator.", preferredStyle: .Alert)
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
