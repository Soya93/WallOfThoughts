//
//  WallViewController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-04.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

class WallViewController: GLKViewController {
    
    var panoramaView = PanoramaView.shared()
    var button : UIButton = UIButton()
    
    override func viewDidLoad() {
        panoramaView?.setImage(UIImage(named: "park_2048.jpg"))
        panoramaView?.touchToPan = false          // Use touch input to pan
        panoramaView?.orientToDevice = true     // Use motion sensors to pan
        panoramaView?.pinchToZoom = false         // Use pinch gesture to zoom
        panoramaView?.showTouches = true         // Show touches
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
    
    

}
