//
//  ViewController.swift
//  PhotoBrowser
//
//  Created by weiguang on 2017/5/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: PicCollectionView!
    
    lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showPhotoBrowser(note:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
        
    }

}

/*
 // 如果不能直接弹出控制器可以通过通知来实现
extension ViewController {
    
    @objc fileprivate func showPhotoBrowser(note: Notification) {
        // 1.取出数据
        let indexPath = note.userInfo?[ShowPhotoBrowserIndexKey] as! IndexPath
        let data = note.userInfo?[ShowPhotoBrowserDatasKey] as! [String]
        let object = note.object as! PicCollectionView
        
        let photoBrowserVC = PhotoBrowserViewController(indexPath: indexPath, picDatas: data)
        photoBrowserVC.modalPresentationStyle = .custom
        
        //设置转场代理
        photoBrowserVC.transitioningDelegate = photoBrowserAnimator
        
        // 设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.dismissDelegate = photoBrowserVC
        photoBrowserAnimator.indexPath = indexPath
        
        present(photoBrowserVC, animated: true, completion: nil)
    }
    
}
 */





