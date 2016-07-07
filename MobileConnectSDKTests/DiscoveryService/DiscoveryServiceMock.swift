//
//  DiscoveryServiceMock.swift
//  MobileConnectSDK
//
//  Created by jenkins on 05/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Alamofire

@testable import MobileConnectSDK

class DiscoveryServiceMock: DiscoveryService {
    
    var response : DiscoveryResponse?
    var error : NSError?
    var metadata : MetadataModel?
    var withDelay : Bool = false
    var shouldCallSuper : Bool = false
    
    //MARK: Main functions
    override func startOperatorDiscoveryInController(controller: UIViewController, shouldProvideMetadata: Bool = true, completionHandler: DiscoveryResponseBlock) {
        
        if shouldCallSuper {
            print("passed start operator discovery")
            super.startOperatorDiscoveryInController(controller, shouldProvideMetadata: shouldProvideMetadata, completionHandler: completionHandler)
        }
        else
        {
            callHandlerWithDelay {
                completionHandler(controller: self.webController, operatorsData: self.response, error: self.error)
            }
        }
    }
    
    override func startOperatorDiscoveryForPhoneNumber(phoneNumber: String, shouldProvideMetadata: Bool = true, completionHandler: DiscoveryDataResponse)
    {
        if shouldCallSuper
        {
            super.startOperatorDiscoveryForPhoneNumber(phoneNumber, shouldProvideMetadata: shouldProvideMetadata, completionHandler: completionHandler)
        }
        else
        {
            callHandlerWithDelay {
                completionHandler(operatorsData: self.response, error: self.error)
            }
        }
    }
    
    //MARK: Mock any request
    override func processRequest(request: Request, withParameters parameters: [(String?, MCErrorCode)], inHandler localHandler: (model: DiscoveryResponse?, error: NSError?) -> Void) {
        
        var result : Alamofire.Result<AnyObject, NSError>
        
        if let response = response
        {
            result = .Success(response.toDictionary())
        }
        else
        {
            result = .Failure(self.error ?? MCErrorCode.Unknown.error)
        }
        
        callHandlerWithDelay {
            
            self.treatResponseCompletionHandler(Alamofire.Response<AnyObject, NSError>(request: nil, response: nil, data: nil,result: result), withClientResponseHandler: localHandler)
        }
    }
    
    //MARK: Metadata mock
    override func getMetadataForOperatorData(operatorsData: DiscoveryResponse?, inHandler handler: (model: MetadataModel?, error: NSError?) -> Void) {
        handler(model: self.metadata, error: error)
    }
    
    //MARK: Helper testing functions
    func callHandlerWithDelay(handler : () -> Void)
    {
        if withDelay
        {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
            
            dispatch_async(queue, {
                
                let queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), queue2, {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        handler()
                    })
                })
            })
        }
        else
        {
            handler()
        }
    }
}
