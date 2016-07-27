//
//  PopoverViewController.swift
//  MySwift
//
//  Created by 王希顺 on 16/7/13.
//  Copyright © 2016年 CCE. All rights reserved.
// 被推出的浏览器

import UIKit

class PopoverViewController: UIViewController {
    
/// 标记打开图片个数
     var photoIdex = 0
    
    var collectionView : UICollectionView? = nil
//    
    /// 所有需要显示的图片
    var urls: [NSURL]
    /// 当前点击的图片索引
    var path: NSIndexPath
    /// 图片的位置信息
    var rects: [CGRect]
    
    init(urls: [NSURL], path: NSIndexPath, rects: [CGRect])
    {
        self.urls = urls
        self.path = path
        self.rects = rects
        // 自定义构造方法需要调用的是designated对应的构造方法
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    
    }

    private func setUpUI() {
        
        collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds , collectionViewLayout: PhotoCollectionLayout())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "browserCell")
        
        view.addSubview(collectionView!)
        
        
         saveButton.frame = CGRect(x: UIScreen.mainScreen().bounds.width - 110, y: UIScreen.mainScreen().bounds.height - 60 , width: 100, height: 40)
        view.addSubview(saveButton)
        saveButton.layer.cornerRadius = 5.0
        saveButton.clipsToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 滚动到指定位置
        collectionView!.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    

    
    // MARK: - 懒加载
    private lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(PopoverViewController.saveBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    
    
    func saveBtnClick()
    {
        // 1.获取当前显示的索引
        let path = collectionView!.indexPathsForVisibleItems().first!
        // 2.获取当前显示的cell
        let cell = collectionView!.cellForItemAtIndexPath(path) as! PhotoCollectionViewCell
        // 3.获取当前显示的image
        guard let image = cell.iconImageView.image else
        {
            // 没有图片
            print("没有图片")
            return
        }
        
        // 保存图片
        /*
         第一个参数: 需要保存的图片
         第二个参数: 谁来监听是否保存成功
         第三个参数: 监听是否保存成功的方法名称
         第四个参数: 给监听方法传递的参数
         注意; 监听是否保存成功的方法必须是系统指定的方法
         - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
         */
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PopoverViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?)
    {
        if error != nil
        {
           AlertView .alertView("保存失败", originY: 500)
            print("失败")
            return
        }
        print("成功")
        AlertView .alertView("保存成功", originY: 500)

    }
    
}


extension PopoverViewController : UICollectionViewDelegate,UICollectionViewDataSource,PhotoCollectionViewCellDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("browserCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.delegate = self

        
        if photoIdex <= 0 {
            cell.isfirstCell = true
        }else {
            cell.isfirstCell = false
        }
        photoIdex += 1
        
        cell.rect = rects[indexPath.item]
        cell.url = urls[indexPath.item]
        
        return cell
    }
    
    
    func browserCollectionViewCellDidClick(cell: PhotoCollectionViewCell) {

        dismissViewControllerAnimated(true, completion: nil)
    }
    
}


class PhotoCollectionLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.pagingEnabled = true
    }
}