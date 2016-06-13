//
//  DiscoveryService.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import Alamofire

/**
    The Discovery response received in methods which do not require a presenter view controller
    - Parameter operatorsData: The data received from the Discovery service. Can be nil in case an error occured.
    - Parameter error: The error which is sent in case the operatorsData is nil.
 */
public typealias DiscoveryDataResponse = (operatorsData : DiscoveryResponse?, error : NSError?) -> Void

/**
 The Discovery response received in methods which required a presenter view controller. It is the responsability of the developer to dismiss the web controller.
 - Parameter controller: The Mobile Connect controller which contains the web view. Should be dismissed by the developer.
 - Parameter operatorsData: The data received from the Discovery service. Can be nil in case an error occured.
 - Parameter error: The error which is sent in case the operatorsData is nil.
 */
public typealias DiscoveryResponseBlock = (controller : BaseWebController?, operatorsData : DiscoveryResponse?, error : NSError?) -> Void

/**
    Provides access to all needed Discovery services.
    Allows getting operator data by providing a phone number, in which case the web view will not be presented.
    Allows getting operator data without any data from the client side in which case a web view will be presented.
    The webview will require client's operator data or phone number.
 */

public class DiscoveryService: BaseMobileConnectService<DiscoveryResponse, OperatorDataRedirectModel> {
    
    //MARK: iVars
    let applicationEndpoint : String
    
    lazy var requestConstructor : DiscoveryRequestConstructor =
    {
        return DiscoveryRequestConstructor(clientKey: self.clientKey, clientSecret: self.clientSecret, redirectURL: self.redirectURL, applicationEndpoint: self.applicationEndpoint)
    }()
    
    
    //MARK: init
    ///This initializer will take all the needed discovery service data from the MobileConnectSDK data that is required to be provided by the developer
    public convenience init(){
        self.init(clientKey: MobileConnectSDK.getClientKey(), clientSecret: MobileConnectSDK.getClientSecret(), redirectURL: MobileConnectSDK.getRedirectURL(), applicationEndpoint:  MobileConnectSDK.getApplicationEndpoint())
    }
    
    init(clientKey : String, clientSecret : String, redirectURL : NSURL, applicationEndpoint : String)
    {
        NSException.checkEndpoint(applicationEndpoint)
        self.applicationEndpoint = applicationEndpoint
        
        super.init(redirectURL: redirectURL, clientKey: clientKey, clientSecret: clientSecret)
    }
    
    
    //MARK: Discovery service with no client data
    ///Gets operator data by showing a webview which will request data from client
    public func startOperatorDiscoveryInController(controller : UIViewController, completitionHandler : DiscoveryResponseBlock)
    {
        startServiceInController(controller, withRequest: self.requestConstructor.noOperatorDataRequest, completitionHandler: completitionHandler)
    }
    
    override func didReceiveResponseFromController(controller: BaseWebController?, withRedirectModel redirectModel: OperatorDataRedirectModel?, error: NSError?)
    {
        startOperatorDiscoveryWithCountryCode(redirectModel?.mcc() ?? "", networkCode: redirectModel?.mnc() ?? "", completitionHandler:
        {
            (operatorsData, error) in
            
            //in case in future versions the operatorsData will start including subscriber_id
            //at the moment the subscriber_id is only available from the previous stage
            operatorsData?.subscriber_id = operatorsData?.subscriber_id ?? redirectModel?.subscriber_id
                
            self.controllerResponse?(controller: controller, model: operatorsData, error: error)
        })
    }
    
    //MARK: Discovery service with client Country Code and Mobile Network Code
    //Gets operator data by using client's operator country code and network code. It will not return a subscriber_id as for the subcriber_id one should provide the concrete phone number.
    public func startOperatorDiscoveryWithCountryCode(countryCode : String, networkCode : String, completitionHandler : DiscoveryDataResponse)
    {
        processRequest(requestConstructor.requestWithCountryCode(countryCode, networkCode: networkCode), withParameters: [(countryCode, MCErrorCode.NilCountryCode ), (networkCode, MCErrorCode.NilNetworkCode)], inHandler: completitionHandler)
    }
    
    //MARK: Discovery service with phone number
    //Gets operator data by using client's phone number. It will return a subscriber_id.
    public func startOperatorDiscoveryForPhoneNumber(phoneNumber : String, completitionHandler : DiscoveryDataResponse)
    {
        processRequest(requestConstructor.requestWithPhoneNumber(phoneNumber), withParameters: [(phoneNumber, MCErrorCode.NilPhoneNumber)], inHandler: completitionHandler)
    }
}
