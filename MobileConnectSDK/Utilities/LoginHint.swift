//
//  LoginHint.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 06/10/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

private let kPCRLoginHintPrefix = "PCR:"
private let kMSISDNLoginHintPrefix = "MSISDN:"
private let kENCRMSISDLoginHintPrefix = "ENCR_MSISDN:"

open class LoginHint {
    
    open class func generatePCRLoginHint(_ pcr:String) -> String {
        if(!pcr.isEmpty) {
            return (kPCRLoginHintPrefix + pcr)
        } else {
            return ""
        }
    }
    
    open class func generateMSISDNLoginHint(_ msisdn:String) -> String {
        if(!msisdn.isEmpty) {
            return (kMSISDNLoginHintPrefix + msisdn)
        } else {
            return ""
        }
    }
    
    open class func generateENCRMSISDNLoginHint(_ encrMsisdn:String) -> String {
        if(!encrMsisdn.isEmpty) {
            return (kENCRMSISDLoginHintPrefix + encrMsisdn)
        } else {
            return ""
        }
    }
}
