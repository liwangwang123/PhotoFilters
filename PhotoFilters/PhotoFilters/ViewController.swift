//
//  ViewController.swift
//  PhotoFilters
//
//  Created by lemo on 2018/7/12.
//  Copyright © 2018年 wangli. All rights reserved.
//  给图片加上滤镜
//  参考内容: Apply Photo Filters With Core Image in Swift(swift 2.0) https://code.tutsplus.com/tutorials/ios-sdk-apply-photo-filters-with-core-image-in-swift--cms-27142

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    
    var CIFilterNames = [ //模糊效果
                         "CIBoxBlur",
                         "CIDiscBlur",
                         "CIGaussianBlur",
                         "CIMaskedVariableBlur",
                         "CIMedianFilter",
                         "CIMotionBlur",
                         "CINoiseReduction",
                         "CIZoomBlur",
                         
                         "CIPhotoEffectChrome",
                         "CIPhotoEffectFade",
                         "CIPhotoEffectInstant",
                         "CIPhotoEffectNoir",
                         "CIPhotoEffectProcess",
                         "CIPhotoEffectTonal",
                         "CIPhotoEffectTransfer",
                         "CISepiaTone",
                         "CICMYKHalftone",
                         "CICrystallize"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yCoord: CGFloat = 5
        let buttonWidth: CGFloat = 70
        let buttonHeight: CGFloat = 70
        
        var itemCount = 0
        let context = CIContext(options: nil)
        for i in 0..<CIFilterNames.count {
            itemCount = i
            //添加按钮
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: (buttonWidth + 10) * CGFloat(i) + 10, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(filterButtonTapped(sender:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            //添加滤镜
            //CIContext 尽量多复用,少创建,较少内存开销,应该放在循环的外面
            
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])")
            filter?.setDefaults()
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            let outputCIimage = filter?.value(forKey: kCIOutputImageKey)  as! CIImage
            let outputCGImage = context.createCGImage(outputCIimage, from: outputCIimage.extent)
            let imageForButton = UIImage(cgImage: outputCGImage!)
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
            filtersScrollView.addSubview(filterButton)
        }
        filtersScrollView.contentSize = CGSize(width: (buttonWidth + 10) * CGFloat(CIFilterNames.count) + 10, height: 80)
    }
    
    @objc func filterButtonTapped(sender: UIButton) {
        originalImage.image = sender.backgroundImage(for: .normal)
    }

    @IBAction func saveAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(originalImage.image!, nil, nil, nil)
        let alert = UIAlertController(title: "Filter", message: "Your image has been saved to Photo Library", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

