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
    
    func callRequest<T : MCModel>(request : DataRequest, forCompletionHandler completionHandler : @escaping (_ model : T?, _ error : NSError?) -> Void) {
        print("inside")
        print(request)
        request.responseJSON { (response) in
            print("----response---")
            print(response)
            self.treatResponseCompletionHandler(response, withClientResponseHandler: completionHandler)
        }
    }
    
    
  
  func treatResponseCompletionHandler<T : MCModel>(_ response : DataResponse<Any>, withClientResponseHandler clientResponseHandler : (_ model : T?, _ error : NSError?) -> Void) {
    if response.result.isSuccess {
        let deserializerObject = BaseMobileConnectServiceDeserializer<T>(dictionary: response.result.value as AnyObject?)
        deserializerObject?.deserializeModel(clientResponseHandler)
    } else {
        clientResponseHandler(nil, response.result.error as NSError?)
    }
  }
}
