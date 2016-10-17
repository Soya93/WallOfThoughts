//
//  ViewController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-09-28.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import UIKit 

class DrawViewController: UIViewController {
    
    var image: UIImage?
    var drawView: DrawableView = DrawableView()
    
    var toolItems: [UIButton] = []
    var chosenButtonIndex : Int = 1
    
    let colors: [String] = ["000000",
                           "4CD964",
                           "5AC8FA",
                           "007AFF",
                           "FF2D55",
                           "FF3B30",
                           "FF9500",
                           "FFCC00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-44)
        self.view.addSubview(drawView)
        setUpToolBar()
        //self.navigationController?.isToolbarHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        drawView.awakeFromNib()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpToolBar(){
        
        let toolbarView = UIView(frame: CGRect(x: 0, y: (self.view.frame.height-44), width: self.view.frame.width, height: 44))
        let scrollView = UIScrollView()
        scrollView.frame.size.width = toolbarView.frame.width
        scrollView.frame.size.height = toolbarView.frame.height
        toolbarView.addSubview(scrollView)
        self.view.addSubview(toolbarView)
        
        
        toolItems = []
        chosenButtonIndex = 1
        let frame1 = CGRect(x: 0, y: 0 , width: 45, height: 45 )
        let eraseButton = UIButton(type: UIButtonType.system)
        eraseButton.frame = frame1
        eraseButton.setImage(#imageLiteral(resourceName: "erase"), for: .normal)
        eraseButton.tintColor = hexStringToUIColor(hex: colors[2])
        eraseButton.addTarget(self, action:#selector(self.erase(sender:)), for: .touchUpInside)

        
        toolItems.append(eraseButton)
        scrollView.addSubview(eraseButton)
        
         for index in 1...colors.count {
            let frame1 = CGRect(x: 0 + (index * 44), y: 0 , width: 45, height: 45 )
            let button = UIButton(type: UIButtonType.system)
            button.frame = frame1
            button.setImage(#imageLiteral(resourceName: "black"), for: .normal)
            button.tintColor = hexStringToUIColor(hex: colors[index-1])
            button.tag = index
            button.addTarget(self, action:#selector(self.colorPressed(sender:)), for: .touchUpInside)
            scrollView.addSubview(button)
            toolItems.append(button)
         }
        
        scrollView.contentSize.width = CGFloat(44*toolItems.count)
        toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "black-big"), for: .normal)
        
    }

    @IBAction func colorPressed(sender: UIButton) {
        var id = 0
        if sender.tag >= 0 || sender.tag <= 8 {
            id = sender.tag
        }
        if chosenButtonIndex != 0 {
            toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "black"), for: .normal)
        }else{
            toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "erase"), for: .normal)
        }
        sender.setImage(#imageLiteral(resourceName: "black-big"), for: .normal)
        chosenButtonIndex = sender.tag
        drawView.drawColor = self.hexStringToUIColor(hex: colors[id-1])
        drawView.drawWidth = 8.0
        
    }

    @IBAction func erase(sender: UIButton) {
        if chosenButtonIndex != 0 {
            toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "black"), for: .normal)
        }
        
        chosenButtonIndex = 0
        toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "erase-big"), for: .normal)
        drawView.drawColor = UIColor.white
        drawView.drawWidth = 20.0
    }
    
    @IBAction func cancel(sender: AnyObject) {
        /*UIBarButtonItem) {
            dismissViewControllerAnimated(true, completion: nil)*/
    }
    
    func saveThought(){
        UIGraphicsBeginImageContextWithOptions(drawView.bounds.size, drawView.isOpaque, 0.0)
        drawView.drawHierarchy(in: drawView.bounds, afterScreenUpdates: false)
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

