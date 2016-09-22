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
    
    func getRevokeToken(completionHandler : (responseModel : AnyObject?, error : NSError?) -> Void) {
        let revokeTokenURL : String = tokenResponseModel.discoveryResponse?.tokenRevocation ?? ""
        
        self.connectService.callRequest(requestConstructor.generateRevokeRequest(revokeTokenURL, withTokenId: self.revokedToken ?? "", isRefreshToken: isRefreshToken), forCompletionHandler: completionHandler)
    }
    
}