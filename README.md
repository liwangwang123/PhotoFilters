# PhotoFilters
Swift 滤镜效果与种类

//添加滤镜
```
//CIContext 尽量多复用,少创建,较少内存开销,应该放在循环的外面

let coreImage = CIImage(image: originalImage.image!)

let filter = CIFilter(name: "CICrystallize")

filter?.setDefaults()

filter?.setValue(coreImage, forKey: kCIInputImageKey)

let outputCIimage = filter?.value(forKey: kCIOutputImageKey)  as! CIImage

let outputCGImage = context.createCGImage(outputCIimage, from: outputCIimage.extent)

let outputImage = UIImage(cgImage: outputCGImage!)
```

![原效果图](https://github.com/liwangwang123/FliterImages/blob/master/flower.png) 

                                    原图

