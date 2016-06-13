//
//  ExtensionDictionary.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation

func + <K, V>(left: [K:V], right: [K:V]) -> [K:V] { // 1
    var leftCopy = left
    
    for (k, v) in right {
        leftCopy.updateValue(v, forKey: k)
    }
    return leftCopy
}