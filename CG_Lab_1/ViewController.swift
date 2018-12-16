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
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var CoreImage: UIImageView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var Xcoeficient: UITextField!
    @IBOutlet weak var Ycoeficient: UITextField!
    @IBOutlet weak var ScaleButton: UIButton!
    @IBOutlet weak var RotationButton: UIButton!
    @IBOutlet weak var MonoChromaticButton: UIButton!
    @IBOutlet weak var MedianButton: UIButton!
    @IBOutlet weak var MedianMatrixSize: UITextField!
    let colorClass = ColorAffected()
    @IBAction func resetImage(_ sender: Any) {
    
    }
    var imageView : UIImageView!
    @IBAction func selectImageFromLibrary(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        Xcoeficient.isHidden = true
        Ycoeficient.isHidden = true
        ScaleButton.isHidden = true
        RotationButton.isHidden = true
        MonoChromaticButton.isHidden = true
        MedianButton.isHidden = true
        MedianMatrixSize.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        
        // Set photoImageView to display the selected image.
        CoreImage.image = selectedImage
        Xcoeficient.isHidden = false
        Ycoeficient.isHidden = false
        ScaleButton.isHidden = false
        RotationButton.isHidden = false
        MonoChromaticButton.isHidden = false
        MedianButton.isHidden = false
        MedianMatrixSize.isHidden = false
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userStartsAddMultiFiltration(_ sender: Any) {
        if (self.imageView != nil){
            self.imageView.isHidden = true}
        
        
        let CGcoreTest : CGImage = (CoreImage.image?.cgImage)!
        let CoreImage1 = colorClass.monoImage(fromPixelValues: colorClass.pixelMedianFiltration(pixelValues: (CoreImage.image?.UInt8Data())!, width: CGcoreTest.width, height: CGcoreTest.height, sortingMatrixSize: 3), width: CGcoreTest.width, height: CGcoreTest.height)
        var imageView : UIImageView
        
        imageView  = UIImageView(frame: CGRect(x: 30, y: 30, width:  CGcoreTest.width , height: CGcoreTest.height))
        
        CoreImage.isHidden = true
        imageView.image = UIImage(cgImage: CoreImage1!)
        
        self.view.addSubview(imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rotationAngle: Double = 45 * (Double.pi/180)
        Xcoeficient.isHidden = true
        Ycoeficient.isHidden = true
        ScaleButton.isHidden = true
        RotationButton.isHidden = true
        MonoChromaticButton.isHidden = true
        MedianButton.isHidden = true
        MedianMatrixSize.isHidden = true
        
    }
    
    @IBAction func userStartsMedianFiltration(_ sender: Any) {
        if (self.imageView != nil){
            self.imageView.isHidden = true}
       
        let matrixSize = Int(MedianMatrixSize.text!)
        let CGcoreTest : CGImage = (CoreImage.image?.cgImage)!
        let CoreImage1 = colorClass.monoImage(fromPixelValues:
            colorClass.pixelLinearFiltration(pixelValues: colorClass.pixelMedianFiltration(pixelValues: (CoreImage.image?.UInt8Data())!, width: CGcoreTest.width, height: CGcoreTest.height, sortingMatrixSize: matrixSize ?? 3), width: CGcoreTest.width, height: CGcoreTest.height), width: CGcoreTest.width, height: CGcoreTest.height)
        var imageView : UIImageView
        
        imageView  = UIImageView(frame: CGRect(x: 30, y: 30, width:  CGcoreTest.width , height: CGcoreTest.height))
        
        CoreImage.isHidden = true
        imageView.image = UIImage(cgImage: CoreImage1!)
      
        self.view.addSubview(imageView)
    }
    
    
    
    
    @IBAction func CreateGrayColor(_ sender: Any) {
        if (self.imageView != nil){
            self.imageView.isHidden = true}
        let CGcoreTest : CGImage = (CoreImage.image?.cgImage)!
        let CoreImage1 = colorClass.monoImage(fromPixelValues: colorClass.pixelMonoChromasing(fromPixelValues: CoreImage.image?.UInt8Data(), width: CGcoreTest.width, height: CGcoreTest.height), width: CGcoreTest.width, height: CGcoreTest.height)
        var imageView : UIImageView
        
        imageView  = UIImageView(frame: CGRect(x: 30, y: 30, width: CGcoreTest.width, height: CGcoreTest.height))
        
        CoreImage.isHidden = true
        imageView.image = UIImage(cgImage: CoreImage1!)
        self.view.addSubview(imageView)
    }
    
   
    @IBAction func userStartsRotation(_ sender: Any) {
        
        if (self.imageView != nil){
            self.imageView.isHidden = true}
        let CGcoreTest : CGImage = (CoreImage.image?.cgImage)!
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
        let CGcoreTest : CGImage = (CoreImage.image?.cgImage)!
        let Xcoef = Double(Xcoeficient.text!)
        let Ycoef = Double(Ycoeficient.text!)
        let width1 = Int(Double(CGcoreTest.width) * (Xcoef ?? 1.0))
        let height1 = Int(Double(CGcoreTest.height) * (Ycoef ?? 1.0))
        let CoreImage1 = image(fromPixelValues: pixelScale(fromPixelValues: CoreImage.image?.pixelData(), width: CGcoreTest.width, height: CGcoreTest.height, scaleByY: Ycoef ?? 1.0, scaleByX: Xcoef ?? 1.0), width: width1, height: height1)
        
       
        imageView  = UIImageView(frame: CGRect(x: 30, y: 30, width: CoreImage1!.width, height: CoreImage1!.height))
        
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
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue).union(CGBitmapInfo())
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
                let X : Int = Int(Double(x) * cos(rotationAngle) + Double(y) * sin(rotationAngle)) + (newWidth - width)/2
                let Y : Int = Int(Double(-x) * sin(rotationAngle) + Double(y) * cos(rotationAngle)) + (newHeight - height)/2
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
        let resultMatrix : [[[UInt16]]] = []
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
    func UInt8Data() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
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

class ColorAffected
{
    
    //  Median Filtration
    
    func pixelMedianFiltration (pixelValues: [UInt8], width: Int, height: Int, sortingMatrixSize: Int) -> [UInt8]{
        var imageMatrix : [[[UInt8]]] = []
        var resultPixelData : [UInt8] = []
        var color : [UInt8] = []
        var index = 0
        var rows : [[UInt8]] = []
        var pixelLab: [UInt8] = convertXYZtoLAB(xyzArray: convertRGBtoXYZ(rgbArray: pixelValues))
        for _ in 0...height-1
        {
            
            rows = []
            for _ in 0...width-1
            {
                color = []
                for _ in 0...3{
                    
                    color.append(pixelLab[index])
                    index += 1
                }
                rows.append(color)
            }
            imageMatrix.append(rows)
            
        }
        
        for y in 0..<height
        {
            
            for x in 0..<width
            {
                let xTempest = x - (sortingMatrixSize/2)
                let yTempest = y - (sortingMatrixSize/2)
                let xLimit = x + (sortingMatrixSize/2)
                let yLimit = y + (sortingMatrixSize/2)
                var Rsummary: [Double] = []
                var Gsummary: [Double] = []
                var Bsummary: [Double] = []
                var xIndex = 0
                var yIndex = 0
                for indexByY in yTempest..<yLimit
                {
                    
                    for indexByX in xTempest..<xLimit
                    {
                        xIndex = indexByX
                        yIndex = indexByY
                        if (xIndex >= width-1)
                        {
                            xIndex -= (width-1)
                        }
                        if (xIndex <= 0)
                        {
                            xIndex += width-1
                        }
                        if (yIndex >= width-1)
                        {
                            yIndex -= (height-1)
                        }
                        if (yIndex <= 0)
                        {
                            yIndex += height-1
                        }
                        Rsummary.append(Double(imageMatrix[yIndex][xIndex][0]))
                        Gsummary.append(Double(imageMatrix[yIndex][xIndex][1]))
                        Bsummary.append(Double(imageMatrix[yIndex][xIndex][2]))
                    }
                }
                Rsummary.sort()
                Gsummary.sort()
                Bsummary.sort()
                resultPixelData.append(UInt8(Rsummary[Rsummary.count/2]))
                resultPixelData.append(UInt8(Gsummary[Gsummary.count/2]))
                resultPixelData.append(UInt8(Bsummary[Bsummary.count/2]))
                resultPixelData.append(imageMatrix[y][x][3])
            }
        }
        return resultPixelData
    }
    
   //Linear Filtration
    
    func pixelLinearFiltration (pixelValues: [UInt8], width: Int, height: Int) -> [UInt8]{
        var imageMatrix : [[[UInt8]]] = []
        var resultPixelData : [UInt8] = []
        var color : [UInt8] = []
        var index = 0
        var pixelLab: [UInt8] = convertXYZtoLAB(xyzArray: convertRGBtoXYZ(rgbArray: pixelValues))
        var rows : [[UInt8]] = []
        for _ in 0...height-1
        {
            
            rows = []
            for _ in 0...width-1
            {
                color = []
                for _ in 0...3{
                    
                    color.append(pixelLab[index])
                    index += 1
                }
                rows.append(color)
            }
            imageMatrix.append(rows)
            
        }
        
        for y in 0..<height
        {
            
            for x in 0..<width
            {
                let xTempest = x - 1
                let yTempest = y - 1
                let xLimit = x + 1
                let yLimit = y + 1
                var Rsummary: Double = 0
                var Gsummary: Double = 0
                var Bsummary: Double = 0
                var xIndex = 0
                var yIndex = 0
                for indexByY in yTempest..<yLimit
                {
                    
                    for indexByX in xTempest..<xLimit
                    {
                        Rsummary = 0
                        Gsummary = 0
                        Bsummary = 0
                        xIndex = indexByX
                        yIndex = indexByY
                        if (xIndex >= width-1)
                        {
                            xIndex -= (width-1)
                        }
                        if (xIndex <= 0)
                        {
                            xIndex += width-1
                        }
                        if (yIndex >= width-1)
                        {
                            yIndex -= (height-1)
                        }
                        if (yIndex <= 0)
                        {
                            yIndex += height-1
                        }
                        Rsummary += Double(imageMatrix[yIndex][xIndex][0])
                        Gsummary += Double(imageMatrix[yIndex][xIndex][1])
                        Bsummary += Double(imageMatrix[yIndex][xIndex][2])
                    }
                }
                Rsummary /= 9
                Gsummary /= 9
                Bsummary /= 9
                resultPixelData.append(UInt8(Rsummary))
                resultPixelData.append(UInt8(Gsummary))
                resultPixelData.append(UInt8(Bsummary))
                resultPixelData.append(imageMatrix[y][x][3])
            }
        }
        return resultPixelData
    }
    
    
    func monoImage(fromPixelValues pixelValues: [UInt8]?, width: Int, height: Int) -> CGImage?
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
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue).union(CGBitmapInfo())
                let data = UnsafeRawPointer(ptr.pointee).assumingMemoryBound(to: UInt8.self)
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
    
    //Monochromatic
    func pixelMonoChromasing(fromPixelValues pixelValues: [UInt8]?, width: Int, height: Int) -> [UInt8]? {
        
        var resultPixelData : [UInt8] = []
        var pixelLab: [UInt8] = convertXYZtoLAB(xyzArray: convertRGBtoXYZ(rgbArray: pixelValues!))
        var color = 0
        var index = 0
        
        for _ in 0...height-1
        {
            
            
            for _ in 0...width-1
            {
                color = 0
                for _ in 0...2
                {
                    color +=  Int(pixelLab[index])
                    index += 1
                }
                
                
                resultPixelData.append(UInt8(color/3))
                resultPixelData.append(UInt8(color/3))
                resultPixelData.append(UInt8(color/3))
                
                
                resultPixelData.append(pixelLab[index])
                index += 1
                
            }
            
        }
        return resultPixelData
    }
    func convertRGBtoXYZ(rgbArray: [UInt8]) -> [Double]
    {
        var index = 0
        var resultArray: [Double] = []
        for _ in stride(from: index, to: rgbArray.count, by: 4)
        {
            let r: Double = Double(rgbArray[index])
            let g: Double = Double(rgbArray[index+1])
            let b: Double = Double(rgbArray[index+2])
            let x: Double = r * 0.6649224
            let y: Double = g * 1.1338698
            let z: Double = b * 1.2012078
            resultArray.append(x)
            resultArray.append(y)
            resultArray.append(z)
            resultArray.append(Double(rgbArray[index+3]))
            index += 4
            
            
        }
        return resultArray
    }
    func convertXYZtoLAB(xyzArray: [Double]) -> [UInt8]
    {
       
        
            // Get XYZ
        var index = 0
            let xyzT = xyzArray
        var resultArray: [UInt8] = []
        for _ in stride(from: index, to: xyzArray.count, by: 4)
        {
           
            let x = xyzT[index]/95.047
            let y = xyzT[index+1]/100.000
            let z = xyzT[index+2]/108.883
            let X = deltaF(f:x)
            let Y = deltaF(f:y)
            let Z = deltaF(f:z)
            let L = 116*Y - 16
            let a = 500 * (X - Y)
            let b = 200 * (Y - Z)
          
            resultArray.append(UInt8(L))
            resultArray.append(UInt8(a))
            resultArray.append(UInt8(b))
            resultArray.append(UInt8(xyzArray[index+3]))
            index += 4
        }
            
            // Transfrom XYZ to L*a*b
        
        
            
            return resultArray
        
    }
    func deltaF(f: Double) -> (Double){
        let transformation = (f > pow((6.0/29.0), 3.0)) ? pow(f, 1.0/3.0) : (1/3) * pow((29.0/6.0), 2.0) * f + 4/29.0
        
        return (transformation)
    }
}

