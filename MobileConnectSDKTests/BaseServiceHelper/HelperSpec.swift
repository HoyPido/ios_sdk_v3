//
//  HelperSpec.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 17/08/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble

@testable import MobileConnectSDK

private let kAttributeResponseModelPlistName : String = "attributeResponseModel"
private let kPlistExtension : String = "plist"

class HelperSpec<RedirectModel:MCModel>: QuickSpec {
  
  func getMockDictionary() -> NSDictionary {
    let bundle : NSBundle = NSBundle(forClass: HelperSpec.classForCoder())
    let url : NSURL = bundle.URLForResource(kAttributeResponseModelPlistName, withExtension: kPlistExtension)!
    return NSDictionary(contentsOfURL: url)!
  }
  
  override func spec() {
    
    super.spec()
    
    describe("Deserialize object") {
      self.checkDeserializer(false)
      self.checkDeserializer(true)
    }
  }
  
  func checkDeserializer(hasError:Bool) {
    let dictionary : NSDictionary?
    
    if(hasError) {
      dictionary = nil
    } else {
      dictionary = getMockDictionary()
    }
    
    let deserializeObject = BaseMobileConnectServiceDeserializer(dictionary: dictionary)
    
    waitUntil { (done:() -> Void) in
      deserializeObject?.deserializeModel{ (model, error) in
        it("should deserializeObject", closure: {
          expect(model).notTo(beNil())
        })
      }
      done()
    }
  }
  
}

