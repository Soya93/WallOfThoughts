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
    
    var toolItems: [UIBarButtonItem] = []
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
        self.navigationController?.isToolbarHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        drawView.awakeFromNib()
        setUpToolBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpToolBar(){
        navigationController?.isToolbarHidden = false
        toolItems = []
        chosenButtonIndex = 1
        let eraseButton: UIBarButtonItem = createBarButtonItem(title: nil, image: #imageLiteral(resourceName: "erase"), style: .plain, target: self, selector: #selector(erase(sender:)))
        eraseButton.tintColor = hexStringToUIColor(hex: colors[2])
        
        toolItems.append(eraseButton)
        
        for index in 0..<colors.count {
            let button : UIBarButtonItem = createBarButtonItem(title: nil, image: #imageLiteral(resourceName: "green"), style: .plain, target: self, selector: #selector(colorPressed(sender:)))
            
            button.tintColor = hexStringToUIColor(hex: colors[index])
            button.tag = index
            
            toolItems.append(button)
        }
        
        toolItems[chosenButtonIndex].image = #imageLiteral(resourceName: "black-big")
        navigationController?.toolbar.setItems(toolItems, animated: false)
    }

    @IBAction func colorPressed(sender: UIBarButtonItem) {
        var id = 0
        if sender.tag >= 0 || sender.tag <= 7 {
            id = sender.tag
        }
        if chosenButtonIndex != 0 {
            toolItems[chosenButtonIndex].image = #imageLiteral(resourceName: "black")
        }else{
            toolItems[chosenButtonIndex].image = #imageLiteral(resourceName: "erase")
        }
        sender.image = #imageLiteral(resourceName: "black-big")
        chosenButtonIndex = sender.tag+1
        drawView.drawColor = self.hexStringToUIColor(hex: colors[id])
        drawView.drawWidth = 8.0
        
    }

    @IBAction func erase(sender: UIBarButtonItem) {
        if chosenButtonIndex != 0 {
            toolItems[chosenButtonIndex].image = #imageLiteral(resourceName: "black")
        }
        
        chosenButtonIndex = 0
        toolItems[chosenButtonIndex].image = #imageLiteral(resourceName: "erase-big")
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
    
    func createBarButtonItem(title: String?, image : UIImage?, style : UIBarButtonItemStyle?, target : AnyObject?, selector : Selector?) -> UIBarButtonItem{
        let button = UIBarButtonItem()
        if let theTitle = title {
            button.title = theTitle
        }
        if let theImage = image {
            button.image = theImage
        }
        if let theStyle = style{
            button.style = theStyle
        }
        if let theTarget = target {
            button.target = theTarget
        }
        if let theSelector = selector {
            button.action = theSelector
        }
        return button
    }
}

