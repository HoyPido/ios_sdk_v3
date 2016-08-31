//
//  BaseMobileConnectServiceSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 26/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Quick
import Nimble
import UIKit

@testable import MobileConnectSDK

private let kURLString = "https://reference.io/mobileconnect/index.php/auth?acr_values=2&client_id=x-ZWRhNjU3OWI3MGIwYTRh&client_name=test1&context=the%20context&login_hint=ENCR_MSISDN%d&nonce=A8EA1FC33DE443F8A40ED83FFD9E7740&redirect_uri=http%3A//complete/&response_type=code&scope=openid%20mc_identity_phonenumber%20phone%20openid%20mc_authz%20openid%20mc_authn&state=872DA020D1E1479F972090C793C04362"

let kReferenceRedirect : NSURL =  NSURL(string: "http://www.gooelg.com")!

class BaseMobileConnectServiceSpec : BaseServiceSpec {
    
    override func spec() {
        super.spec()
        describe("Check base mobile connect extension") { 
            self.checkKeyValueFromString()
        }
    }
    
    func checkKeyValueFromString() {
        context("check key-value from string") { 
            let dictionary = BaseMobileConnectService.keyValuesFromString(kURLString)
            it("dictionary should not be nil", closure: { 
                expect(dictionary).notTo(beNil())
            })
            
            let redirectURLIsValid = BaseMobileConnectService().isValidRedirectURL(kReferenceRedirect, inController: self.webControllerMock, redirect:kReferenceRedirect)
            
            it("check redirectURL", closure: { 
                expect(redirectURLIsValid).notTo(beTrue())
            })
            
        }
    }
    
}