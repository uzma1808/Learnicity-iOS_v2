//
//  QRScannerView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 27/09/2025.
//

import SwiftUI
import AVFoundation

struct QRScannerView: UIViewRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRScannerView

        init(parent: QRScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               let code = metadataObject.stringValue {
                if parent.scannedCode == nil {
                    parent.scannedCode = code   // ✅ Success → QR code string available
                    print("QRCODE", code)
                    parent.session.stopRunning()
                }
            } else {
                // ❌ Failure → No QR code detected
                parent.scannedCode = nil
            }
        }

    }

    @Binding var scannedCode: String?
    private let session = AVCaptureSession()

    func makeUIView(context: Context) -> UIView {
        let view = CameraPreviewView(session: session)

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return view }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error setting up camera: \(error)")
            return view
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }

        return view
    }


    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

class CameraPreviewView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer?

    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(layer)
        self.previewLayer = layer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}
