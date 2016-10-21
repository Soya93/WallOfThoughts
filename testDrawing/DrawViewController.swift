//
//  ViewController.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-09-28.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import UIKit 

//View controller for drawing thoughts
class DrawViewController: UIViewController {
    
    var image: UIImage?
    var drawView: DrawableView = DrawableView()
    var toolItems: [UIButton] = []
    var chosenButtonIndex : Int = 1
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-44)
        drawView.addObserver(self, forKeyPath: "hasDrawn", options: .new, context: nil)
        self.view.addSubview(drawView)
        doneButton.isEnabled = drawView.hasDrawn;
        setUpToolBar()
    }
    
    //An observer handling the enabling and disabling of button for coming to the next view
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "hasDrawn" {
            doneButton.isEnabled = drawView.hasDrawn;
        }
    }
    
    deinit {
        drawView.removeObserver(self, forKeyPath: "hasDrawn")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drawView.awakeFromNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Setting up the scrollable toolbar where the colors and the eraser are located
    func setUpToolBar(){
        let toolbarView = UIView(frame: CGRect(x: 0, y: (self.view.frame.height-88), width: self.view.frame.width, height: 88))
        toolbarView.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue:247.0/255.0, alpha:1.0)
        toolbarView.layer.borderWidth = 1
        toolbarView.layer.borderColor = ColorUtils.hexStringToUIColor(hex: "CECED2").cgColor
        let scrollView = UIScrollView()
        scrollView.frame.size.width = toolbarView.frame.width
        scrollView.frame.size.height = toolbarView.frame.height
        toolbarView.addSubview(scrollView)
        self.view.addSubview(toolbarView)
        
        
        toolItems = []
        chosenButtonIndex = 1
        let frame1 = CGRect(x: 0, y: 0 , width: 89, height: 89 )
        let eraseButton = UIButton(type: UIButtonType.system)
        eraseButton.frame = frame1
        eraseButton.setImage(#imageLiteral(resourceName: "erase"), for: .normal)
        eraseButton.tintColor = ColorUtils.hexStringToUIColor(hex: ColorUtils.toolbarColors[8])
        eraseButton.addTarget(self, action:#selector(self.erase(sender:)), for: .touchUpInside)

        
        toolItems.append(eraseButton)
        scrollView.addSubview(eraseButton)
        
         for index in 1...ColorUtils.toolbarColors.count {
            let frame1 = CGRect(x: 0 + (index * 66), y: 0 , width: 89, height: 89 )
            let button = UIButton(type: UIButtonType.system)
            button.frame = frame1
            button.setImage(#imageLiteral(resourceName: "black"), for: .normal)
            button.tintColor = ColorUtils.hexStringToUIColor(hex: ColorUtils.toolbarColors[index-1])
            button.tag = index
            button.addTarget(self, action:#selector(self.colorPressed(sender:)), for: .touchUpInside)
            scrollView.addSubview(button)
            toolItems.append(button)
         }
        
        scrollView.contentSize.width = CGFloat(66*toolItems.count)
        toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "black-big"), for: .normal)
    }

    //Method which handles when color in the toolbar has been pressed.
    @IBAction func colorPressed(sender: UIButton) {
        var id = 0
        if sender.tag >= 0 || sender.tag <= 8 {
            id = sender.tag
        }
        
        //Changes the image of the previous and the current chosen color.
        if chosenButtonIndex != 0 {
            toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "black"), for: .normal)
        }else{
            toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "erase"), for: .normal)
        }
        sender.setImage(#imageLiteral(resourceName: "black-big"), for: .normal)
        chosenButtonIndex = sender.tag
        
        //Update color and width for drawing
        drawView.drawColor = ColorUtils.hexStringToUIColor(hex: ColorUtils.toolbarColors[id-1])
        drawView.drawWidth = 8.0
    }

    //Method which handles actions involving the eraser of the toolbar.
    @IBAction func erase(sender: UIButton) {
        
        //Changes the image of the previous and the current chosen eraser.
        if chosenButtonIndex != 0 {
            toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "black"), for: .normal)
        }
        chosenButtonIndex = 0
        toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "erase-big"), for: .normal)
        
        //Update color and width for drawing
        drawView.drawColor = UIColor.white
        drawView.drawWidth = 30.0
    }

    //Method which takes the canvas and makes returns in an image with a transparent background.
    func saveThought(){
        UIGraphicsBeginImageContextWithOptions(drawView.bounds.size, drawView.isOpaque, 0.0)
        drawView.drawHierarchy(in: drawView.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = snapshotImageFromMyView
        self.image = ImageUtils.imageByMakingWhiteBackgroundTransparent(image: image!)
    }
   
    /*Method invoked when the "done"-button is pressed. The image is saved, and a segue is
    peformed to perceed to the next view */
    @IBAction func done(_ sender: UIBarButtonItem) {
            saveThought()
            performSegue(withIdentifier: "finishedDrawing", sender: sender)
    }

 // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishedDrawing" {
                let controller = (segue.destination as! UINavigationController).topViewController as! PlaceViewController
                controller.image = image
        }
    }
    
    @IBAction func unwindToDrawViewController(sender: UIStoryboardSegue) {
        //Do nothing
    }

    func addBorder(layer: CALayer, color: UIColor, thickness: CGFloat) -> CALayer {
        
        let border = layer
        
        border.frame = CGRect(x: 0, y: 0, width: layer.frame.width, height: thickness)

        border.backgroundColor = color.cgColor;
        
        return border
    }
}

