//
//  ViewController.swift
//  PhotoFilters
//
//  Created by lemo on 2018/7/12.
//  Copyright © 2018年 wangli. All rights reserved.
//  给图片加上滤镜
//  参考内容: Apply Photo Filters With Core Image in Swift(swift 2.0) https://code.tutsplus.com/tutorials/ios-sdk-apply-photo-filters-with-core-image-in-swift--cms-27142
/*
 滤镜类型苹果 API: https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
 
 一共有14个大类:
 模糊效果类别
 CICategoryBlur
 颜色调节类别
 CICategoryColorAdjustment
 颜色影响类别
 CICategoryColorEffect
 符合操作类别
 CICategoryCompositeOperation
 失真效应类别
 CICategoryDistortionEffect
 发电器类别
 CICategoryGenerator
 几何调整类别
 CICategoryGeometryAdjustment
 梯度类别
 CICategoryGradient
 半色调效果
 CICategoryHalftoneEffect
 减少类别
 CICategoryReduction
 锐化类别
 CICategorySharpen
 传统类别
 CICategoryStylize
 瓦片效果类别
 CICategoryTileEffect
 过渡类别
 CICategoryTransition
 */

//问题总结: 由于 CIContext 会占用比较大的内存,最好值创建一个复用就行.开始是用的 ScrollView 写的,内存也是飙升到三百多兆,使用 collectionView 之后,就稳定在一百五十兆以下了.所以collectionView 不仅仅是布局方便,而且 cell 复用,节省内存

import UIKit
import CoreImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var originalImage: UIImageView!
    var number = 0
    var dataSourceList = [UIImage]()

    var CIFilterNames = ["CIBoxBlur",          //模糊
                         "CILinearToSRGBToneCurve",
                         "CIColorMonochrome",  //整个图片笼罩在单一阴影里
                         "CIOverlayBlendMode",
                         "CIBumpDistortion",   // 像素凹凸变形
                         "CIAffineTransform",
                         "CICircularScreen",   //圆形半色调屏
                         "CIAreaMaximum",
                         "CISharpenLuminance"  //锐化处理
                        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = CIContext(options: nil)
        for i in 0..<CIFilterNames.count {
            //添加滤镜
            //CIContext 尽量多复用,少创建,较少内存开销,应该放在循环的外面
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])")
            filter?.setDefaults()
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            let outputCIimage = filter?.value(forKey: kCIOutputImageKey)  as! CIImage
            let outputCGImage = context.createCGImage(outputCIimage, from: outputCIimage.extent)
            let outputImage = UIImage(cgImage: outputCGImage!)
            dataSourceList.append(outputImage)
        }
        addCollectionView()
    }


    @IBAction func saveAction(_ sender: Any) {
        /*// 存储到相册
        UIImageWriteToSavedPhotosAlbum(originalImage.image!, nil, nil, nil)
        let alert = UIAlertController(title: "Filter", message: "Your image has been saved to Photo Library", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)*/
        
        //存储到本地
        saveImage(image: originalImage.image!, imageName: CIFilterNames[number])
    }
    
    //保存图片
    func saveImage(image: UIImage, imageName: String) {
        let imageData = UIImagePNGRepresentation(image)
        let imagePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/\(imageName).png"
        print("\(imagePath)")

        do {
            try! imageData?.write(to: URL(fileURLWithPath: imagePath))
        }
    }
    
    // MARK: 添加 collectionView
    let identifier = "CollectionViewCell"
    var collectionView: UICollectionView?

    func addCollectionView() {
        let number: Int = 4
        let left: CGFloat = 3
        let spacing: CGFloat = 3
        let width = (self.view.frame.width - left * 2 - CGFloat(number - 1) * spacing) / CGFloat(number)
        let height: CGFloat = width + 40
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: left)
        
        let frame = CGRect(x: 0, y: self.view.bounds.height - height - 34, width: self.view.bounds.width, height: height)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
        self.view.addSubview(collectionView!)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CollectionViewCell
        cell.imageView.image = dataSourceList[indexPath.row]
        cell.titleLabel.text = CIFilterNames[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CIFilterNames.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击:\(indexPath)")
        originalImage.image = dataSourceList[indexPath.row]
        number = indexPath.row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

