
//
//  PlaceViewController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-09-28.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//
import GLKit
import UIKit
import FirebaseDatabase


//View controller for placing the newdrawn thought in the world
class PlaceViewController: GLKViewController {
    
    @IBOutlet weak var imageContainer: UIImageView!
    var image: UIImage?
    var panoramaView = PanoramaView.shared()
    
    override func viewDidLoad() {
        
        //Add the image from previous viewcontroller to the imagecontainer with the right size, borders and transparancy.
        if let image = image {
            imageContainer.frame = CGRect(x: (UIScreen.main.bounds.width/2-image.size.width/8), y: (UIScreen.main.bounds.height/2-image.size.height/8), width: image.size.width/4, height: image.size.height/4)
            imageContainer.image = image
        }
        let borderLayer  = ImageUtils.dashedBorderLayerWithColor(imageView: imageContainer, color: UIColor.black.cgColor)
        imageContainer.layer.addSublayer(borderLayer)
        imageContainer.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        self.view = panoramaView
        self.view.addSubview(imageContainer)
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        panoramaView?.draw()
        
        //Add the imagecontainer to the top of all subviews
        self.view.bringSubview(toFront: imageContainer)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        //If there's no network connection, alert the user. Otherwise upload the image to the database.
        if ReachabilityUtils.isConnectedToNetwork() != true {
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            imageContainer.removeFromSuperview()
            self.view = GLKView()
            
            DatabaseUtils.uploadImage(imageContainer: imageContainer)
            
            performSegue(withIdentifier: "showWall", sender: sender)
        }

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "showWall" {
            //Prepare panoramaview to be used by other viewcontroller
            imageContainer.removeFromSuperview()
            self.view = GLKView()
  
        }
    }
    
    
  
}
