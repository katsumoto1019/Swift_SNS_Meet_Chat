//
//  UIView+Extension.swift
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resize(toTargetSize targetSize: CGSize) -> UIImage {
        // inspired by Hamptin Catlin
        // https://gist.github.com/licvido/55d12a8eb76a8103c753
        
        let newScale = self.scale // change this if you want the output image to have a different scale
        let originalSize = self.size
        
        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: floor(originalSize.width * heightRatio), height: floor(originalSize.height * heightRatio))
        } else {
            newSize = CGSize(width: floor(originalSize.width * widthRatio), height: floor(originalSize.height * widthRatio))
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale
        format.opaque = true
        let newImage = UIGraphicsImageRenderer(bounds: rect, format: format).image() { _ in
            self.draw(in: rect)
        }
        return newImage
    }
}

func saveToFile(image: UIImage, filePath: String, fileName: String) -> String! {
    
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths[0]
    
    // current document directory
    fileManager.changeCurrentDirectoryPath(documentDirectory as String)
    
    do {
        try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let savedFilePath = "\(documentDirectory)/\(filePath)/\(fileName).jpg"
    
    // if the file exists already, delete and write, else if create filePath
    if (fileManager.fileExists(atPath: savedFilePath)) {
        do {
            try fileManager.removeItem(atPath: savedFilePath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    } else {
        fileManager.createFile(atPath: savedFilePath, contents: nil, attributes: nil)
    }
    
    if let data = resize(image: image, maxHeight: 1500, maxWidth: 1500, compressionQuality: 0.0, mode: "JPG") {
        
        do {
            try data.write(to:URL(fileURLWithPath:savedFilePath), options:.atomic)
        } catch {
            print(error)
        }
        
    }
    
    return savedFilePath
}


func savetoPngFile(image: UIImage) -> String! {
    
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths[0]
    
    // current document directory
    fileManager.changeCurrentDirectoryPath(documentDirectory as String)
    
    do {
        try fileManager.createDirectory(atPath: Constants.SAVE_ROOT_PATH, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let savedFilePath = "\(documentDirectory)/\(Constants.SAVE_ROOT_PATH)/upload.png"
    
    // if the file exists already, delete and write, else if create filePath
    if (fileManager.fileExists(atPath: savedFilePath)) {
        do {
            try fileManager.removeItem(atPath: savedFilePath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    } else {
        fileManager.createFile(atPath: savedFilePath, contents: nil, attributes: nil)
    }
    
    if let data = resize(image: image, maxHeight: 512, maxWidth: 512, compressionQuality: 1, mode: "PNG") {
        
        do {
            try data.write(to:URL(fileURLWithPath:savedFilePath), options:.atomic)
        } catch {
            print(error)
        }
    }
    
    return savedFilePath
}

func resize(image: UIImage, maxHeight: Float = 4000.0, maxWidth: Float = 4000.0, compressionQuality: Float = 0.75, mode: String = "JPG") -> Data? {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    
    let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in:rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    
    var imageData : Data?
    if mode == "JPG" {
        imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
    } else if mode == "PNG" {
        imageData = img?.pngData()
    }
    
    UIGraphicsEndImageContext()
    return imageData
}

func resizeImage(image: UIImage, maxHeight: Float = 4000.0, maxWidth: Float = 4000.0, compressionQuality: Float = 0.75, mode: String = "JPG") -> UIImage? {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    
    let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in:rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()


    return img
}

func resizeImag1(image: UIImage, maxHeight: Float = 500, maxWidth: Float = 500, compressionQuality: Float = 0.75, mode: String = "JPG") -> UIImage? {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    
    let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in:rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()


    return img
}

func blur(theImage:UIImage) -> UIImage {
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    let context = CIContext(options: nil)
    let inputImage = CIImage(cgImage: theImage.cgImage!)
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    let filter = CIFilter(name: "CIGaussianBlur")
    filter?.setValue(inputImage, forKey: kCIInputImageKey)
    
    filter?.setValue(NSNumber(value: 25.0), forKey:"inputRadius")
    let result = filter?.value(forKey: kCIOutputImageKey)
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    //    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    let cgImage = context.createCGImage(result as! CIImage, from: inputImage.extent)
    let returnImage = UIImage(cgImage: cgImage!)
    
    return returnImage;
    
}

extension UIImage {

   class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
   }
}










