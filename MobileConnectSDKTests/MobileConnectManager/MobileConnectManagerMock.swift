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
    
    var willProvideGoodMobileConnectResponse : Bool = false
    
    override func getTokenWithMobileConnectService(mobileConnectService: MobileConnectService, inWebController webController: BaseWebController?, withOperatorsData operatorsData: DiscoveryResponse)
    {
        let mobileConnectServiceMock : MobileConnectServiceMock = MobileConnectServiceMock(clientId: operatorsData.response?.client_id ?? "", authorizationURL: operatorsData.response?.apis?.operatorid?.authorizationLink() ?? "", tokenURL: operatorsData.response?.apis?.operatorid?.tokenLink() ?? "")
     
        if willProvideGoodMobileConnectResponse
        {
            mobileConnectServiceMock.response = Mocker.tokenResponseModel.tokenData
        }
        else
        {
            mobileConnectServiceMock.error = MCErrorCode.Unknown.error
        }
        
        super.getTokenWithMobileConnectService(mobileConnectServiceMock, inWebController: webController, withOperatorsData: operatorsData)
    }
}
