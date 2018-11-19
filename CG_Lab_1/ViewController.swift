//
//  ViewController.swift
//  CG_Lab_1
//
//  Created by Ivan Ermak on 10/29/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreImage
class ViewController: UIViewController {
    @IBOutlet weak var CoreImage: UIImageView!
    @IBOutlet weak var resultView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data : CGDataProvider = CGDataProvider.init(filename: "/Users/buiver/Desktop/stw.png")!
        let color : CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let CGcoreTest : CGImage = CGImage(pngDataProviderSource: data, decode: nil, shouldInterpolate: false, intent: color)!
        //var bitmap : CGBitmapInfo =
        debugPrint(CGcoreTest.bitmapInfo)
        CoreImage.image = UIImage(cgImage: CGcoreTest)
        debugPrint(CGcoreTest.bitsPerPixel)
        debugPrint(CGcoreTest.bitsPerComponent)
      //  debugPrint(CoreImage.image?.pixelData())
       // debugPrint(CoreImage.image?.pixelData()?.count)
    }
    
    @IBAction func userStartsResize(_ sender: Any) {
       
        let data : CGDataProvider = CGDataProvider.init(filename: "/Users/buiver/Desktop/stw.png")!
        let color : CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let CGcoreTest : CGImage = CGImage(pngDataProviderSource: data, decode: nil, shouldInterpolate: false, intent: color)!
       debugPrint(CGcoreTest.width)
        let CoreImage1 = image(fromPixelValues: CoreImage.image?.pixelData(), width: CGcoreTest.width, height: CGcoreTest.height)
        var imageView : UIImageView
      
        imageView  = UIImageView(frame: CGRect(x: 20, y: 20, width: CoreImage1!.width, height: CoreImage1!.height))
        debugPrint(CoreImage1!.width)
        CoreImage.isHidden = true
        imageView.image = UIImage(cgImage: CoreImage1!)
        self.view.addSubview(imageView)
        
    }
    func image(fromPixelValues pixelValues: [UInt16]?, width: Int, height: Int) -> CGImage?
    {
        var imageRef: CGImage?
        if var pixelValues = pixelValues {
            let bitsPerComponent = 8
            let bytesPerPixel = 4
            let bitsPerPixel = bytesPerPixel * bitsPerComponent
            let bytesPerRow = bytesPerPixel * width
            let totalBytes = height * bytesPerRow
            
            imageRef = withUnsafePointer(to: &pixelValues, {
                ptr -> CGImage? in
                var imageRef: CGImage?
                let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).union(CGBitmapInfo())
                let data = UnsafeRawPointer(ptr.pointee).assumingMemoryBound(to: UInt16.self)
                let releaseData: CGDataProviderReleaseDataCallback = {
                    (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in
                }
               // debugPrint(CGDataProvider(dataInfo: nil, data: data, size: totalBytes, releaseData: releaseData))
                if let providerRef = CGDataProvider(dataInfo: nil, data: data, size: totalBytes, releaseData: releaseData) {
                    imageRef = CGImage(width: width,
                                       height: height,
                                       bitsPerComponent: bitsPerComponent,
                                       bitsPerPixel: bitsPerPixel,
                                       bytesPerRow: bytesPerRow,
                                       space: colorSpaceRef,
                                       bitmapInfo: bitmapInfo,
                                       provider: providerRef,
                                       decode: nil,
                                       shouldInterpolate: false,
                                       intent: CGColorRenderingIntent.defaultIntent)
                }
                
                return imageRef
            })
        }
        
        return imageRef
    }
    
}
extension UIImage {
    func pixelData() -> [UInt16]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt16](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
}


