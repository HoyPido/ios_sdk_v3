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
            if correlationState {
                try! isRightCorrelationID(response)
            }
            let deserializerObject = BaseMobileConnectServiceDeserializer<T>(dictionary: response.result.value as AnyObject?)
            deserializerObject?.deserializeModel(clientResponseHandler)
        } else {
            clientResponseHandler(nil, response.result.error as NSError?)
        }
    }
    
    let discoveryRequestUUIDValue = DiscoveryRequestConstructor()
    
    func isRightCorrelationID(_ response : DataResponse<Any>) throws {
        let checkCorrelationID: NSDictionary = response.result.value as! NSDictionary
        let correlationIDValue: String = checkCorrelationID.value(forKey: correlation) as! String? ?? ""
        if (correlationIDValue == nil) {
            print("correlation_id failed")
            throw MCErrorCode.emptyUUID.error
        } else if (correlationIDValue == discoveryRequestUUIDValue.uuidValue) {
            print("correlation_id is ok")
        } else {
            print("correlation_id is not right")
            throw MCErrorCode.differentUUID.error
        }
    }
    
}
