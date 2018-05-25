//
//  ViewController.swift
//  swift-cameraFocus-rectangle
//
//  Created by Kristyan Danailov on 25.05.18 г..
//  Copyright © 2018 г. Kristyan Danailov. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var device = AVCaptureDevice.default(for: .video)
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        captureSession = AVCaptureSession()
        
        let input = try? AVCaptureDeviceInput(device: device!)
        captureSession?.addInput(input!)
        captureSession?.startRunning()

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)
        view.addGestureRecognizer(focusGesture)
    }

    // Tap To Focus Gesture
    lazy var focusGesture: UITapGestureRecognizer = {
        let instance = UITapGestureRecognizer(target: self, action: #selector(tapToFocus(_:)))
        instance.cancelsTouchesInView = false
        instance.numberOfTapsRequired = 1
        instance.numberOfTouchesRequired = 1
        return instance
    }()
    
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
 
}

