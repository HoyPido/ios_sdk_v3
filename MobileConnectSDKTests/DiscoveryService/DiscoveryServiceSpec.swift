//
//  DiscoveryServiceSpec.swift
//  MobileConnectSDK
//
//  Created by jenkins on 05/07/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

class DiscoveryServiceSpec: BaseServiceSpec {
    
    override func spec() {
        
        super.spec()
        
        describe("DiscoveryService") {
            self.concurrency()
            self.noWebController()
            self.checkMetadata()
        }
    }
    
    func concurrency()
    {
        context("is awaiting response", closure: {
            
            let discovery = self.mockedService
            
            discovery.isAwaitingResponse = true
            discovery.shouldCallSuper = true
            
            waitUntil(action: { (done : () -> Void) in
                discovery.startOperatorDiscoveryInController(self.viewController, completionHandler:
                {
                    (controller, operatorsData, error) in
            
                    it("cant run 2 concurrent requests", closure: {
                        expect(error?.code).to(be(MCErrorCode.Concurrency.error.code))
                    })
                    
                    done()
                })
            })
        })
    }
    
    func noWebController()
    {
        context("has nil web controller") {
            
            let discovery : DiscoveryServiceMock = self.mockedService
            
            discovery.webController = nil
            discovery.shouldCallSuper = true
            
            waitUntil(action: { (done : () -> Void) in
                
                discovery.startOperatorDiscoveryInController(self.viewController, completionHandler: { (controller, operatorsData, error) in
                    
                    it("not awaiting response", closure: { 
                        expect(discovery.isAwaitingResponse).toNot(beTrue())
                    })
                    
                    it("has nil web controller error", closure: { 
                        expect(error?.code).to(be(MCErrorCode.WebControllerNil.error.code))
                    })
                    
                    done()
                })
                
            })
        }
    }
    
    func checkMetadata()
    {
        describe("metadata") {
            
            context("has been required", closure: {
                
                waitUntil(action: { (done : () -> Void) in
                    
                    self.discoveryWithMetadata.startOperatorDiscoveryForPhoneNumber("12312", shouldProvideMetadata: true, completionHandler: { (operatorsData, error) in
                        
                        it("has metadata", closure: {
                            expect(operatorsData?.metadata).toNot(beNil())
                        })
                        
                        itBehavesLike(kNameMetadataConfiguration, sharedExampleContext: { () -> (NSDictionary) in
                            
                            let dictionary : NSMutableDictionary = [:]
                            
                            if let operatorsData = operatorsData
                            {
                                dictionary[kKeyMetadataOperatorResponse] = operatorsData
                            }
                            
                            return dictionary.copy() as! NSDictionary
                        })
                        
                        done()
                    })
                })
            })
            
            context("has been disallowed", closure: { 
                
                waitUntil(action: { (done : () -> Void) in
                    
                    self.discoveryWithMetadata.startOperatorDiscoveryForPhoneNumber("12312", shouldProvideMetadata: false, completionHandler:
                    {
                        (operatorsData, error) in
                    
                        it("should not have metadata", closure: {
                            expect(operatorsData?.metadata).to(beNil())
                        })
                        
                        done()
                    })
                })
            })
        }
    }
    
    //MARK: Helpers
    func checkMetadataValue(metadataValue : String?, againstMockValue mockValue : String?)
    {
        expect(metadataValue == mockValue).to(beTrue())
    }
    
    var discoveryWithMetadata : DiscoveryServiceMock
    {
        let discovery : DiscoveryServiceMock = self.mockedService
        self.webControllerMock.redirectURLMockValue = kDiscoveryRedirectURL
        
        discovery.response = Mocker.discoveryResponse
        
        let metadata : MetadataModel = Mocker.metadata
        
        metadata.insertMockData(Mocker.metadataServicesMock, authorizationEndpoint: Mocker.metadataAuthorizationEndpointMock, tokenEndpoint: Mocker.metadataTokenEndpointMock, userInfoEndpoint: Mocker.metadataUserInfoEndpointMock, premiumInfoEndpoint: Mocker.metadataPremiumInfoEndpointMock, tokenRevocation: Mocker.metadataRevokeEndpointMock)
        
        discovery.metadata = metadata
        discovery.shouldCallSuper = true

        return discovery
    }
    
    var mockedService : DiscoveryServiceMock
    {
        let service : DiscoveryServiceMock = DiscoveryServiceMock(configuration: DiscoveryServiceConfiguration(), webController: webControllerMock)
        
        service.isAwaitingResponse = false
        
        return service
    }
}
