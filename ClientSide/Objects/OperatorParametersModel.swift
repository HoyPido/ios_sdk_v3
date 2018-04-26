//
//  OperatorParameters.swift
//  MobileConnectSDK
//
//  Created by user on 1/20/18.
//  Copyright © 2018 GSMA. All rights reserved.
//

import Foundation

public class OperatorParametersModel : MCModel
{
    var clientId : String?
    var clientSecret : String?
    var discoveryURL : String?
    var redirectURL : String?
    var xRedirect : Bool?
    var includeRequestIp : Bool?
    var apiVersion : String?
    var scope : String?
}
