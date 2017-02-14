//
//  ResultViewController.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 04/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import UIKit

class ResultWithoutDiscoveryViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    
    var datasource : [String : String]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Mobile Connect Example App"
    }
    
    // MARK: table view delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let key = datasource.keys.map({$0})[indexPath.row]
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = datasource[key]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
