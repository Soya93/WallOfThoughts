//
//  Image.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-14.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import Foundation


// A class representing an image. Each image has a vector for position, a pixelPoint and an imageView containing the image.
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
    
}
