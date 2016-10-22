//
//  ToolbarView.swift
//  testDrawing
//
//  Created by Sara Nadi on 2016-10-22.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import Foundation
import UIKit

//A view which handles the toolbar used to draw a thought
class ToolbarView : UIView {
    
    var toolItems: [UIButton] = []
    var chosenButtonIndex : Int = 1
    let eraseButton = UIButton(type: UIButtonType.system)
    let scrollView = UIScrollView()

    //Setting up the scrollable toolbar where the colors and the eraser are located
    func setUpToolBar(viewHeight: CGFloat, viewWidth: CGFloat){
        self.frame = CGRect(x: 0, y: (viewHeight-88), width: viewWidth, height: 88)
        self.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue:247.0/255.0, alpha:1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorUtils.hexStringToUIColor(hex: "CECED2").cgColor
        
        scrollView.frame.size.width = (self.frame.width)
        scrollView.frame.size.height = (self.frame.height)
        self.addSubview(scrollView)
        
        toolItems = []
        chosenButtonIndex = 1
        let frame1 = CGRect(x: 0, y: 0 , width: 89, height: 89 )
        eraseButton.frame = frame1
        eraseButton.setImage(#imageLiteral(resourceName: "erase"), for: .normal)
        eraseButton.tintColor = ColorUtils.hexStringToUIColor(hex: ColorUtils.toolbarColors[8])
        
        
        toolItems.append(eraseButton)
        scrollView.addSubview(eraseButton)
        
        for index in 1...ColorUtils.toolbarColors.count {
            let frame1 = CGRect(x: 0 + (index * 66), y: 0 , width: 89, height: 89 )
            let button = UIButton(type: UIButtonType.system)
            button.frame = frame1
            button.setImage(#imageLiteral(resourceName: "black"), for: .normal)
            button.tintColor = ColorUtils.hexStringToUIColor(hex: ColorUtils.toolbarColors[index-1])
            button.tag = index
            scrollView.addSubview(button)
            toolItems.append(button)
        }
        
        scrollView.contentSize.width = CGFloat(66*toolItems.count)
        toolItems[chosenButtonIndex].setImage(#imageLiteral(resourceName: "black-big"), for: .normal)

    }
}
