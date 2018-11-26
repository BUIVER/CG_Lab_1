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
        let coefX = 0.7
        let coefY = 0.7
        let width1 = Int(Double(CGcoreTest.width) * coefX)
        let height1 = Int(Double(CGcoreTest.height) * coefY)
        let CoreImage1 = image(fromPixelValues: pixelScale(fromPixelValues: CoreImage.image?.pixelData(), width: CGcoreTest.width, height: CGcoreTest.height, scaleByY: coefY, scaleByX: coefX), width: width1, height: height1)
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
    func pixelScale(fromPixelValues pixelValues: [UInt16]?, width: Int, height: Int, scaleByY: Double, scaleByX: Double) -> [UInt16]? {
        
        var color: [UInt16] = []
        var image: [UInt16] = []
        var imageMatrix : [[[UInt16]]] = []
        var resultMatrix : [[[UInt16]]] = []
        var index = 0
        var rows : [[UInt16]] = []
        let newWidth = Int(Double(width) * scaleByX)
        let newHeight = Int(Double(height) * scaleByY)
        for _ in 0...height-1
        {
            
            rows = []
            for _ in 0...width-1
            {
                color = []
                for _ in 0...3{
               
                color.append(pixelValues![index])
                index += 1
                }
             /*   color = []
                color?.append(pixelValues![4 * Int(Double(index)/scaleByX)])
                color?.append(pixelValues![4 * Int(Double(index)/scaleByX) + 1])
                color?.append(pixelValues![4 * Int(Double(index)/scaleByX) + 2])
                color?.append(pixelValues![4 * Int(Double(index)/scaleByX) + 3]) */
                rows.append(color)
            }
            imageMatrix.append(rows)
        }
        for y in 0...newHeight-1
        {
            for x  in 0...newWidth-1
            {
                let x1 = Int(Double(x)/scaleByX)
                let y1 = Int(Double(y)/scaleByY)
                image.append(contentsOf: (imageMatrix[y1][x1]))
                
            }
        }
        debugPrint(resultMatrix.count)
        return image
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


