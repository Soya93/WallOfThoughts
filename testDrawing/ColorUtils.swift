//
//  ColorUtils.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-19.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import Foundation

class ColorUtils {
    
    static let toolbarColors: [String] = ["000000", //black
                                          "2F811C", //dark green
                                          "4CD964", //green
                                          "5AC8FA", //light blue
                                          "007AFF", //blue
                                          "7C328D", //dark purple
                                          "CD6AE8", //purple
                                          "D53BA0", //pink
                                          "FF2D55", //redpink
                                          "FF3B30", //red
                                          "FF9500", //orange
                                          "FFCC00"] //yellow
    
    //Function for translating a hex string to a UIColor
    class func hexStringToUIColor (hex:String) -> UIColor {
        
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
}
