//
//  UserInfoService.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 06/10/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

open class UserInfoService : NSObject {
    
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
    
    open func getUserInformation(_ completionHandler : @escaping (_ responseModel : UserInfoResponse?, _ error : NSError?) -> Void) {
        let userInfoURL : String = tokenResponseModel.discoveryResponse?.userInfoEndpoint ?? ""
        self.connectService.callRequest(request: requestConstructor.generateInfoRequest(userInfoURL) as! DataRequest, forCompletionHandler: completionHandler)

    }
    
}
