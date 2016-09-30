import UIKit

class DrawableView : UIView {
    
    var drawColor: UIColor = UIColor.blackColor()
    var drawWidth: CGFloat = 8.0
    
    private var lastPoint: CGPoint = CGPointZero
    private var buffer: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGestureRecognizers()
    }
    
    // MARK: Drawing a path
    
    private func drawLine(a: CGPoint, b: CGPoint, buffer: UIImage?) -> UIImage {
        let size = self.bounds.size
        
        // Initialize a full size image. Opaque because we don’t need to draw over anything. Will be more performant.
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, self.backgroundColor?.CGColor ?? UIColor.whiteColor().CGColor)
        CGContextFillRect(context, self.bounds)
        
        // Draw previous buffer first
        if let buffer = buffer {
            buffer.drawInRect(self.bounds)
        }
        
        // Draw the line
        self.drawColor.setStroke()
        CGContextSetLineWidth(context, self.drawWidth)
        CGContextSetLineCap(context, .Round)
        
        CGContextMoveToPoint(context, a.x, a.y)
        CGContextAddLineToPoint(context, b.x, b.y)
        CGContextStrokePath(context)
        
        // Grab the updated buffer
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: Gestures
    
    private func setupGestureRecognizers() {
        // 1. Set up a pan gesture recognizer to track where user moves finger
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawableView.handlePan(_:)))
        self.addGestureRecognizer(panRecognizer)
    }
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(self)
        switch sender.state {
        case .Began:
            self.startAtPoint(point)
        case .Changed:
            self.continueAtPoint(point)
        case .Ended:
            self.endAtPoint(point)
        case .Failed:
            self.endAtPoint(point)
        default:
            assert(false, "State not handled")
        }
    }
    
    // MARK: Tracing a line
    
    private func startAtPoint(point: CGPoint) {
        self.lastPoint = point
    }
    
    private func continueAtPoint(point: CGPoint) {
        autoreleasepool {
            // 2. Draw the current stroke in an accumulated bitmap
            self.buffer = self.drawLine(self.lastPoint, b: point, buffer: self.buffer)
            
            // 3. Replace the layer contents with the updated image
            self.layer.contents = self.buffer?.CGImage ?? nil
            
            // 4. Update last point for next stroke
            self.lastPoint = point
        }
    }
    
    private func endAtPoint(point: CGPoint) {
        self.lastPoint = CGPointZero
    }
    
    
}