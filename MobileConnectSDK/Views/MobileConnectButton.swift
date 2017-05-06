//
//  MobileConnectButton.swift
//  MobileConnectSDK
//
//  Created by Andoni Dan on 06/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

import UIKit

/**
    Can be used directly in Storyboards or XIB files and at touchUpInside events will start the token obtaining process in Mobile Connect.
    In order to receive the Mobile Connect response, make sure to implement MobileConnectManagerDelegate
*/
open class MobileConnectButton: UIButton {

    // MARK: init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    convenience public init(type buttonType: UIButtonType)
    {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        configureButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    
    // MARK: Configuration
    func configureButton()
    {
        configureView()
        addTarget(self, action: #selector(MobileConnectButton.buttonTouched), for: UIControlEvents.touchUpInside)
    }
    
    func configureView()
    {
        setBackgroundImage(Resources.mobileConnectImage, for: UIControlState.normal)
        sizeToFit()
    }
    
    // MARK: Events
    @objc fileprivate func buttonTouched()
    {
        guard let presenter = containerController else
        {
            NSException.checkController(containerController)
            
            return
        }
        
        MobileConnectManager().getTokenInPresenterController(presenter, clientIP: "", withCompletionHandler: nil)
    }
    
    // MARK: Helpers
    fileprivate var containerController : UIViewController?
    {
        var localResponder : UIResponder? = self
        
        while !(localResponder is UIViewController) {
            localResponder = localResponder?.next
        }
        
        return localResponder as? UIViewController
    }
}
