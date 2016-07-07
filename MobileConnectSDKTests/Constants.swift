//
//  Constants.swift
//  MobileConnectSDK
//
//  Created by jenkins on 26/06/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

let kRedirectURLString : String = "https://test.test.com"
let kRedirectURL : NSURL = NSURL(string: kRedirectURLString)!
let kClientKey : String = "a25e91c5-ab1e-4f9e-9fd9-4cd1482c0a48"
let kClientSecret : String = "1d95d440-49fe-455e-8fd4-b5903b8c78ec"
let kApplicationEndpoint : String = "http://discovery.sandbox2.mobileconnect.io/v2/discovery"

private let kDiscoveryRedirectURLString : String = "http://complete/?mcc_mnc=001_001&subscriber_id=13320605eaf9f7f8361a3cfe3c5f5c3cb2044cb926e47bef42f07d4fb20da16ee73afd3cfe20185c45d244257677b1a3b17198587b8641e057809ff1da06077c8d2ca572943804c5ab53fa6502528d38d1d2cd32c1d927b90bd192a1fe81f681f269736ee43bd3ad40053154611612b92b5c477518caf427ebab3305e0e719c09674f11341366eeab3654e7c8394af1d894c0670f0001c963a0c704c7773e02141f706dfd88b32a00ba81c8240f0be8c30cd3b04e787fc4c3c923d4890329f1060d435730387bdd20bab344fe8aef75da2e8adeb05bfb684d64f8225ca3ffff9106afc45174af08fad57cc6b32fed939a45dd8297b23bc917042c50bbe962148"

let kDiscoveryRedirectURL : NSURL = NSURL(string: kDiscoveryRedirectURLString)!