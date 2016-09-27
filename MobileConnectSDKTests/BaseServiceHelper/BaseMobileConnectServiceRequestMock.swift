//
//  BaseMobileConnectServiceRequestMock.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 25/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

@testable import MobileConnectSDK

class BaseMobileConnectServiceRequestMock : BaseMobileConnectServiceRequest {
    
    var response : MCModel?
    var error : NSError?
    
    override func callRequest<T:MCModel>(request: Request, forCompletionHandler completionHandler: (model: T?, error: NSError?) -> Void) {
        completionHandler(model: self.response as? T, error: self.error)
    }

}