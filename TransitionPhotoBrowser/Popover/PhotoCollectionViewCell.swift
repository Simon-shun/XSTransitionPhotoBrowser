//
//  PhotoCollectionViewCell.swift
//  TransitionPhotoBrowser
//
//  Created by 王希顺 on 16/7/26.
//  Copyright © 2016年 CCE. All rights reserved.
//

import UIKit
import SnapKit

protocol PhotoCollectionViewCellDelegate: NSObjectProtocol
{
    func browserCollectionViewCellDidClick(cell: PhotoCollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    /// 代理
    // 注意: 代理属性前面一定要写weak
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    var offsetY :CGFloat?
    
    var isZoomed :Bool = false
    
    
    var isfirstCell :Bool = false
   
    var rect:CGRect?
        {
        didSet{
            }
        }
    
    
    var url: NSURL?
        {
        didSet{
            setUrl()
        }
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.添加子控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconImageView)
        scrollview.addSubview(activityIndicatorView)

        
        // 2.布局子控件
        scrollview.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
  
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUrl() {
        // 1.重置
        reset()
        
        // 2.显示提醒视图
        activityIndicatorView.frame = rect!
        activityIndicatorView.startAnimating()
        
        // 3.设置图片
        iconImageView.sd_setImageWithURL(url) { (image, error, _, _) -> Void in
            
            // 0.隐藏提醒视图
            self.activityIndicatorView.stopAnimating()
            
            // 屏幕宽高
            let screenWidth = UIScreen.mainScreen().bounds.width
            let screenHeight = UIScreen.mainScreen().bounds.height
            
            // 1.按照宽高比缩放图片
            let scale = image.size.height / image.size.width
            let height = scale * screenWidth
            // 2.判断是长图还是短图
            if height < screenHeight
            {
                // 短图, 需要居中
                //1.1计算偏移位
                self.offsetY = (screenHeight - height) * 0.5
                
                // 1.2设置偏移位
                self.scrollview.contentInset = UIEdgeInsets(top: self.offsetY!, left: 0, bottom: self.offsetY!, right: 0)
            }else
            {
                // 长图, 不需要居中
                self.scrollview.contentSize = self.iconImageView.frame.size
            }
            
            if self.isfirstCell {
                
                self.iconImageView.frame = self.rect!
                self.iconImageView.frame.origin.y  = (self.rect?.origin.y)! - self.offsetY!
                
                
                UIView.animateWithDuration(0.5, delay: 0.2, options:UIViewAnimationOptions(rawValue: 0), animations: {
                    
                    self.iconImageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: screenWidth, height: height))
                    
                    }, completion: nil)
                
            }else {
                self.iconImageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: screenWidth, height: height))
                
            }
        }

    }
    
    
    // 重置所有属性
    private func reset()
    {
        scrollview.contentSize = CGSizeZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentInset = UIEdgeInsetsZero
        iconImageView.transform = CGAffineTransformIdentity
        
    }
    
    @objc private func imageClick()
    {
        self.superview?.backgroundColor = UIColor.clearColor()

      scrollview.backgroundColor = UIColor.clearColor()
        if isZoomed {
            scrollview.zoomToRect(CGRect(origin:CGPointZero, size: iconImageView.frame.size), animated: true)
        }
        UIView.animateWithDuration(0.5, animations: {
            
            self.iconImageView.frame = CGRect(origin: CGPointMake(self.rect!.origin.x, self.rect!.origin.y - self.offsetY!), size: self.rect!.size)

        }) { (_) in
            // 通知代理关闭图片浏览器
            self.delegate?.browserCollectionViewCellDidClick(self)
        }
    }
    
    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = {
        let sl = UIScrollView()
        
        // 和缩放相关的设置
        sl.minimumZoomScale = 1.0
        sl.maximumZoomScale = 2.5
        sl.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoCollectionViewCell.imageClick))
        sl.addGestureRecognizer(tap)
        return sl
    }()
    
    lazy var iconImageView: UIImageView =  {
        let iv = UIImageView()
        iv.userInteractionEnabled = true
        iv.contentMode = UIViewContentMode.ScaleAspectFit
        return iv
    }()
    
    private lazy var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
}

extension PhotoCollectionViewCell: UIScrollViewDelegate
{
    // 告诉系统需要缩放谁
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return iconImageView
    }
    
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        // 调整图片的位置, 让图片居中
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        var offsetY = (screenHeight - iconImageView.frame.height) * 0.5
        var offsetX = (screenWidth - iconImageView.frame.width) * 0.5
        // 注意: 当偏移位小于0时会导致图片无法拖拽查看完整图片, 所以当偏移位小于0时需要复位为0
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        self.offsetY = offsetY
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        isZoomed = true
    }
}