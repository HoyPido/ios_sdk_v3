//
//  MainViewController.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 02/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
//import MobileConnectSDK
class MainWithoutDiscoveryViewController : UIViewController {
    @IBOutlet weak var tableView : UITableView!
    
    let availablSections = ["SignUpWithoutMetadata", "SignUpWithMetadata"]
    
    let availableSegue = ["showAuthe", "showIdentitySignUp"]
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
}

extension MainWithoutDiscoveryViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablSections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = availablSections[indexPath.row]
        cell.textLabel?.textAlignment = .Center
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier(availableSegue[indexPath.row], sender: nil)
    }
    
}
