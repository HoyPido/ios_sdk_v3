//
//  TokenRevokeSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 26/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire
import Quick
import Nimble

@testable import MobileConnectSDK

class TokenRevokeSpec : QuickSpec {
    
    override func spec() {
        
        super.spec()
        
        describe("TokenRequestConstructor") {
            self.checkGenerateRevokeRequest()
        }
        
        describe("TokenRequestConstructor") {
            self.checkRevokeTokenService()
            self.checkRevokeToken(withError : MCErrorCode.Unknown.error)
        }
    }
    
    func checkGenerateRevokeRequest() {
        let revokeTokenReqConstructor = RevokeTokenRequestConstructor()
        context("check generate refresh request ", closure: {
            it("expect not nil object", closure: {
                expect(revokeTokenReqConstructor.generateRevokeRequest("", withTokenId: "", isRefreshToken: true)).toNot(beNil())
            })
        })
    }
    
    func checkRevokeTokenService() {
        let revokeTokenService = RevokeTokenService(revokedToken: "", tokenResponseModel: Mocker.tokenResponseModel, isRefreshToken: true)
        context("check refresh token service ", closure: {
            it("expect not nil object", closure: {
                expect(revokeTokenService).toNot(beNil())
            })
        })
    }
    
    func checkRevokeToken(withError error : NSError? = nil) {
        
        let revokeService : RevokeTokenService

        revokeService = RevokeTokenService(revokedToken: "", tokenResponseModel: Mocker.tokenResponseModel, isRefreshToken: true)

        let service = BaseMobileConnectServiceRequestMock()
        
        service.error = error
        
        context("check get refresh token method",{
            waitUntil { (done : () -> Void) in
                revokeService.getRevokeToken(service, completionHandler:{ (responseModel, error) in
                    if service.error == nil {
                        it("expect to be nil object", closure: {
                            expect(error).to(beNil())
                        })
                        done()
                    } else {
                        it("expect not nil object", closure: {
                            expect(error).notTo(beNil())
                        })
                        done()
                    }
                })
            }
        })
    }
    
}
