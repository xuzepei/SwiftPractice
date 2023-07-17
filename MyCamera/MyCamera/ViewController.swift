//
//  ViewController.swift
//  MyCamera
//
//  Created by xuzepei on 2023/7/12.
//

import UIKit
import AVFoundation
import CoreImage
import CoreML
import Vision

class ViewController: UIViewController {
    
    //MARK:- Vars
    var captureSession : AVCaptureSession!
    
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var backInput : AVCaptureInput!
    var frontInput : AVCaptureInput!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var videoOutput : AVCaptureVideoDataOutput!
    var maskLayer: CALayer!
    
    var filter: CIFilter!
    private var assetWriter: AVAssetWriter?
    private var assetWriterInput: AVAssetWriterInput?
    private var assetWriterInputPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    var takePicture = false
    var backCameraOn = true
    
    //MARK:- View Components
    let switchCameraButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "switchcamera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let captureImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let capturedImageView = CapturedImageView()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
        setupCamera()
        setupFilter()
    }
    
    
    //MARK:- Camera Setup
    func setupCamera(){
        DispatchQueue.global(qos: .userInitiated).async{
            //init session
            self.captureSession = AVCaptureSession()
            //start configuration
            self.captureSession.beginConfiguration()
            
            //session specific configuration
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            //setup inputs
            self.setupInputs()
            
            DispatchQueue.main.async {
                //setup preview layer
                self.setupPreviewLayer()
                
                self.setupMaskLayer()
            }
            
            //setup output
            self.setupOutput()
            
            //commit configuration
            self.captureSession.commitConfiguration()
            //start running it
            self.captureSession.startRunning()
        }
    }
    
    //MARK:- View Setup
    func setup(){
        view.backgroundColor = .brown
        view.addSubview(switchCameraButton)
        view.addSubview(captureImageButton)
        view.addSubview(capturedImageView)
        
        NSLayoutConstraint.activate([
            switchCameraButton.widthAnchor.constraint(equalToConstant: 30),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 30),
            switchCameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            switchCameraButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            captureImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            captureImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            captureImageButton.widthAnchor.constraint(equalToConstant: 50),
            captureImageButton.heightAnchor.constraint(equalToConstant: 50),
            
            capturedImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            capturedImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            capturedImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            capturedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -70)
        ])
        
        switchCameraButton.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
        captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
    }
    
    private func setupFilter() {
        //        filter = CIFilter(name: "CIColorControls")
        //
        //        // 设置美颜参数，可以根据需要进行调整
        //        filter.setValue(1.0, forKey: kCIInputSaturationKey) // 饱和度
        //        filter.setValue(0.5, forKey: kCIInputContrastKey) // 对比度
        //        filter.setValue(2.0, forKey: kCIInputBrightnessKey) // 亮度
        
        filter = CIFilter(name: "CISepiaTone")
        
        
    }
    
    //MARK:- Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
        case .authorized:
            return
        case .denied:
            abort()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                                            { (authorized) in
                if(!authorized){
                    abort()
                }
            })
        case .restricted:
            abort()
        @unknown default:
            fatalError()
        }
    }
    
    func setupInputs(){
        //get back camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            //handle this appropriately for production purposes
            fatalError("no back camera")
        }
        
        //get front camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = device
        } else {
            fatalError("no front camera")
        }
        
        //now we need to create an input objects from our devices
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("could not create input device from back camera")
        }
        backInput = bInput
        if !captureSession.canAddInput(backInput) {
            fatalError("could not add back camera input to capture session")
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("could not create input device from front camera")
        }
        frontInput = fInput
        if !captureSession.canAddInput(frontInput) {
            fatalError("could not add front camera input to capture session")
        }
        
        //connect back camera input to session
        captureSession.addInput(backInput)
    }
    
    func setupOutput(){
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspect
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, below: switchCameraButton.layer)
        previewLayer.frame = self.view.layer.frame
        //previewLayer.position = CGPoint(x: previewLayer.position.x, y: )
        print("frame: \(previewLayer.frame)")
    }
    
    func setupMaskLayer(){
        // Create a UIImage object with the desired image
        let image = UIImage(named: "head_outline_thin")
        
        // Create a CALayer object
        maskLayer = CALayer()
        
        // Set the image as the layer's contents
        maskLayer.contents = image?.cgImage
        
        // Set the layer's frame to position and size the image
        maskLayer.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        maskLayer.position = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y)
        
        // Add the layer to the view's layer hierarchy
        previewLayer.addSublayer(maskLayer)
    }
    
    func switchCameraInput(){
        //don't let user spam the button, fun for the user, not fun for performance
        switchCameraButton.isUserInteractionEnabled = false
        
        //reconfigure the input
        captureSession.beginConfiguration()
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            backCameraOn = true
        }
        
        //deal with the connection again for portrait mode
        videoOutput.connections.first?.videoOrientation = .portrait
        
        //mirror the video stream for front camera
        videoOutput.connections.first?.isVideoMirrored = !backCameraOn
        
        //commit config
        captureSession.commitConfiguration()
        
        //acitvate the camera button again
        switchCameraButton.isUserInteractionEnabled = true
    }
    
    //MARK:- Actions
    @objc func captureImage(_ sender: UIButton?){
        takePicture = true
    }
    
    @objc func switchCamera(_ sender: UIButton?){
        switchCameraInput()
    }
    
    // 函数用于执行人像抠图并返回结果
    func performPortraitSegmentation(image: CIImage) {
        // 将 UIImage 转换为 CIImage
//        guard let ciImage = CIImage(image: image) else {
//            print("无法将图像转换为 CIImage")
//            return
//        }
        
        // 创建人像分割模型
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else {
            print("无法加载人像分割模型")
            return
        }
        
//        // 创建分割请求
//        let request = VNCoreMLRequest(model: model) { (request, error) in
//            // 处理分割结果
//            if let results = request.results as? [VNPixelBufferObservation],
//               let segmentationMap = results.first?.pixelBuffer {
//                // 创建带有分割结果的 UIImage
//                let segmentedImage = self.imageFromPixelBuffer(pixelBuffer: segmentationMap)
//
//                // 在此处使用分割结果进行进一步处理或显示
//                // ...
//
//                // 示例：将结果显示在 UIImageView 上
//                DispatchQueue.main.async {
//                    self.capturedImageView.image = segmentedImage
//                }
//            } else {
//                print("无法完成人像分割")
//            }
//        }
        
        let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .scaleFill
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
        }catch {
            print(error)
            print("无法完成人像分割")
        }
        
        // 创建图像处理请求队列
//        let handler = VNImageRequestHandler(ciImage: ciImage)
//        do {
//            // 执行分割请求
//            try handler.perform([request])
//        } catch {
//            print("无法执行人像分割请求: \(error)")
//        }
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
                DispatchQueue.main.async {
                    if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                        let segmentationmap = observations.first?.featureValue.multiArrayValue {
                        
                        if let image = self.getImage(from: segmentationmap) {
                            self.capturedImageView.image = image
                        } else {
                            print("获取图片失败")
                        }
                        
                        //let segmentationMask = segmentationmap.image(min: 0, max: 1)

                        //self.outputImage = segmentationMask!.resizedImage(for: self.inputImage.size)!

                        //maskInputImage()
                    }
                }
        }
    
    func imageFromPixelBuffer(pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    func getImage(from multiArrayValue: MLMultiArray) -> UIImage? {
//        guard let multiArrayValue = observation.featureValue.multiArrayValue else {
//            return nil
//        }

        // Convert MLMultiArray to CVPixelBuffer
        guard let pixelBuffer = multiArrayValue.toPixelBuffer() else {
            return nil
        }

        // Create CIImage from CVPixelBuffer
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // Convert CIImage to UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
    
}

// Extension to convert MLMultiArray to CVPixelBuffer
extension MLMultiArray {

    func toPixelBuffer() -> CVPixelBuffer? {
        let width = 200
        let height = 300
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(nil, width, height,
                                         kCVPixelFormatType_32BGRA,
                                         nil, &pixelBuffer)
        if status != kCVReturnSuccess {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let dataSize = height * CVPixelBufferGetBytesPerRow(pixelBuffer!)
        memcpy(data, self.dataPointer, dataSize)
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        //        // 获取视频帧数据
        //        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        //
        //        // 创建一个CIImage对象
        //        let ciImage1 = CIImage(cvPixelBuffer: pixelBuffer)
        //
        //        // 创建CIFilter，并设置美白参数
        //        guard let filter = CIFilter(name: "CIColorControls") else { return }
        //        filter.setValue(ciImage1, forKey: kCIInputImageKey)
        //        filter.setValue(1.8, forKey: kCIInputBrightnessKey)
        //        filter.setValue(1.8, forKey: kCIInputContrastKey)
        //
        //        // 获取输出图像
        //        guard let outputImage = filter.outputImage else { return }
        //
        //        // 创建一个CIContext对象，并将输出图像渲染到CVPixelBuffer中
        //        let context = CIContext()
        //        context.render(outputImage, to: pixelBuffer)
        
        
        
        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        //get UIImage out of CIImage
        let uiImage = UIImage(ciImage: ciImage)
        
        
        DispatchQueue.main.async {
            //self.capturedImageView.image = uiImage
            self.performPortraitSegmentation(image: ciImage)
            self.takePicture = false
        }
    }
    
}
