//
//  BaseInfoPresenter.swift
//  Demo
//
//  Created by Andoni Dan on 18/08/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import MobileConnectSDK

class BaseInfoPresenter: UIViewController, UITableViewDelegate, UITableViewDataSource, UIToolbarDelegate {
    
    var model : MCModel?
    
    var dataModel : [String : String] = [:]
    
    //MARK: Toolbar delegate
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    //MARK: Actions
    @IBAction func dismissAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Table view delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let key : String = dataModel.keys.map({$0})[indexPath.row]
        
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = dataModel[key]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
