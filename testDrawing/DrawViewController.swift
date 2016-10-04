//
//  ViewController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-09-28.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import UIKit 

class DrawViewController: UIViewController {
    
    @IBOutlet weak var drawView: DrawableView!
    
    var image: UIImage?
    
    let color: [String] = ["000000",
                           "4CD964",
                           "5AC8FA",
                           "007AFF",
                           "FF2D55",
                           "FF3B30",
                           "FF9500",
                           "FFCC00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

    @IBAction func colorPressed(sender: UIBarButtonItem) {
        var id = 0
        if sender.tag >= 0 || sender.tag <= 7 {
            id = sender.tag
        }
        
        
        drawView.drawColor = self.hexStringToUIColor(hex: color[id])
        drawView.drawWidth = 8.0
        
    }

    @IBAction func erase(sender: UIBarButtonItem) {
        drawView.drawColor = UIColor.white
        drawView.drawWidth = 20.0
    }
    
    @IBAction func cancel(sender: AnyObject) {
        /*UIBarButtonItem) {
            dismissViewControllerAnimated(true, completion: nil)*/
    }
    
    func saveThought(){
        UIGraphicsBeginImageContextWithOptions(drawView.bounds.size, drawView.isOpaque, 0.0)
        drawView!.drawHierarchy(in: drawView.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = snapshotImageFromMyView
        self.image = imageByMakingWhiteBackgroundTransparent()
        
        
    }
   

 // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishedDrawing" {
                let controller = (segue.destination as! UINavigationController).topViewController as! PlaceViewController
                saveThought()
                controller.image = image        }
    }
    
    @IBAction func unwindToDrawViewController(sender: UIStoryboardSegue) {
        //Do nothing
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        if ((hex.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgbValue)
                return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        if let rawImageRef = self.image {
            //TODO: eliminate alpha channel if exsists
            let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
            UIGraphicsBeginImageContext((image?.size)!)
            if let maskedImageRef = image?.cgImage?.copy(maskingColorComponents: colorMasking) {
                UIGraphicsGetCurrentContext()!.translateBy(x: 0.0, y: rawImageRef.size.height)
                UIGraphicsGetCurrentContext()!.scaleBy(x: 1.0, y: -1.0)
                UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: rawImageRef.size.width, height: rawImageRef.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
 
}

