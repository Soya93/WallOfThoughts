//
//  PlaceViewController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-09-28.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {
    
    @IBOutlet weak var imageContainer: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(image)
        imageContainer.image = image
        
        let borderLayer  = dashedBorderLayerWithColor(UIColor.blackColor().CGColor)
        
        imageContainer.layer.addSublayer(borderLayer)
        
        
        /*imageContainer.layer.borderWidth = 1
        imageContainer.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor*/
        
        // Do any additional setup after loading the view.
    }
    
    func dashedBorderLayerWithColor(color:CGColorRef) -> CAShapeLayer {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = imageContainer.frame.size
        let shapeRect = CGRectMake(0, 0, frameSize.width, frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPointMake( frameSize.width/2,frameSize.height/2)
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth=1
        borderLayer.lineJoin=kCALineJoinRound
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(integer: 8),NSNumber(integer:4)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.CGPath
        
        return borderLayer
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

