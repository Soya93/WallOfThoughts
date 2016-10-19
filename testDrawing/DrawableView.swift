import UIKit

//A view which you can draw on with your finger
class DrawableView : UIView {
    
    var drawColor: UIColor = UIColor.black
    var drawWidth: CGFloat = 8.0
    
    private var lastPoint: CGPoint = CGPoint.zero
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
        
        context!.setFillColor(self.backgroundColor?.cgColor ?? UIColor.white.cgColor)
        context!.fill(self.bounds)
        
        // Draw previous buffer first
        if let buffer = buffer {
            buffer.draw(in: self.bounds)
        }
        
        // Draw the line
        self.drawColor.setStroke()
        context!.setLineWidth(self.drawWidth)
        context!.setLineCap(.round)
        
        context!.move(to: a)
        context!.addLine(to: b)
        context!.strokePath()
        
        // Grab the updated buffer
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: Gestures
    
    private func setupGestureRecognizers() {
        // Set up a pan gesture recognizer to track where user moves finger
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender: )))
        self.addGestureRecognizer(panRecognizer)
    }
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        switch sender.state {
        case .began:
            self.startAtPoint(point: point)
        case .changed:
            self.continueAtPoint(point: point)
        case .ended:
            self.endAtPoint(point: point)
        case .failed:
            self.endAtPoint(point: point)
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
            // Draw the current stroke in an accumulated bitmap
            self.buffer = self.drawLine(a: self.lastPoint, b: point, buffer: self.buffer)
            
            // Replace the layer contents with the updated image
            self.layer.contents = self.buffer?.cgImage ?? nil
            
            // Update last point for next stroke
            self.lastPoint = point
        }
    }
    
    private func endAtPoint(point: CGPoint) {
        self.lastPoint = CGPoint.zero
    }
    
    
}
