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
public class MobileConnectButton: UIButton {

    //MARK: init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    convenience public init(type buttonType: UIButtonType)
    {
        self.init(frame: CGRectMake(0, 0, 0, 0))
        configureButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    
    //MARK: Configuration
    func configureButton()
    {
        configureView()
        addTarget(self, action: #selector(MobileConnectButton.buttonTouched), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func configureView()
    {
        setBackgroundImage(Resources.mobileConnectImage, forState: UIControlState.Normal)
        sizeToFit()
    }
    
    //MARK: Events
    @objc private func buttonTouched()
    {
        guard let presenter = containerController else
        {
            NSException.checkController(containerController)
            
            return
        }
        
        //MobileConnectManager().getTokenInPresenterController(presenter, withCompletionHandler: nil)
    }
    
    //MARK: Helpers
    private var containerController : UIViewController?
    {
        var localResponder : UIResponder? = self
        
        while !(localResponder is UIViewController) {
            localResponder = localResponder?.nextResponder()
        }
        
        return localResponder as? UIViewController
    }
}
