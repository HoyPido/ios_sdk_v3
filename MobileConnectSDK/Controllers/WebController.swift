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
    func webControllerDidCancel(controller : BaseWebController)
    func webController(controller : BaseWebController, shouldRedirectToURL url : NSURL) -> Bool
    func webController(controller : BaseWebController, failedLoadingRequestWithError error : NSError?)
}

///The mobile connect controller which is responsible for presenting and manipulating the web view.
public class BaseWebController : UIViewController, WebControllerProtocol {
    var delegate: WebControllerDelegate?
    var requestToLoad: NSURLRequest?
    
    //unfortunately this cannot be provided in the protocol extension, as protocol extensions can't be accessed by obj c runtime at the time of writing [Swift 2.2]
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
}

class WebController: BaseWebController {

    //MARK: Outlets
    @IBOutlet weak var webViewContainer: UIView!
    
    //MARK: iVars
    
    lazy var webView : WKWebView = {
        
        [weak self] in
        
        let configuration : WKWebViewConfiguration = WKWebViewConfiguration()
        
        let preferences : WKPreferences = WKPreferences()
        
        //preferences.javaScriptEnabled = false
        
        configuration.preferences = preferences
        
        let localWebView : WKWebView = WKWebView(frame: self?.webViewContainer.bounds ?? CGRectMake(0, 0, 0, 0), configuration: configuration)
        
        localWebView.navigationDelegate = self
        
        self?.webViewContainer?.addSubview(localWebView)
        
        return localWebView
    }()
    
    //MARK: View life cycle methods
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let localRequest = requestToLoad
        {
            self.webView.loadRequest(localRequest)
        }
        else
        {
            delegate?.webController(self, failedLoadingRequestWithError: MCErrorCode.NoRequestToLoad.error)
        }
    }
    
    //MARK: Web view delegate methods
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        if let url = navigationAction.request.URL, delegate = delegate
        {
            decisionHandler(delegate.webController(self, shouldRedirectToURL: url) ? WKNavigationActionPolicy.Allow : WKNavigationActionPolicy.Cancel)
        }
        else
        {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        delegate?.webController(self, failedLoadingRequestWithError: error)
    }
    
    //MARK: Events
    @IBAction func cancelAction(sender: AnyObject) {
        delegate?.webControllerDidCancel(self)
    }
}
