//
//  Image.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-14.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import Foundation

@objc class Image : NSObject {
    var pos: GLKVector3 = GLKVector3Make(0.0,0.0,0.0)
    var imageView: UIImageView = UIImageView()
    var pixelPoint: CGPoint = CGPoint()
    var panoramaView = PanoramaView.shared()

    init(pos: GLKVector3, imageView: UIImageView, pixelPoint: CGPoint) {
        self.pos = pos
        self.imageView = imageView
        self.pixelPoint = pixelPoint
    }
    
    @objc func getPos() -> GLKVector3  {
        return pos
    }
    
    @objc func getImageView() -> UIImageView  {
        return imageView
    }
    
    @objc func getPixelPoint() -> CGPoint  {
        return pixelPoint
    }
    
    @objc func render()  {
        let imageLocation = panoramaView?.screenLocation(from: pos)
        let imagePixel = panoramaView?.imagePixel(atScreenLocation: imageLocation!)
        
        if (imagePixel?.x.rounded())! < pixelPoint.x + 2 && (imagePixel?.x.rounded())! > pixelPoint.x - 2 {
            imageView.frame = CGRect(x: (imageLocation?.x)!, y: (imageLocation?.y)!, width: (imageView.image?.size.width)!/4,
                                     height: (imageView.image?.size.height)!/4)
            panoramaView?.addSubview(imageView)
           // print("In renderer if");
        } else {
            //print("In renderer else");
        }
    }
}
