//
//  ViewController.swift
//  TransitionPhotoBrowser
//
//  Created by 王希顺 on 16/7/25.
//  Copyright © 2016年 CCE. All rights reserved.
//

import UIKit

import SDWebImage

class ViewController: UIViewController {

    var imageUrls:[NSURL]?
    var rects : [CGRect]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    setUpUI()

    }
    
    func setUpUI() {
        
        imageUrls = [NSURL(string: "http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/chungaobi20160719112729.jpg")!]
        imageUrls?.append(NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/tool_mei20160718043737.jpg")!)
        imageUrls?.append(NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/new_lip320160718043534.jpg")!)
        imageUrls?.append( NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/new_face20160718043218.jpg")!)
        imageUrls?.append( NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/cat20160518052642.jpg")!)
        imageUrls?.append(NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/OL20160518053446.jpg")!)
        imageUrls?.append( NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/candy20160518043614.jpg")!)
        imageUrls?.append(NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/BLING20160518041807.jpg")!)
        imageUrls?.append(NSURL(string:"http://cceapp.blob.core.chinacloudapi.cn/blobimagecode/babi20160518040136.jpg")!)

      
        let marge = 10

        let W = Int((UIScreen.mainScreen().bounds.width-80)/3)
        
        let H = W
        rects = [CGRectMake(0, 0, 0, 0)]
        rects?.removeLast()
        for i in 0..<9 {
            
            let photoView = UIImageView()
            
            let row = i/3
            let raw = i%3
            
            photoView.frame = CGRect(x: 30+row*(W + marge), y: 100+raw*(H+marge), width: W, height: H)
            photoView.userInteractionEnabled = true
            photoView.contentMode = UIViewContentMode.ScaleAspectFit
            photoView.sd_setImageWithURL(NSURL(string:"dasdf"), placeholderImage: UIImage(named: "pleaceholder"))
            photoView.tag = i
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.presentVc(_:)))
            photoView.addGestureRecognizer(tap)
            
            view .addSubview(photoView)
            
            rects?.append(photoView.frame)
//            print(rects)
        }
        
        
        
    }

    
    func presentVc(tap:UITapGestureRecognizer) {
        
        let index = tap.view?.tag
        
        let IndexPath = NSIndexPath(forRow: index!, inSection: 0)
        
        
        let vc = PopoverViewController(urls: imageUrls!, path: IndexPath, rects: rects!)
        
        // 设置转场代理
        vc.transitioningDelegate = popoverAnimator
        
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        vc.urls = imageUrls!
        
        presentViewController(vc, animated: true, completion: nil)
        
        
    }
    

    

    private lazy var popoverAnimator:PopoerAnimator = {
        let pop = PopoerAnimator()
        pop.presentFrame = UIScreen.mainScreen().bounds
        return pop
        
    }()


}

