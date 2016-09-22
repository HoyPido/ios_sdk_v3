//
//  DSServiceSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 29/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class DSServiceSpec : BaseServiceSpec {
    
    override func spec() {
        super.spec()
        
        self.startOperatorDiscoveryWithCountryCode()
        self.startOperatorDiscoveryForPhoneNumber()
        self.checkRedirectURL()
    }
    
    func startOperatorDiscoveryWithCountryCode() {
        describe("operator discovery") {
            context("fail with country code",{
                waitUntil(timeout:10) {
                    (done : () -> Void) in
                    
                    self.mockedService.startOperatorDiscoveryInController(self.viewController) {
                        (controller, operatorsData, error) in
                        it("should have error", closure: {
                            expect(error).notTo(beNil())
                        })
                    }
                    
                    self.mockedService.startOperatorDiscoveryWithCountryCode("+44",networkCode: "07") {
                        (operatorsData , error) in
                        it("should have error", closure: {
                            expect(error).notTo(beNil())
                        })
                        done()
                    }
                }
            })
        }
    }
    
    func startOperatorDiscoveryForPhoneNumber() {
        describe("operator discovery") {
            context("fail with phone number",{
                waitUntil(timeout:10) {
                    (done : () -> Void) in
                    self.mockedService.startOperatorDiscoveryForPhoneNumber("+440700100040") {
                        (operatorsData, error) in
                        it("should have error", closure: {
                            expect(error).notTo(beNil())
                        })
                        done()
                    }
                }
            })
        }
    }
    
    func checkRedirectURL() {
        context("check redirectURL",{
            waitUntil {
                (done : () -> Void) in
                
                    it("should not be nil", closure: {
                        expect(self.mockedService.service.redirectURL).notTo(beNil())
                    })
                    done()
            }
        })
    }
    
    var discoveryWithMetadata : DSServiceMock
    {
        let discovery : DSServiceMock = self.mockedService
        self.webControllerMock.redirectURLMockValue = kDiscoveryRedirectURL
    
        discovery.response = Mocker.discoveryResponse
    
        let metadata : MetadataModel = Mocker.metadata
    
        metadata.insertMockData(Mocker.metadataServicesMock, authorizationEndpoint: Mocker.metadataAuthorizationEndpointMock, tokenEndpoint: Mocker.metadataTokenEndpointMock, userInfoEndpoint: Mocker.metadataUserInfoEndpointMock, premiumInfoEndpoint: Mocker.metadataPremiumInfoEndpointMock, tokenRevocation: Mocker.metadataRevokeEndpointMock)
    
        discovery.metadata = metadata
    
        return discovery
    }
    
    var mockedService : DSServiceMock {
        let mock = DSServiceMock()
        let ds = DiscoveryService(configuration: DiscoveryServiceConfiguration(), webController: webControllerMock)
        mock.service = ds
        return mock
    }

}
