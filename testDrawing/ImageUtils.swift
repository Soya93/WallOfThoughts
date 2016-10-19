//
//  ImageUtils.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-19.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import Foundation

class ImageUtils {
    
    //Function for creating a layer for dashed borders to the specified imageView with the specified color
    class func dashedBorderLayerWithColor(imageView: UIImageView, color:CGColor) -> CAShapeLayer {
        
        //Setup size
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = imageView.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        //Setup border
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth=1
        borderLayer.lineJoin=kCALineJoinRound
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 8),NSNumber(value:4)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        borderLayer.path = path.cgPath
        
        return borderLayer
        
    }
    
    //Function for making a white background transparent.
    class func imageByMakingWhiteBackgroundTransparent(image: UIImage) -> UIImage? {
        
            //Create transparent mask
            let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
            UIGraphicsBeginImageContext(image.size)
        
            //Add mask to image and return result
            if let maskedImageRef = image.cgImage?.copy(maskingColorComponents: colorMasking) {
                UIGraphicsGetCurrentContext()!.translateBy(x: 0.0, y: image.size.height)
                UIGraphicsGetCurrentContext()!.scaleBy(x: 1.0, y: -1.0)
                UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        
        return nil
    }
    
}
