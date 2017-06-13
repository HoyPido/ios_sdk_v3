//
//  RevokeTokenService.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 22/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

class RevokeTokenService : NSObject {
    
    let tokenResponseModel : TokenResponseModel
    let revokedToken : String
    let requestConstructor : RevokeTokenRequestConstructor
    let connectService : BaseMobileConnectServiceRequest
    let isRefreshToken : Bool
    
    init(revokedToken : String, tokenResponseModel : TokenResponseModel, isRefreshToken : Bool) {
        self.tokenResponseModel = tokenResponseModel
        requestConstructor = RevokeTokenRequestConstructor()
        connectService = BaseMobileConnectServiceRequest()
        self.revokedToken = revokedToken
        self.isRefreshToken = isRefreshToken
        
        super.init()
    }
    
    func getRevokeToken(_ serviceRequest : BaseMobileConnectServiceRequest? = nil, completionHandler : @escaping (_ responseModel : AnyObject?, _ error : NSError?) -> Void) {
        let revokeTokenURL : String = tokenResponseModel.discoveryResponse?.tokenRevocation ?? ""
        tokenResponseModel.discoveryResponse?.correlation_id = ""
        if let serviceRequest = serviceRequest {
            serviceRequest.callRequest(request: requestConstructor.generateRevokeRequest(revokeTokenURL, withTokenId: self.revokedToken ?? "", isRefreshToken: isRefreshToken, clientID: (self.tokenResponseModel.discoveryResponse?.response?.client_id), clientSecret: (self.tokenResponseModel.discoveryResponse?.response?.client_secret)) as! DataRequest, forCompletionHandler: completionHandler)
        } else {
            self.connectService.callRequest(request: requestConstructor.generateRevokeRequest(revokeTokenURL, withTokenId: self.revokedToken ?? "", isRefreshToken: isRefreshToken, clientID: (self.tokenResponseModel.discoveryResponse?.response?.client_id)!, clientSecret: (self.tokenResponseModel.discoveryResponse?.response?.client_secret)!) as! DataRequest, forCompletionHandler: completionHandler)
        }
    }
    
}
