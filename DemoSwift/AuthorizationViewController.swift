//
//  AuthorizationViewController.swift
//  Demo
//
//  Created by jenkins on 20/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

class AuthorizationViewController: ViewController,  UITableViewDelegate, UITableViewDataSource {

    //MARK: iVars
    var selectedProductTypes : [ProductType]
    {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else
        {
            return []
        }
        
        return selectedIndexPaths.map({$0.row}).map({self.values[$0]})
    }
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Events
    override func actionWithPhoneAndWithManager(manager: MobileConnectManager) {
        manager.getAuthorizationTokenForPhoneNumber(phoneNumberTextField.text ?? "", inPresenterController: self, withScopes: selectedProductTypes, context: "blabla", bindingMessage: nil, completionHandler: launchTokenViewerWithTokenResponseModel)
    }
    
    override func actionWithoutPhoneWithManager(manager: MobileConnectManager) {
        manager.getAuthorizationTokenInPresenterController(self, withContext: "blabla", withScopes: selectedProductTypes, bindingMessage: "blabla", completionHandler: launchTokenViewerWithTokenResponseModel)
    }
    
    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringValues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = stringValues[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
}
