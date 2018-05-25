# Getting Started
Add `Tap To Focus` gesture recognizer and frame it with `Yellow Square` on the tapped location.

![alt tag](https://image.ibb.co/iLwyqo/iphone_Xwith_Frame_Mock_Up.png "User taps once to focus on object")
___

First we're overriding "draw(_ rect)" for drawing the yellow square:

```swift
import UIKit

class DrawSquare: UIView {

    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width
        let color:UIColor = UIColor.yellow
        
        let drect = CGRect(x: (w * 0.25),y: (h * 0.25),width: (w * 0.5),height: (h * 0.5))
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
    }

}
```
___

Then after the `captureSession` and `previewLayer` are all set up we create the `tapToFocus` function to make our device
focus on the target and draw the square around the tapped location:

```swift
 // Tap To Focus Function and Draw Rectangle
    @objc func tapToFocus(_ gesture: UITapGestureRecognizer) {
        guard let previewLayer = previewLayer else {
            print("Expected a previewLayer")
            return
        }
        guard let device = device else {
            print("Expected a device")
            return
        }
        
        
        let touchPoint: CGPoint = gesture.location(in: view)
        let convertedPoint: CGPoint = previewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) {
            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = convertedPoint
                device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                device.unlockForConfiguration()
            } catch {
                print("unable to focus")
            }
        }
        let location = gesture.location(in: view)
        let x = location.x - 125
        let y = location.y - 125
        let lineView = DrawSquare(frame: CGRect(x: x, y: y, width: 250, height: 250))
        lineView.backgroundColor = UIColor.clear
        lineView.alpha = 0.9
        view.addSubview(lineView)
        
        DrawSquare.animate(withDuration: 1, animations: {
            lineView.alpha = 1
        }) { (success) in
            lineView.alpha = 0
        }
        
    }
