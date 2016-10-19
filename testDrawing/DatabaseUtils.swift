//
//  DatabaseUtils.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-19.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseUtils {
    /* This is the structure for all images:
     images {
        key {
            xPos: the x in the vector representing the position
            yPos: y in the vector representing the position
            zPos: z in the vector representing the position
            xPixel: the pixel value for x in the image
            yPixel: the pixel value for y in the image
            image: the encoded image
        }
     }
     */
    
    
    //Function for uploading images to the database.
    class func uploadImage(imageContainer: UIImageView) {
        
        //Get the database reference for the images key
        let ref = FIRDatabase.database().reference().child("images")
        
        //Calculate the vector for position and the pixelpoint for the image
        let x = imageContainer.center.x - imageContainer.frame.size.width/2
        let y = imageContainer.center.y - imageContainer.frame.size.height/2
        let vector = PanoramaView.shared()?.vector(fromScreenLocation: CGPoint(x: x, y: y))
        let location = PanoramaView.shared()?.screenLocation(from: vector!)
        let imagepixel = PanoramaView.shared()?.imagePixel(atScreenLocation: location!)
        
        // Assign variables for all values being uploaded to the database for the image
        let xPos : String = String(describing: vector!.v.0)
        let yPos : String = String(describing: vector!.v.1)
        let zPos : String = String(describing: vector!.v.2)
        let xPixel: String = String(describing: imagepixel!.x.rounded())
        let yPixel: String = String(describing: imagepixel!.y.rounded())
        let uploadImage: String = (UIImagePNGRepresentation(imageContainer.image!)?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
        
        let imageInfo = ["x": xPos, "y": yPos, "z": zPos, "xpixel": xPixel, "ypixel": yPixel, "image": uploadImage]
        
        //Upload to database
        let key = ref.childByAutoId()
        key.setValue(imageInfo)
    }
    
    
    //Function for getting images from the database
    class func getImagesFromDatabase(){
        let ref = FIRDatabase.database().reference().child("images")
        
        // Listen for new images in the Firebase database
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let x : Float = Float(snapshot.childSnapshot(forPath: "x").value as! String)!
            let y : Float = Float(snapshot.childSnapshot(forPath: "y").value as! String)!
            let z : Float = Float(snapshot.childSnapshot(forPath: "z").value as! String)!
            let xpixel: Float = Float(snapshot.childSnapshot(forPath: "xpixel").value as! String)!
            let ypixel: Float = Float(snapshot.childSnapshot(forPath: "ypixel").value as! String)!
           
            
            let pos : GLKVector3 = GLKVector3Make(x, y, z)
            let image = snapshot.childSnapshot(forPath: "image").value
            let pixelpoint = CGPoint(x: Int(xpixel), y: Int(ypixel))
            
            let base64EncodedString = image
            let imageData = NSData(base64Encoded: base64EncodedString as! String,
                                   options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedImage = UIImage(data:imageData! as Data)
            let finishedImage : Image = Image(pos: pos, imageView: UIImageView(image: decodedImage!), pixelPoint: pixelpoint)
            ImageController.singletonInstance.images.append(finishedImage)
        })
    }
}
