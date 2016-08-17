//
//  AttributeService.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 15/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

public class AttributeService : NSObject {
  
  let requestConstructor : AttributeRequestConstructor
  
  init(requestConstructor: AttributeRequestConstructor) {
    self.requestConstructor = requestConstructor
  }
  
  func getAttributeInformation(withURL URL: String, request: Request? = nil, completionHandler: (responseModel: AttributeResponseModel?, error: NSError?) -> Void) {
    if let request = request {
      BaseMobileConnectServiceRequest.callRequest(request, forCompletionHandler: completionHandler)
    } else {
      BaseMobileConnectServiceRequest.callRequest(requestConstructor.generatePremiumInfoRequest(URL), forCompletionHandler: completionHandler)
    }
  }
}