//
//  PhotoBrowserViewController.swift
//  PhotoBrowser
//
//  Created by weiguang on 2017/5/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

let PhotoBrowsercell = "PhotoBrowsercell"

class PhotoBrowserViewController: UIViewController {

    var indexPath: IndexPath
    var picDatas: [String]
    
    lazy var hudView: UIView = UIView()
    lazy var collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: PhotoBrowserCollectionViewLayout())
   
    // 自定义构造函数
    init(indexPath: IndexPath, picDatas: [String]) {
        self.indexPath = indexPath
        self.picDatas = picDatas
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.frame.size.width += 20  // 此处更改view的frame
        
        setupUI()
        
        // 滚动到对应的图片
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoBrowserViewController.closePhotoBrowser), name: NSNotification.Name(rawValue: scrollViewClickNote), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoBrowserViewController.longPressGes), name: NSNotification.Name(rawValue: longPressGesNote), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


// 监听通知关闭图片浏览器
extension PhotoBrowserViewController {
    @objc fileprivate func closePhotoBrowser() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func longPressGes() {
        // 添加蒙版
        hudView.isHidden = false
        
        // 添加保存取消按钮
        let alertVC: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "保存图片", style: .default) { (_) in
            print("保存当前图片")
            self.hudView.isHidden = true
            self.savePhoto()
        }
        
        let action2 = UIAlertAction(title: "转发", style: .default) { (_) in
            self.hudView.isHidden = true
            print("转发")
        }
        
        let action3 = UIAlertAction(title: "取消", style: .cancel) { (_) in
            self.hudView.isHidden = true
        }
        
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        alertVC.addAction(action3)
        self.present(alertVC, animated: true, completion: nil)
    }
}

// 保存照片
extension PhotoBrowserViewController {
    @objc fileprivate func savePhoto() {
        // 1.获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        // 2.将image对象保存在相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.savedPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc fileprivate func savedPhotosAlbum(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        print(showInfo)
        
    }
    
}

extension PhotoBrowserViewController: UICollectionViewDataSource {
    // 设置UI
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(hudView)
        
        hudView.frame = view.bounds
        hudView.backgroundColor = UIColor.darkGray
        hudView.alpha = 0.5
        hudView.isHidden = true
        
        // 给蒙版添加点击手势，点击后隐藏
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserViewController.hudViewClick))
        hudView.addGestureRecognizer(tapGes)
        
        // 注册cell
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowsercell)
        collectionView.dataSource = self
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowsercell, for: indexPath) as! PhotoBrowserViewCell
        
        cell.data = picDatas[indexPath.item]
        
        return cell
        
    }

}

// 监听点击事件
extension PhotoBrowserViewController {
    @objc fileprivate func hudViewClick() {
        hudView.isHidden = true
    }
}


extension PhotoBrowserViewController : AnimatorDismissedDelegate {
    
    func indexPathForDismissView() -> IndexPath {
        let cell = collectionView.visibleCells.first!
        
        return collectionView.indexPath(for: cell)!
    }
    
    func imageViewForDismissView() -> UIImageView {
        let imageView = UIImageView()
        
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.image = cell.imageView.image
        imageView.frame = cell.imageView.frame
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }

}


class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}





