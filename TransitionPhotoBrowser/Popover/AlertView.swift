//
//  AlertView.swift
//  TransitionPhotoBrowser
//
//  Created by 王希顺 on 16/7/27.
//  Copyright © 2016年 CCE. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    init(text:String,originY:CGFloat) {
        
        super.init(frame: CGRectZero)
        
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textColor = UIColor.blackColor()
        textLabel.sizeToFit()
        textLabel.numberOfLines = 0
        
        
        view.addSubview(textLabel)
        view.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width-textLabel.frame.size.width)/2.0, originY, 100, textLabel.frame.size.height+10)
        textLabel.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0)
        kCurrentViewController().view.addSubview(view)
        
        
        view.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
        UIView.animateWithDuration(0.3, animations: {
            view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
            }) { (_) in
                
        }
        
        let time: NSTimeInterval = 1.0
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            
            view.removeFromSuperview()
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func alertView(text:String,originY:CGFloat) -> AlertView
    {
        let view = AlertView(text: text, originY: originY)
        
        return view
        
    }
    
    func kCurrentViewController() -> UIViewController {
        
        var targetVc:UIViewController?
        
        let rooterView = UIApplication.sharedApplication().keyWindow?.rootViewController;
        
        if rooterView!.isKindOfClass(UITabBarController.self) {
            let baseTabbar = rooterView as! UITabBarController
            let baseNav = baseTabbar.selectedViewController as! UINavigationController;
            targetVc = baseNav.topViewController;
            
        }else if rooterView!.isKindOfClass(UINavigationController.self) {
            
            let baseNav = rooterView as!UINavigationController;
            targetVc = baseNav.topViewController;
        }else{
            targetVc = rooterView;
        }
        
        if ((targetVc?.presentedViewController) != nil) {
            
            if targetVc!.presentedViewController!.isKindOfClass(UINavigationController.self) {
                
                let nav = targetVc!.presentedViewController as! UINavigationController;
                targetVc = nav.topViewController;
            }
            else{
                targetVc = targetVc!.presentedViewController;
            }
        }
        return targetVc!;
    }
    
    
}
