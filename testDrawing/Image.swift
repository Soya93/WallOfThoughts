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
    
    init(pos: GLKVector3, imageView: UIImageView) {
        self.pos = pos
        self.imageView = imageView
    }
    
    @objc func getPos() -> GLKVector3  {
        return pos
    }
    
    @objc func getImageView() -> UIImageView  {
        return imageView
    }
    
    
    
}
