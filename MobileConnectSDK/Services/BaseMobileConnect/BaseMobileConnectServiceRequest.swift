//
//  BaseMobileConnectServiceRequest.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 15/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

class BaseMobileConnectServiceRequest {
  
  static func callRequest<T : MCModel>(request : Request, forCompletionHandler completionHandler : (model : T?, error : NSError?) -> Void) {
    request.responseJSON { (response : Response<AnyObject, NSError>) in
      
      self.treatResponseCompletionHandler(response, withClientResponseHandler: completionHandler)
    }
  }
  
  static func treatResponseCompletionHandler<T : MCModel>(response : Response<AnyObject, NSError>, withClientResponseHandler clientResponseHandler : (model : T?, error : NSError?) -> Void) {

    if response.result.isSuccess {
      let deserializerObject = BaseMobileConnectServiceDeserializer<T>(dictionary: response.result.value)
      deserializerObject!.deserializeModel(clientResponseHandler)
    }
    else {
      clientResponseHandler(model: nil, error: response.result.error)
    }
  }
}