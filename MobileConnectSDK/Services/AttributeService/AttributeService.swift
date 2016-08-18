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
  
  public convenience init(tokenResponse : TokenResponseModel)
  {
    self.init(requestConstructor: AttributeRequestConstructor(accessToken: tokenResponse.tokenData?.access_token ?? ""), tokenResponse: tokenResponse)
  }
  
  init(requestConstructor: AttributeRequestConstructor, tokenResponse : TokenResponseModel) {
    self.tokenResponseModel = tokenResponse
    self.requestConstructor = requestConstructor
  }
  
  public func getAttributeInformation(completionHandler : (responseModel : AttributeResponseModel?, error : NSError?) -> Void) {

    let premiumInfoURL : String = tokenResponseModel.discoveryResponse?.premiumInfoEndpoint ?? ""
    
    BaseMobileConnectServiceRequest.callRequest(requestConstructor.generatePremiumInfoRequest(premiumInfoURL), forCompletionHandler: completionHandler)
  }
  
}
