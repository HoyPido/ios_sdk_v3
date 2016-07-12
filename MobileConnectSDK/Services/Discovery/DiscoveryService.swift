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
    Provides access to all needed Discovery services.
    Allows getting operator data by providing a phone number, in which case the web view will not be presented.
    Allows getting operator data without any data from the client side in which case a web view will be presented.
    The webview will require client's operator data or phone number.
 */

class DiscoveryService: BaseMobileConnectService<DiscoveryResponse, OperatorDataRedirectModel> {
    
    //MARK: iVars
    let configuration : DiscoveryServiceConfiguration
    
    let requestConstructor : DiscoveryRequestConstructor
    
    //MARK: init
    ///This initializer will take all the needed discovery service data from the MobileConnectSDK data that is required to be provided by the developer
    init(configuration : DiscoveryServiceConfiguration = DiscoveryServiceConfiguration(), webController : BaseWebController? = WebController.existingTemplate, requestConstructor : DiscoveryRequestConstructor? = nil)
    {
        self.configuration = configuration
        
        if let requestConstructor = requestConstructor
        {
            self.requestConstructor = requestConstructor
        }
        else
        {
            self.requestConstructor = DiscoveryRequestConstructor(clientKey: configuration.clientKey, clientSecret: configuration.clientSecret, redirectURL: configuration.redirectURL, applicationEndpoint: configuration.applicationEndpoint)
        }
        
        super.init(webController: webController)
    }
    
    //MARK: Inherited
    override var redirectURL: NSURL
    {
        return configuration.redirectURL
    }
    
    //MARK: Discovery service with no client data
    /**
     Gets operator data by showing a webview which will request data from client.
     By default it will also retrieve the metadata and update the discovery response according to the metadata information.
     In case this behavior is not needed just call the function with the provideMetadata argument set to false.
     - Parameter controller: The controller in which the Discovery should present the web view controller.
     - Parameter shouldProvideMetadata: Setting this flag to false, will disable updating the operators data with metadata information.
     - Parameter completionHandler: This is the closure in which the respone of the function will be sent
     */
    func startOperatorDiscoveryInController(controller : UIViewController, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryResponseBlock)
    {
        startServiceInController(controller, withRequest: self.requestConstructor.noOperatorDataRequest, completionHandler: getMetadataWithDiscoveryControllerResponse(shouldProvideMetadata, handler: completionHandler))
    }
    
    override func didReceiveResponseFromController(controller: BaseWebController?, withRedirectModel redirectModel: OperatorDataRedirectModel?, error: NSError?)
    {
        startOperatorDiscoveryWithCountryCode(redirectModel?.mcc() ?? "", networkCode: redirectModel?.mnc() ?? "", completionHandler: { (operatorsData, error) in
            operatorsData?.subscriber_id = operatorsData?.subscriber_id ?? redirectModel?.subscriber_id
            
            self.controllerResponse?(controller: controller, model: operatorsData, error: error)
        })
    }

    //MARK: Discovery service with client Country Code and Mobile Network Code
    /**
     Gets operator data by using client's operator country code and network code.
     It will not return a subscriber_id inside the Discovery response as for the subcriber_id, one should provide the concrete phone number.
     By default it will also retrieve the metadata and update the discovery response according to the metadata information.
     In case this behavior is not needed just call the function with the provideMetadata argument set to false.
     - Parameter countryCode: The user's phone's country code.
     - Parameter networkCode: The user's phone's network code.
     - Parameter shouldProvideMetadata: Setting this flag to false, will disable updating the operators data with metadata information.
     - Parameter completionHandler: This is the closure in which the respone of the function will be sent
     */

    func startOperatorDiscoveryWithCountryCode(countryCode : String, networkCode : String, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryDataResponse)
    {
        processRequest(requestConstructor.requestWithCountryCode(countryCode, networkCode: networkCode), withParameters: [(countryCode, MCErrorCode.NilCountryCode ), (networkCode, MCErrorCode.NilNetworkCode)], inHandler: getMetadataWithDiscoveryHandler(shouldProvideMetadata, handler: completionHandler))
    }
    
    //MARK: Discovery service with phone number
    /**
     Gets operator data by using client's phone number.
     It will return a subscriber_id inside the Discovery response.
     By default it will also retrieve the metadata and update the discovery response according to the metadata information.
     In case this behavior is not needed just call the function with the provideMetadata argument set to false.
     - Parameter phoneNumber: The user's phone number.
     - Parameter shouldProvideMetadata: Setting this flag to false, will disable updating the operators data with metadata information.
     - Parameter completionHandler: This is the closure in which the respone of the function will be sent
     */
    func startOperatorDiscoveryForPhoneNumber(phoneNumber : String, shouldProvideMetadata : Bool = true, completionHandler : DiscoveryDataResponse)
    {
        processRequest(requestConstructor.requestWithPhoneNumber(phoneNumber), withParameters: [(phoneNumber, MCErrorCode.NilPhoneNumber)], inHandler: getMetadataWithDiscoveryHandler(shouldProvideMetadata, handler: completionHandler))
    }
    
    //MARK: Metadata
    func getMetadataWithDiscoveryControllerResponse(shouldRequireMetadata : Bool = true, handler : DiscoveryResponseBlock) -> DiscoveryResponseBlock
    {
        let wrappedClosure = { (controller : BaseWebController?, operatorsData : DiscoveryResponse?, localError : NSError?) -> Void in
            
            self.completeOperatorData(operatorsData, withMetadataInHandler: { (completedOperatorsData, error) in
                handler(controller: controller, operatorsData: completedOperatorsData, error: localError ?? error)
            })
        }
        
        return shouldRequireMetadata ? wrappedClosure : handler
    }
    
    func getMetadataWithDiscoveryHandler(shouldRequireMetadata : Bool = true, handler : DiscoveryDataResponse) -> DiscoveryDataResponse
    {
        let wrappedClosure = { (operatorsData : DiscoveryResponse?, localError : NSError?) -> Void in
            
            self.completeOperatorData(operatorsData, withMetadataInHandler: { (completedOperatorsData, error) in
                //ignoring the error which may come from metadata retrieval and passing the error which may come from original request
                handler(operatorsData: completedOperatorsData, error: localError ?? error)
            })
        }
        
        return shouldRequireMetadata ? wrappedClosure  : handler
    }
    
    func completeOperatorData(operatorsData : DiscoveryResponse?, withMetadataInHandler handler : (completedOperatorsData : DiscoveryResponse?, error : NSError?) -> Void)
    {
        getMetadataForOperatorData(operatorsData) { (model, error) in
            operatorsData?.metadata = model
            handler(completedOperatorsData: operatorsData, error: error)
        }
    }
    
    func getMetadataForOperatorData(operatorsData : DiscoveryResponse?, inHandler handler : (model : MetadataModel?, error : NSError?) -> Void)
    {
        let getMetadataRequest : Request = request(.GET, operatorsData?.linksInformation?.openIdConfiguration() ?? "")
        
        processSpecificRequest(getMetadataRequest, withParameters: [], inHandler: handler)
    }
}
