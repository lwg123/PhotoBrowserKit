//
//  PicCollectionView.swift
//  PhotoBrowser
//
//  Created by weiguang on 2017/5/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

let ShowPhotoBrowserNote = "ShowPhotoBrowseNote"
let ShowPhotoBrowserIndexKey = "ShowPhotoBrowserIndexKey"
let ShowPhotoBrowserDatasKey = "ShowPhotoBrowserDatasKey"
private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

let cellIdentifier = "Cell"

class PicCollectionView: UICollectionView {

    lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    var picDatas: [String] = [String](){
        didSet {
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
        
        picDatas = ["1","2","3","4","5","6","7","8","9","17","10","11","12","13","14","15","16"]
        setupUI()
    }
}

extension PicCollectionView {
    fileprivate func setupUI() {
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 设置图片的layout
        let imageViewH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewH, height: imageViewH)
    }
}

extension PicCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PicCollectionViewCell
        
        cell.iconView.image = UIImage(named: picDatas[indexPath.item])
        cell.iconView.contentMode = .scaleAspectFill
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoBrowserVC = PhotoBrowserViewController(indexPath: indexPath, picDatas: picDatas)
        photoBrowserVC.modalPresentationStyle = .custom
        
        //设置转场代理
        photoBrowserVC.transitioningDelegate = photoBrowserAnimator
        
        // 设置动画的代理
        photoBrowserAnimator.presentedDelegate = self
        photoBrowserAnimator.dismissDelegate = photoBrowserVC
        photoBrowserAnimator.indexPath = indexPath
        
        UIApplication.shared.keyWindow?.rootViewController?.present(photoBrowserVC, animated: true, completion: nil)
    }
}

extension PicCollectionView : AnimatorPresentedDelegate {

    func startRect(indexPath: IndexPath) -> CGRect {
        let cell = cellForItem(at: indexPath)!
        
        let startFrame = convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        
        let pic = picDatas[indexPath.item]
        let image = UIImage(named: pic)!
        
        let width = UIScreen.main.bounds.width
        let height = width / image.size.width * image.size.height
        
        var y: CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: width, height: height)
        
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        
        // 获取该位置的image
        let pic = picDatas[indexPath.item]
        let image = UIImage(named: pic)!
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}






class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!

}





