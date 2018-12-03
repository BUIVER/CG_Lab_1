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
    @IBOutlet weak var Xcoeficient: UITextField!
    @IBOutlet weak var Ycoeficient: UITextField!
    
    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rotationAngle: Double = 45 * (Double.pi/180)
        
        let data : CGDataProvider = CGDataProvider.init(filename: "/Users/buiver/Desktop/stw.png")!
        let color : CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let CGcoreTest : CGImage = CGImage(pngDataProviderSource: data, decode: nil, shouldInterpolate: false, intent: color)!
        
        
        CoreImage.image = UIImage(cgImage: CGcoreTest)
        debugPrint(CoreImage.image)
    }
    
    @IBAction func CreateGrayColor(_ sender: Any) {
        if (self.imageView != nil){
            self.imageView.isHidden = true}
        let data : CGDataProvider = CGDataProvider.init(filename: "/Users/buiver/Desktop/stw.png")!
        let color : CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let CGcoreTest : CGImage = CGImage(pngDataProviderSource: data, decode: nil, shouldInterpolate: false, intent: color)!
       // debugPrint(CoreImage.image?.pixelData())
        let CoreImage1 = image(fromPixelValues: pixelMonoChromasing(fromPixelValues: CoreImage.image?.pixelData(), width: CGcoreTest.width, height: CGcoreTest.height), width: CGcoreTest.width, height: CGcoreTest.height)
        var imageView : UIImageView
        
        imageView  = UIImageView(frame: CGRect(x: 30, y: 30, width: CGcoreTest.width, height: CGcoreTest.height))
        
        CoreImage.isHidden = true
        imageView.image = UIImage(cgImage: CoreImage1!)
        self.view.addSubview(imageView)
        
    }
    
   
    @IBAction func userStartsRotation(_ sender: Any) {
        
        if (self.imageView != nil){
            self.imageView.isHidden = true}
        let data : CGDataProvider = CGDataProvider.init(filename: "/Users/buiver/Desktop/stw.png")!
        let color : CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let CGcoreTest : CGImage = CGImage(pngDataProviderSource: data, decode: nil, shouldInterpolate: false, intent: color)!
        let newHeight : Int = Int(sqrt((pow(Double(CGcoreTest.width), 2) + pow(Double(CGcoreTest.height), 2)))) + 1
        let newWidth : Int = newHeight
        let CoreImage1 = image(fromPixelValues: pixelRotate(fromPixelValues: CoreImage.image?.pixelData(), width: CGcoreTest.width, height: CGcoreTest.height, newWidth: newWidth, newHeight: newHeight, rotationAngle: 2), width: newWidth, height: newHeight)
        var imageView : UIImageView
        
        imageView  = UIImageView(frame: CGRect(x: 30, y: 30, width: CoreImage1!.width, height: CoreImage1!.height))
        debugPrint(CoreImage1!.width)
        CoreImage.isHidden = true
        imageView.image = UIImage(cgImage: CoreImage1!)
        self.view.addSubview(imageView)
        
    }
    
    @IBAction func userStartsResize(_ sender: Any) {
      
        if (imageView != nil){
            imageView.isHidden = true}
        let data : CGDataProvider = CGDataProvider.init(filename: "/Users/buiver/Desktop/stw.png")!
        let color : CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        let CGcoreTest : CGImage = CGImage(pngDataProviderSource: data, decode: nil, shouldInterpolate: false, intent: color)!
       
        let Xcoef = Double(Xcoeficient.text!)
        let Ycoef = Double(Ycoeficient.text!)
        let width1 = Int(Double(CGcoreTest.width) * Xcoef!)
        let height1 = Int(Double(CGcoreTest.height) * Ycoef!)
        let CoreImage1 = image(fromPixelValues: pixelScale(fromPixelValues: CoreImage.image?.pixelData(), width: CGcoreTest.width, height: CGcoreTest.height, scaleByY: Ycoef!, scaleByX: Xcoef!), width: width1, height: height1)
        
       
        imageView  = UIImageView(frame: CGRect(x: 30, y: 30, width: CoreImage1!.width, height: CoreImage1!.height))
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
// Rotation
    
    
    
    
    
    
    func pixelRotate(fromPixelValues pixelValues: [UInt16]?, width: Int, height: Int, newWidth: Int, newHeight: Int, rotationAngle: Double) -> [UInt16]? {
        
       
        var resultPixelData : [UInt16] = []
        var rotationMatrix : [[[UInt16]]] = []
        var pixelData : [UInt16] = []
        var index = 0
        
        
        var rows : [[UInt16]] = []
        for _ in 0...newHeight-1
        {
            
            rows = []
            for _ in 0...newWidth-1
            {
                pixelData = []
                for _ in 0...3{
                    
                    pixelData.append(UInt16(0))
                    
                }
                rows.append(pixelData)
            }
            rotationMatrix.append(rows)
        }
        for y in 0...height-1
        {
            for x in 0...width-1
            {
                let X : Int = Int(Double(x) * cos(rotationAngle) + Double(y) * sin(rotationAngle)) + 20
                let Y : Int = Int(Double(-x) * sin(rotationAngle) + Double(y) * cos(rotationAngle)) + 20
                if (X >= 0 && Y >= 0){
                    for _ in 0...3{
                rotationMatrix[X][Y].append(pixelValues![index])
                        index += 1
                        
                    }
                }
                
            }
        }
        for y in 0...newHeight-1
        {
            for x in 0...newWidth-1
            {
                resultPixelData.append(contentsOf: rotationMatrix[y][x])
            }
        }
        return resultPixelData
    }
    
    
    
    
    //Scale
    
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
    
    //Monochromatic
    func pixelMonoChromasing(fromPixelValues pixelValues: [UInt16]?, width: Int, height: Int) -> [UInt16]? {
        
        var resultPixelData : [UInt16] = []
       
        var index = 0
        var color = 0
        for _ in 0...height-1
        {
            
            
            for _ in 0...width-1
            {
                color = 0
                for _ in 0...2{
                    color += Int(pixelValues![index])
                   // debugPrint(pixelValues![index])
                    index += 1
                    
                }
              
                resultPixelData.append(UInt16(color/3))
                resultPixelData.append(UInt16(color/3))
                resultPixelData.append(UInt16(color/3))
               
                //resultPixelData.append(UInt16(color/3))
                resultPixelData.append(pixelValues![index])
                index += 1
                
            }
          
        }
      
     
    
        return resultPixelData
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

