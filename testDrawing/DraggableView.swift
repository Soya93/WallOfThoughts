//
//  DraggableView.swift
//  testDrawing
//
//  Created by Julia Friberg on 2016-10-04.
//  Copyright © 2016 Julia Friberg. All rights reserved.
//

import UIKit

//A view which follows the users finger on the screen
class DraggableView: UIImageView {

    
    var lastLocation:CGPoint = CGPoint.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        // Set up a pan gesture recognizer to track where user moves finger
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan(recognizer: )))
        self.addGestureRecognizer(panRecognizer)
    }
    
    
    @objc func detectPan(recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview!)
        self.center = CGPoint(x: (lastLocation.x + translation.x), y: (lastLocation.y + translation.y))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Promote the touched view
        self.superview?.bringSubview(toFront: self)
        
        // Remember original location
        lastLocation = self.center
    }
    

}
