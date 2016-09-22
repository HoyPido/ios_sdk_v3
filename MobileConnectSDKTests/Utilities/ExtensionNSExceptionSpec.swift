//
//  ExtensionNSExceptionSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 31/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import MobileConnectSDK

class ExtensionNSExceptionSpec : QuickSpec {
    
    override func spec() {
        context("check NSException extension not to throw exception", closure : {
            NSException.checkController(UIViewController())
            NSException.checkParameters([], withErrorMessage: "aa", exceptionName: "dd")
            NSException.checkAuthorizationProperty("a", withErrorName: "a", andErrorMessage: "a")
            self.checkLocalizatorMessages()
        })
        
    }
    
    func checkLocalizatorMessages() {
        context("check localizator messages", closure: {
            it("expect invalid algorithm not to be nil", closure: {
                expect(Localizator.invalidAlgorithm).notTo(beNil())
            })
            it("expect incorect delegate name not to be nil", closure: {
                expect(Localizator.incorrectDelegateName).notTo(beNil())
            })
            it("expect invalid incorrect delegate message not to be nil", closure: {
                expect(Localizator.incorrectDelegateMessage).notTo(beNil())
            })
            it("expect incorect nil client name not to be nil", closure: {
                expect(Localizator.nilClientName).notTo(beNil())
            })
            it("expect nil client secret message not to be nil", closure: {
                expect(Localizator.nilClientSecretMessage).notTo(beNil())
            })
            it("expect nil presenter message not to be nil", closure: {
                expect(Localizator.nilPresenterMessage).notTo(beNil())
            })
            it("expect nil presenter name not to be nil", closure: {
                expect(Localizator.nilPresenterName).notTo(beNil())
            })
            it("expect nil client name message not to be nil", closure: {
                expect(Localizator.nilClientNameMessage).notTo(beNil())
            })
            it("expect no scopes error not to be nil", closure: {
                expect(Localizator.noScopes).notTo(beNil())
            })
            it("expect no scopes message not to be nil", closure: {
                expect(Localizator.noScopesMessage).notTo(beNil())
            })
            it("expect unknown error not to be nil", closure: {
                expect(Localizator.unknownError).notTo(beNil())
            })
            it("expect nil client secret name not to be nil", closure: {
                expect(Localizator.nilClientSecretName).notTo(beNil())
            })
            
        })
    }
}