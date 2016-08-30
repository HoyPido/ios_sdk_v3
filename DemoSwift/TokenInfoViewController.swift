//
//  TokenInfoViewController.swift
//  Demo
//
//  Created by jenkins on 20/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

private let kSegueToAttribute : String = "toIdentity"

class TokenInfoViewController: BaseInfoPresenter {
    
    //MARK:Outlets
    @IBOutlet weak var getIdentityButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //MARK: iVars
    var currentResponse : AttributeResponseModel?
    var currentError : NSError?
    
    var hasGetIdentity : Bool = true
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = toolbar.items?.indexOf(getIdentityButton) where !hasGetIdentity
        {
            toolbar.items?.removeAtIndex(index)
        }
    }
    
    //MARK: Events
    @IBAction func getIdentityAction(sender: AnyObject) {
        
        guard let tokenResponse = model as? TokenResponseModel else
        {
            return
        }
        
        let attributeService : AttributeService = AttributeService(tokenResponse: tokenResponse)
        
        attributeService.getAttributeInformation(launchIdentityViewer)
    }
    
    //MARK: Helpers
    func dataModelFromCurrentResponse(currentResponse : AttributeResponseModel?) -> [String : String]
    {
        guard let currentResponse = currentResponse else
        {
            return [:]
        }
        
        var model : [String : String] = [:]
        
        model["message"] = currentError?.localizedDescription ?? "success"
        
        var jsonDictionary : [NSObject : AnyObject] = currentResponse.toDictionary()
        
        jsonDictionary.removeValueForKey("address")
        
        let addressString : String = currentResponse.address?.formatted ?? ""
        
        guard let modelDictionary = jsonDictionary as? [String : String] else
        {
            return [:]
        }
        
        model = modelDictionary
        model["address"] = addressString
        
        return model
    }
    
    //MARK: Navigation
    func launchIdentityViewer(responseModel : AttributeResponseModel?, error : NSError?)
    {
        currentResponse = responseModel
        currentError = error
        
        performSegueWithIdentifier(kSegueToAttribute, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identityViewerController = segue.destinationViewController as? IdentityViewController
        {
            identityViewerController.dataModel = dataModelFromCurrentResponse(currentResponse)
        }
    }
}
