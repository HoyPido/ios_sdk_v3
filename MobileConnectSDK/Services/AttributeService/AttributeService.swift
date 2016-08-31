//
//  AttributeService.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 15/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

public class AttributeService : NSObject {
  
  let requestConstructor : AttributeRequestConstructor
  let tokenResponseModel : TokenResponseModel
  let connectService : BaseMobileConnectServiceRequest
    
  public convenience init(tokenResponse : TokenResponseModel)
  {
    self.init(requestConstructor: AttributeRequestConstructor(accessToken: tokenResponse.tokenData?.access_token ?? ""), tokenResponse: tokenResponse)
  }
  
  init(connectService : BaseMobileConnectServiceRequest = BaseMobileConnectServiceRequest(), requestConstructor: AttributeRequestConstructor, tokenResponse : TokenResponseModel) {
    self.tokenResponseModel = tokenResponse
    self.requestConstructor = requestConstructor
    self.connectService = connectService
  }
  
  public func getAttributeInformation(completionHandler : (responseModel : AttributeResponseModel?, error : NSError?) -> Void) {
    let premiumInfoURL : String = tokenResponseModel.discoveryResponse?.premiumInfoEndpoint ?? ""
    self.connectService.callRequest(requestConstructor.generatePremiumInfoRequest(premiumInfoURL), forCompletionHandler: completionHandler)
  }
  
}
