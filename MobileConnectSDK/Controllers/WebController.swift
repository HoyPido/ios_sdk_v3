//
//  WebController.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 06/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

protocol WebControllerDelegate
{
    func webControllerDidCancel(_ controller : BaseWebController)
    func webController(_ controller : BaseWebController, shouldRedirectToURL url : URL) -> Bool
    func webController(_ controller : BaseWebController, failedLoadingRequestWithError error : NSError?)
}

///The mobile connect controller which is responsible for presenting and manipulating the web view.
open class BaseWebController : UIViewController, WebControllerProtocol {
    var delegate: WebControllerDelegate?
    var requestToLoad: URLRequest?
    
    //unfortunately this cannot be provided in the protocol extension, as protocol extensions can't be accessed by obj c runtime at the time of writing [Swift 2.2]
    open func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

class WebController: BaseWebController {

    // MARK: Outlets
    @IBOutlet weak var webViewContainer: UIView!
    
    // MARK: iVars
    
    lazy var webView : WKWebView = {
        
        [weak self] in
        
        let configuration : WKWebViewConfiguration = WKWebViewConfiguration()
        
        let preferences : WKPreferences = WKPreferences()
        
        //preferences.javaScriptEnabled = false
        
        configuration.preferences = preferences
        
        let localWebView : WKWebView = WKWebView(frame: self?.webViewContainer.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0), configuration: configuration)
        
        localWebView.navigationDelegate = self
        
        self?.webViewContainer?.addSubview(localWebView)
        
        return localWebView
    }()
    
    // MARK: View life cycle methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let localRequest = requestToLoad
        {
            self.webView.load(localRequest)
        } else
        {
            delegate?.webController(self, failedLoadingRequestWithError: MCErrorCode.noRequestToLoad.error)
        }
    }
    
    // MARK: Web view delegate methods
    func webView(_ webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        if let url = navigationAction.request.url, let delegate = delegate
        {
            decisionHandler(delegate.webController(self, shouldRedirectToURL: url) ? WKNavigationActionPolicy.allow : WKNavigationActionPolicy.cancel)
        } else
        {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        delegate?.webController(self, failedLoadingRequestWithError: error)
    }
    
    // MARK: Events
    @IBAction func cancelAction(_ sender: AnyObject) {
        delegate?.webControllerDidCancel(self)
    }
}
