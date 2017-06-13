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
        request.responseJSON { (response) in
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
    
    func isRightCorrelationID(_ response : DataResponse<Any>) throws {
        let checkCorrelationID: NSDictionary = response.result.value as! NSDictionary
        let correlationIDValue: String = checkCorrelationID.value(forKey: correlation) as! String? ?? ""
        if (correlationIDValue == "") {
            print("correlationd_id is nil")
            throw MCErrorCode.emptyUUID.error
        } else if correlationIDValue == uuidValue {
            print("correlationd_id is right")
        } else {
            print("correlation_id is not the same")
            throw MCErrorCode.differentUUID.error
        }
    }
    
}
