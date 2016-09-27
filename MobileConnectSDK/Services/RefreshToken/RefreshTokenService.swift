//
//  RefreshTokenService.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 23/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

class RefreshTokenService : NSObject {
    
    let tokenResponseModel : TokenResponseModel
    let requestConstructor : RefreshTokenRequestConstructor
    let connectService : BaseMobileConnectServiceRequest
    let scopes : [String]?
    
    init(tokenResponseModel : TokenResponseModel, scopes : [String]? = nil) {
        self.scopes = scopes
        self.tokenResponseModel = tokenResponseModel
        var scopeValidator : ScopeValidator? = nil
        if let discoveryResponse = tokenResponseModel.discoveryResponse {
            scopeValidator = ScopeValidator(metadata: discoveryResponse.metadata)
        }
        
        requestConstructor = RefreshTokenRequestConstructor(scopeValidator: scopeValidator, withScopes: scopes)
        
        connectService = BaseMobileConnectServiceRequest()
        super.init()
    }
    
    func getRefreshToken(serviceRequest : BaseMobileConnectServiceRequest? = nil, completionHandler: (responseModel : RefreshTokenModel?, error : NSError?) -> Void) {
        
        if(tokenResponseModel.tokenData?.refresh_token == nil) {
            completionHandler(responseModel: nil, error: MCErrorCode.InvalidRefreshToken.error)
            return
        }
        
        let refreshTokenURL : String = tokenResponseModel.discoveryResponse?.tokenRefresh ?? ""
        
        if let serviceRequest = serviceRequest {
            serviceRequest.callRequest(requestConstructor.generateRefreshRequest(refreshTokenURL, withRefreshToken: tokenResponseModel.tokenData?.refresh_token ?? ""), forCompletionHandler: completionHandler)
        } else {
            self.connectService.callRequest(requestConstructor.generateRefreshRequest(refreshTokenURL, withRefreshToken: tokenResponseModel.tokenData?.refresh_token ?? ""), forCompletionHandler: completionHandler)
        }
    }
}