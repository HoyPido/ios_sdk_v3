//
//  MetadataConfiguration.swift
//  MobileConnectSDK
//
//  Created by jenkins on 06/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

let kNameMetadataConfiguration : String = "metadata"

let kKeyMetadataOperatorResponse : String = "response"

class MetadataConfiguration: QuickConfiguration {

    override class func configure(configuration : Configuration)
    {
        sharedExamples(kNameMetadataConfiguration) { (sharedExampleContext : SharedExampleContext) in
         
            let operatorsData : DiscoveryResponse? = sharedExampleContext()[kKeyMetadataOperatorResponse] as? DiscoveryResponse
            
            it("has overriden services", closure: {
                
                let firstService : String = Mocker.metadataServicesMock.first!
            
            expect(operatorsData?.isMobileConnectServiceSupported(firstService)).to(beTrue())
            })
            
            it("has overriden authorization", closure: {
                self.checkMetadataValue(operatorsData!.authorizationEndpoint, againstMockValue: Mocker.metadataAuthorizationEndpointMock)
            })
            
            it("has overriden token", closure: {
                self.checkMetadataValue(operatorsData?.tokenEndpoint, againstMockValue: Mocker.metadataTokenEndpointMock)
            })
            
            it("has overriden userinfo", closure: {
                self.checkMetadataValue(operatorsData?.userInfoEndpoint, againstMockValue: Mocker.metadataUserInfoEndpointMock)
            })
            
            it("has overriden premium info", closure: {
                self.checkMetadataValue(operatorsData?.premiumInfoEndpoint, againstMockValue: Mocker.metadataPremiumInfoEndpointMock)
            })
            
            it("has overriden revoke", closure: {
                self.checkMetadataValue(operatorsData?.tokenRevocation, againstMockValue: Mocker.metadataRevokeEndpointMock)
            })
        }
    }
    
    class func checkMetadataValue(metadataValue : String?, againstMockValue mockValue : String?)
    {
        expect(metadataValue == mockValue).to(beTrue())
    }
}
