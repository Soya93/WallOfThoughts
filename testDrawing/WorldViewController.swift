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

//The viewcontroller that shows the world with all images.
class WorldViewController: GLKViewController {
    
    var panoramaView = PanoramaView.shared()
    var button : UIButton = UIButton()
    var cameraView = AVCaptureVideoPreviewLayer()

    
    override func viewDidLoad() {
        //capture video input in an AVCaptureLayerVideoPreviewLayer
        let captureSession = AVCaptureSession()
        cameraView = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraView.videoGravity = AVLayerVideoGravityResizeAspectFill
        
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
        
        cameraView.frame = self.view.bounds
       
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        panoramaView?.draw()
        
        //Bring button to front
        self.view.bringSubview(toFront: button)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
       self.view = panoramaView
       self.view.layer.addSublayer(cameraView)
        
        //Alert user if there's no internet connection
        if ReachabilityUtils.isConnectedToNetwork() != true {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    
        
        DatabaseUtils.getImagesFromDatabase()
        
        setupButton()
        
    }
    
    //Action for button to add new thougt
    func buttonAction(sender: UIButton!) {
        //Prepare panoramaview to be used by other viewcontrollers
        button.removeFromSuperview()
        self.view = GLKView()
        
        performSegue(withIdentifier: "newThought", sender: sender)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func unwindToWorldViewController(sender: UIStoryboardSegue) {
        //Do nothing
    }
    
    //Function for setting up the button for adding new thought
    func setupButton() {
        
        //Create button
        button = UIButton(frame: CGRect(x: (Int(self.view.frame.width/2) - (#imageLiteral(resourceName: "Thought").cgImage?.width)!/2), y: (Int(self.view.frame.height) - (#imageLiteral(resourceName: "Thought").cgImage?.height)!), width: (#imageLiteral(resourceName: "Thought").cgImage?.width)!, height: (#imageLiteral(resourceName: "Thought").cgImage?.height)!))
        button.setImage(#imageLiteral(resourceName: "Thought"), for: .normal)
        
        // Shadow and Radius
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
        button.layer.shadowOffset = CGSize(width:0.0, height:3.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.7
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
        
        //Add to view
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
    }
   
}
