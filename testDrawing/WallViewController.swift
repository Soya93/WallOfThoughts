//
//  WallViewController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-04.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//
import GLKit
import UIKit
import FirebaseDatabase

class WallViewController: GLKViewController {
    
    var panoramaView = PanoramaView.shared()
    var button : UIButton = UIButton()
    
    override func viewDidLoad() {
        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        panoramaView?.draw()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view = panoramaView
        button = UIButton(frame: CGRect(x: (Int(self.view.frame.width/2) - (#imageLiteral(resourceName: "Thought").cgImage?.width)!/2), y: (Int(self.view.frame.height) - (#imageLiteral(resourceName: "Thought").cgImage?.height)!), width: (#imageLiteral(resourceName: "Thought").cgImage?.width)!, height: (#imageLiteral(resourceName: "Thought").cgImage?.height)!))
        button.setImage(#imageLiteral(resourceName: "Thought"), for: .normal)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
        addImages();
    }
    
    func buttonAction(sender: UIButton!) {
        button.removeFromSuperview()
        self.view = GLKView()
        performSegue(withIdentifier: "newThought", sender: sender)
        print("Button tapped")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func unwindToWallViewController(sender: UIStoryboardSegue) {
        //Do nothing
    }
    
    private func addImages() {
        let ref = FIRDatabase.database().reference().child("images")
        print("ADDING IMAGES")
        
        
        // Listen for new comments in the Firebase database
       ref.observe(.childAdded, with: { (snapshot) -> Void in
            let x : CGFloat = CGFloat(Float(snapshot.childSnapshot(forPath: "positionX").value as! String)!)
            let y : CGFloat = CGFloat(Float(snapshot.childSnapshot(forPath: "positionY").value as! String)!)
            let image = snapshot.childSnapshot(forPath: "image").value
            
            let base64EncodedString = image
            let imageData = NSData(base64Encoded: base64EncodedString as! String,
                                   options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedImage = UIImage(data:imageData! as Data)
        
            let point = self.panoramaView?.imagePixel(atScreenLocation: CGPoint(x: x, y: y))
            print(point)
            let imageContainer = UIImageView(frame: CGRect(x: point!.x, y: point!.y, width: CGFloat(decodedImage!.size.width), height: CGFloat(decodedImage!.size.height)))
            imageContainer.image = decodedImage
            self.view.addSubview(imageContainer)
            
           
            
        })
        
        
    }
    
    
    
}
