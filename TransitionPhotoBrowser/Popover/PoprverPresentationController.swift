//
//  PoprverPresentationController.swift
//  MySwift
//
//  Created by 王希顺 on 16/7/13.
//  Copyright © 2016年 CCE. All rights reserved.
//

import UIKit

class PoprverPresentationController: UIPresentationController {
    
    /// 定义属性保存菜单的大小
    var presentFrame = CGRectZero
    /**
     初始化方法
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器
     
     - returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
//        print(presentedViewController)
//        print(presentingViewController) //xcode野指针

    }
    
    //即将布局转场动画
    override func containerViewWillLayoutSubviews() {
        
        //容器
//        containerView
        //被展示视图
//        presentedView()
        // 1.修改弹出视图的大小
//       presentFrame == CGRectZero

    }

    
    
    
}
