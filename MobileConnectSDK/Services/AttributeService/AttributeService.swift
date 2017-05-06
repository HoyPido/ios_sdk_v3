//
//  AttributeService.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 15/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

open class AttributeService : NSObject {
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
    
    open func getAttributeInformation(_ completionHandler : @escaping (_ responseModel : AttributeResponseModel?, _ error : NSError?) -> Void) {
        let premiumInfoURL : String = tokenResponseModel.discoveryResponse?.premiumInfoEndpoint ?? ""
        self.connectService.callRequest(request: requestConstructor.generateInfoRequest(premiumInfoURL) as! DataRequest, forCompletionHandler: completionHandler)
    }
    
}
