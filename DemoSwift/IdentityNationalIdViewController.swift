//
//  IdentityNationalIdViewController.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 05/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

class IdentityNationalIdViewController: UIViewController {
    
    @IBOutlet weak var segmentedControll : UISegmentedControl!
    @IBOutlet weak var getTokenButton : UIButton!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var viewControllerNameLabel : UILabel!
    @IBOutlet weak var controllDistance : NSLayoutConstraint!
    
    var isCalledDiscoveryWithPhoneNumber : Bool = true
    var currentResponse : AttributeResponseModel?
    var currentError : NSError?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Mobile Connect Example App"
        commonInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isCalledDiscoveryWithPhoneNumber{
            self.phoneNumberTextField.becomeFirstResponder()
        }
    }
    
    func commonInit() {
        self.viewControllerNameLabel.text = "IdentityNationalIdViewController"
        getTokenButton.layer.cornerRadius = 5
        getTokenButton.layer.borderWidth = 1
        getTokenButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func getToken() {
        let manager : MobileConnectManager = MobileConnectManager()
        if isCalledDiscoveryWithPhoneNumber {
            manager.getAttributeServiceResponseWithPhoneNumber(phoneNumberTextField.text ?? "", clientIP: "", inPresenterController: self, withStringValueScopes: [ProductType.identityNationalID], context: "MC", bindingMessage: "MC", completionHandler: launchTokenViewerWithAttributeServiceResponse)
        } else {
            manager.getAttributeServiceResponse(self, context: "MC", scopes: [ProductType.identityNationalID], bindingMessage: "MC", withCompletionHandler: launchTokenViewerWithAttributeServiceResponse)
        }
    }
    
    @IBAction func segmentedControllTapped(_ segmentedControll : UISegmentedControl) {
        
        if segmentedControll.selectedSegmentIndex == 0 {
            self.phoneNumberTextField.becomeFirstResponder()
            self.controllDistance.constant = 108
            self.view.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                UIView.transition(with: self.phoneNumberTextField, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    self.phoneNumberTextField.isHidden = false
                    }, completion: nil)
                
            })
            isCalledDiscoveryWithPhoneNumber = true
            
        } else {
            self.phoneNumberTextField.resignFirstResponder()
            self.controllDistance.constant = 60
            self.view.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                
                UIView.transition(with: self.phoneNumberTextField, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    self.phoneNumberTextField.isHidden = true
                    }, completion: nil)
            })
            
            isCalledDiscoveryWithPhoneNumber = false
        }
    }
    
    @IBAction func tapGestureAction() {
        self.view.endEditing(true)
    }
    
    // MARK: Navigation
    func launchTokenViewerWithAttributeServiceResponse(_ attributeResponseModel : AttributeResponseModel?, tokenResponseModel : TokenResponseModel?, error : NSError?) {
        currentResponse = attributeResponseModel
        currentError = error
        self.performSegue(withIdentifier: "showResult", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ResultViewController {
            var model : [String : String] = [:]
            
            if let error = currentError
            {
                model["message"] = error.localizedDescription
            }
            
            if let currentResponse = currentResponse
            {
                model["message"] = "Success"
                model["sub"] = currentResponse.sub ?? ""
                model["national_identifier"] = currentResponse.national_identifier ?? ""
                model["updated_at"] = currentResponse.updated_at ?? ""
                model["birthdate"] = currentResponse.birthdate ?? ""
                model["given_name"] = currentResponse.given_name ?? ""
                model["family_name"] = currentResponse.family_name ?? ""
                model["state"] = currentResponse.state ?? ""
                model["city"] = currentResponse.city ?? ""
                model["street_address"] = currentResponse.street_address ?? ""
                model["postal_code"] = currentResponse.postal_code ?? ""
                model["country"] = currentResponse.country ?? ""
                
            }
            controller.datasource = model
        }
    }
    
    // MARK: Handle display/dismiss alert view
    
    @IBAction func alertViewDisplay() {
        let alert = UIAlertController(title: "IdentityNationalIdViewController", message: "IdentityNationalIdViewController -  represents the view controller file name in Project navigator.", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
