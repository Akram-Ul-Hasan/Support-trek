//
//  PreviewCameraCollectionViewCell.swift
//  Support
//
//  Created by Akram Ul Hasan on 9/5/24.
//

import UIKit
import AVFoundation

class PreviewCameraCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cameraView: UIView!
//    @IBOutlet weak var cameraLogo: UIImageView!
      
    private var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession = AVCaptureSession()
    
    static public let className = String(describing: PreviewCameraCollectionViewCell.self)
    
    static public func nib() -> UINib{
        return UINib(nibName: PreviewCameraCollectionViewCell.className, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCameraPreview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
//        cameraLogo.image = UIImage(named: "camera")
//        cameraLogo.contentMode = .scaleAspectFit
    }

    
    private func setupCameraPreview() {
        self.captureSession = AVCaptureSession()
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Back camera not available.")
            return
        }
            
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
        } catch let error {
            print("Error setting up camera input:", error.localizedDescription)
            return
        }
            
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
            
        captureSession.startRunning()
    }
    
    func startCamera(withDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.captureSession.startRunning()
//            print("camera start")
        }
    }
        
    func stopCamera() {
        DispatchQueue.main.async {
            self.captureSession.stopRunning()
//            print("camera stop")
        }
    }
}
