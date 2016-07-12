//
//  MobileConnectManagerMock.swift
//  MobileConnectSDK
//
//  Created by jenkins on 27/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

@testable import MobileConnectSDK

class MobileConnectManagerMock: MobileConnectManager {
    
    var error : NSError?

    
    override func getTokenWithMobileConnectService(mobileConnectService: MobileConnectService, inWebController webController: BaseWebController?, withOperatorsData operatorsData: DiscoveryResponse)
    {
        let mobileConnectServiceMock : MobileConnectServiceMock = MobileConnectServiceMock(configuration: MobileConnectServiceConfiguration(discoveryResponse: operatorsData))
     
        if let error = error
        {
            mobileConnectServiceMock.error = error
        }
        else
        {
            mobileConnectServiceMock.response = Mocker.tokenResponseModel.tokenData
        }
        
        super.getTokenWithMobileConnectService(mobileConnectServiceMock, inWebController: webController, withOperatorsData: operatorsData)
    }
    
    override var tokenResponseModel : (tokenModel : TokenModel?) -> TokenResponseModel?
    {
        return { (tokenModel : TokenModel?) -> TokenResponseModel? in
            return self.error == .None ? Mocker.tokenResponseModel : nil
        }
    }
}
