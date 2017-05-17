//
//  PhotoBrowserViewCell.swift
//  PhotoBrowser
//
//  Created by weiguang on 2017/5/17.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

let scrollViewClickNote = "scrollViewClickNote"
let longPressGesNote = "longPressGesNote"

class PhotoBrowserViewCell: UICollectionViewCell {
    
    // MARK : - 定义属性
    var data: String? {
        didSet {
            setupData(data: data)
        }
    }
    
    // 懒加载属性
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension PhotoBrowserViewCell {
    fileprivate func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        // 设置子控件frame
        scrollView.frame = contentView.frame
        scrollView.frame.size.width -= 20
        
        // 添加点击手势
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserViewCell.scrollViewClick))
        scrollView.addGestureRecognizer(gesture)
        
        // 添加长按手势
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(PhotoBrowserViewCell.longPressGes))
        scrollView.addGestureRecognizer(longPressGes)
    }
    
    
}

// 监听点击事件
extension PhotoBrowserViewCell {
    @objc fileprivate func scrollViewClick() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: scrollViewClickNote), object: nil)
    }
    
    @objc fileprivate func longPressGes() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: longPressGesNote), object: nil)
    }
}

extension PhotoBrowserViewCell {
    fileprivate func setupData(data: String?) {
        guard let data = data else {
            return
        }
        
        // 取出image对象
        let image = UIImage(named: data)!
        
        // 计算imageView的frame
        let width = UIScreen.main.bounds.width
        let height = width / image.size.width * image.size.height
        var y: CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        imageView.image = image
        
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
}




