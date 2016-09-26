//
//  TokenRefreshSpec.swift
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

class TokenRefreshSpec : QuickSpec {
    
    override func spec() {
        
        super.spec()
        
        describe("TokenRequestConstructor") {
            self.checkRefreshTokenRequestConstructor()
            self.checkGenerateRefreshRequest()
        }
        
        describe("TokenRequestConstructor") {
            self.checkRefreshTokenService()
            self.checkGetRefreshToken(withError : MCErrorCode.Unknown.error)
            self.checkGetRefreshToken(Mocker.tokenResponseModel)
        }
    }
    
    func checkRefreshTokenRequestConstructor() {
        let refreshTokenReqConstructor = RefreshTokenRequestConstructor(withScopes:[""])
        context("check request constructor ", closure: {
            it("expect not nil object", closure: {
                expect(refreshTokenReqConstructor).toNot(beNil())
            })
        })
    }
    
    func checkGenerateRefreshRequest() {
        let refreshTokenReqConstructor = RefreshTokenRequestConstructor(withScopes:[""])
        context("check generate refresh request ", closure: {
            it("expect not nil object", closure: {
                expect(refreshTokenReqConstructor.generateRefreshRequest("", withRefreshToken: "")).toNot(beNil())
            })
        })
    }
    
    func checkRefreshTokenService() {
        let refreshTokenService = RefreshTokenService(tokenResponseModel: TokenResponseModel(tokenModel: Mocker.tokenResponseModel.tokenData, discoveryResponse: Mocker.discoveryResponseWithMetadata)!, scopes: [""])
        context("check refresh token service ", closure: {
            it("expect not nil object", closure: {
                expect(refreshTokenService).toNot(beNil())
            })
        })
    }
    
    func checkGetRefreshToken(model : MCModel? = nil, withError error : NSError? = nil) {
        if(error != nil) {
            Mocker.tokenResponseModel.tokenData?.refresh_token = nil
        } else {
            Mocker.resetModels()
        }
        
        let refreshTokenService = RefreshTokenService(tokenResponseModel: TokenResponseModel(tokenModel: Mocker.tokenResponseModel.tokenData, discoveryResponse: Mocker.discoveryResponseWithMetadata)!, scopes: ["aa"])
        let service = BaseMobileConnectServiceRequestMock()
        service.response = model
        service.error = error
        context("check get refresh token method",{
            waitUntil { (done : () -> Void) in
                refreshTokenService.getRefreshToken(service) { (responseModel, error) in
                    if refreshTokenService.tokenResponseModel.tokenData?.refresh_token != nil {
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
                }
            }
        })
    }
}