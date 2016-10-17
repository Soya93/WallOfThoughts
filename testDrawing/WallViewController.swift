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
import AVFoundation

class WallViewController: GLKViewController {
    
    var panoramaView = PanoramaView.shared()
    var button : UIButton = UIButton()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        //capture video input in an AVCaptureLayerVideoPreviewLayer
        let captureSession = AVCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        if let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
            do {
                let videoIn = try AVCaptureDeviceInput(device: videoDevice)
                if (captureSession.canAddInput(videoIn as AVCaptureInput)){
                    captureSession.addInput(videoIn as AVCaptureDeviceInput)
                }
            } catch let error as NSError {
                // Handle any errors
                print(error)
                print("Failed add video input.")
            }
            
        } else {
            print("Failed to create video capture device.")
        }
        captureSession.startRunning()
        
        //add AVCaptureVideoPreviewLayer as sublayer of self.view.layer
        previewLayer.frame = self.view.bounds
       
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        panoramaView?.draw()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       self.view.backgroundColor = UIColor.clear
       self.view = panoramaView
       self.view.layer.addSublayer(previewLayer)
        
        addImages()
        button = UIButton(frame: CGRect(x: (Int(self.view.frame.width/2) - (#imageLiteral(resourceName: "Thought").cgImage?.width)!/2), y: (Int(self.view.frame.height) - (#imageLiteral(resourceName: "Thought").cgImage?.height)!), width: (#imageLiteral(resourceName: "Thought").cgImage?.width)!, height: (#imageLiteral(resourceName: "Thought").cgImage?.height)!))
        button.setImage(#imageLiteral(resourceName: "Thought"), for: .normal)
        // Shadow and Radius
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
        button.layer.shadowOffset = CGSize(width:0.0, height:3.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.7
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
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
            let x : Float = Float(snapshot.childSnapshot(forPath: "x").value as! String)!
            let y : Float = Float(snapshot.childSnapshot(forPath: "y").value as! String)!
            let z : Float = Float(snapshot.childSnapshot(forPath: "z").value as! String)!
            let pos : GLKVector3 = GLKVector3Make(x, y, z)
            let image = snapshot.childSnapshot(forPath: "image").value
        
            let base64EncodedString = image
            let imageData = NSData(base64Encoded: base64EncodedString as! String,
                                   options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedImage = UIImage(data:imageData! as Data)
            let finishedImage : Image = Image(pos: pos, imageView: UIImageView(image: decodedImage!))
            self.panoramaView?.add(finishedImage)
        })
    }
}
