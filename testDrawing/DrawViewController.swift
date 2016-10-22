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
    var toolbarView: ToolbarView = ToolbarView()
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-44)
        drawView.addObserver(self, forKeyPath: "hasDrawn", options: .new, context: nil)
        self.view.addSubview(drawView)
        doneButton.isEnabled = drawView.hasDrawn;

        //Set up the toolbar and their actions
        toolbarView.setUpToolBar(viewHeight: self.view.frame.height, viewWidth: self.view.frame.width)
        self.view.addSubview(toolbarView)
        toolbarView.eraseButton.addTarget(self, action:#selector(self.erase(sender:)), for: .touchUpInside)
        for index in 1...ColorUtils.toolbarColors.count {
            toolbarView.toolItems[index].addTarget(self, action:#selector(self.colorPressed(sender:)), for: .touchUpInside)
        }
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
    
    //Method which handles when color in the toolbar has been pressed.
    @IBAction func colorPressed(sender: UIButton) {
        var id = 0
        if sender.tag >= 0 || sender.tag <= 8 {
            id = sender.tag
        }
        
        //Changes the image of the previous and the current chosen color.
        if toolbarView.chosenButtonIndex != 0 {
            toolbarView.toolItems[toolbarView.chosenButtonIndex].setImage(#imageLiteral(resourceName: "black"), for: .normal)
        }else{
            toolbarView.toolItems[toolbarView.chosenButtonIndex].setImage(#imageLiteral(resourceName: "erase"), for: .normal)
        }
        sender.setImage(#imageLiteral(resourceName: "black-big"), for: .normal)
        toolbarView.chosenButtonIndex = sender.tag
        
        //Update color and width for drawing
        drawView.drawColor = ColorUtils.hexStringToUIColor(hex: ColorUtils.toolbarColors[id-1])
        drawView.drawWidth = 8.0
    }
    
    //Method which handles actions involving the eraser of the toolbar.
    @IBAction func erase(sender: UIButton) {
        
        //Changes the image of the previous and the current chosen eraser.
        if toolbarView.chosenButtonIndex != 0 {
            toolbarView.toolItems[toolbarView.chosenButtonIndex].setImage(#imageLiteral(resourceName: "black"), for: .normal)
        }
        toolbarView.chosenButtonIndex = 0
        toolbarView.toolItems[toolbarView.chosenButtonIndex].setImage(#imageLiteral(resourceName: "erase-big"), for: .normal)
        
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
}

