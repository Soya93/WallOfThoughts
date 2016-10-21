//
//  ImageController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-19.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import Foundation

//Controller to keep track of and render images.
@objc class ImageController: NSObject {
    
    static let singletonInstance = ImageController()
    
    var images: [Image] = []
    
    //To make sure it's a singleton
    private override init() {}
    
    @objc func getImages() -> [Image] {
        return images
    }
    
    //Function for rendering the image at the right place in panorama view.
    @objc func renderImage(image: Image) {
        
        let imageLocation = PanoramaView.shared()?.screenLocation(from: image.pos)
        let imagePixel = PanoramaView.shared()?.imagePixel(atScreenLocation: imageLocation!)
        
        //Compare pixelpoints to remove the duplication of the image, since the vector position corresponds to two positions in the panorama view.
        if (imagePixel?.x.rounded())! < image.pixelPoint.x + 2 && (imagePixel?.x.rounded())! > image.pixelPoint.x - 2 {
            
            image.imageView.frame = CGRect(x: ((imageLocation?.x)!), y: ((imageLocation?.y)!), width: (image.imageView.image?.size.width)!/4, height: (image.imageView.image?.size.height)!/4)
            PanoramaView.shared()?.addSubview(image.imageView)
        }
    }
    
    
    // the sharedInstance class method can be reached from ObjC
    class func sharedInstance() -> ImageController {
        return ImageController.singletonInstance
    }
}
