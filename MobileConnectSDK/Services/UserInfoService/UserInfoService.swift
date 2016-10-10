//
//  UserInfoService.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 06/10/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

public class UserInfoService : NSObject {
    
    let requestConstructor : InfoRequestConstructor
    let tokenResponseModel : TokenResponseModel
    let connectService : BaseMobileConnectServiceRequest
    
    public convenience init(tokenResponse : TokenResponseModel)
    {
        self.init(requestConstructor: InfoRequestConstructor(accessToken: tokenResponse.tokenData?.access_token ?? ""), tokenResponse: tokenResponse)
    }
    
    init(connectService : BaseMobileConnectServiceRequest = BaseMobileConnectServiceRequest(), requestConstructor: InfoRequestConstructor, tokenResponse : TokenResponseModel) {
        self.tokenResponseModel = tokenResponse
        self.requestConstructor = requestConstructor
        self.connectService = connectService
    }
    
    public func getUserInformation(completionHandler : (responseModel : UserInfoResponse?, error : NSError?) -> Void) {
        
        let userInfoURL : String = tokenResponseModel.discoveryResponse?.userInfoEndpoint ?? ""
        self.connectService.callRequest(requestConstructor.generateInfoRequest(userInfoURL), forCompletionHandler: completionHandler)
    }
    
}
