

import UIKit

// MARK: - Delegate
protocol ImageCropViewDelegate {

}

class ImageCropView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var figureBgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageMaskView: UIView!
    @IBOutlet weak var gridView: UIView!

    var targetPhoto: Photo!
    
    var originalImage: UIImage!
    var imageFrame = CGRect.zero //图片的Rect
    var figureFrame = CGRect.zero //剪切框的Rect
    
    
    var panLastLocation: CGPoint?
    
    var bgView: UIView!
    var completionBlock: ((Bool)->Void)? = nil
    
    // MARK: - Init
    class func instanceFromNib() -> ImageCropView {
        let view = UINib(nibName: "ImageCropView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ImageCropView
        //view.setup()
        return view
    }
    
    func updateContent(originalImage: UIImage, targetPhoto: Photo) {
        
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        
        localize()
        
        
        //self.gridView.backgroundColor = .clear
        self.originalImage = originalImage
        self.targetPhoto = targetPhoto
        var size = self.targetPhoto.pixelSize
        while size.width > self.width() || size.height > self.height() {
            size = CGSize(width: size.width * 0.9, height: size.height * 0.9)
        }
        
        let figureSize = CGSize(width: size.width, height: size.height)
        figureFrame = CGRect(x: (self.bounds.width - figureSize.width) / 2, y: (self.bounds.height - figureSize.height) / 2, width: figureSize.width, height: figureSize.height)
        
        
        self.figureBgView.frame = figureFrame
      
        
        imageFrame = imageInitialFrame
        
        self.imageView.image = self.originalImage
        self.imageView.frame = imageFrame
        
        self.drawMask()
        self.drawBorber()

        self.layoutIfNeeded()
    }
    
    var imageInitialFrame: CGRect {
        var size = self.originalImage.size.scale(to: self.figureFrame.size)
        
        //size = CGSize(width: size.width * 1.25, height: size.height * 1.25)
        size = CGSize(width: size.width + 10, height: size.height + 10)
        return CGRect(x: (self.bounds.width - size.width) / 2, y: (self.bounds.height - size.height) / 2, width: size.width, height: size.height)
    }
    
    func drawMask() {
        
        var holePath: CGPath {
            var border: CGPath {
                return UIBezierPath(roundedRect: self.figureFrame, cornerRadius: 0.0).cgPath
            }
            let hole = UIBezierPath(cgPath: border)
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0)
            path.append(hole)
            return path.cgPath
        }
        
        let hole = CAShapeLayer()
        hole.frame = self.imageMaskView.bounds
        hole.path = holePath
        hole.fillRule = CAShapeLayerFillRule.evenOdd
        self.imageMaskView.layer.mask = hole
        self.imageMaskView.backgroundColor = UIColor.systemGray6
    }
    
    func drawBorber() {
        
      let extendedRect = self.figureFrame.extendedBy(dx: 2, dy: 2)
//        print("Original Rect:", self.figureFrame)
//        print("Extended Rect:", extendedRect)
        
      let path = UIBezierPath(rect: extendedRect).cgPath
      let border = CAShapeLayer()
      border.frame = self.gridView.bounds
      border.path = path
      border.fillColor = UIColor.clear.cgColor
      border.strokeColor = UIColor.white.cgColor
      border.lineWidth = 5
      self.gridView.layer.addSublayer(border)
    }
    
    func localize() {
//        self.titleLabel.text = LS("New Version Found")
//        self.cancelButton.setTitle(LS("Cancel"), for: .normal)
//        self.okButton.setTitle(LS("Update Now"), for: .normal)
    }
    
    func draggingFrame(for point: CGPoint) -> CGRect {
      let previousLocation = panLastLocation ?? point
      let difference = CGPoint(x: point.x - previousLocation.x, y: point.y - previousLocation.y)
      
      let borders = figureFrame //.shrinkBy(dx: figureFrame.size.width*0.5, dy: figureFrame.size.height*0.5)
      
      let x = imageFrame.origin.x + difference.x
      let newX = x < borders.origin.x && x + imageFrame.width > borders.maxX ? x : imageFrame.origin.x
      
      let y = imageFrame.origin.y + difference.y
      let newY = y < borders.origin.y && y + imageFrame.height > borders.maxY ? y : imageFrame.origin.y
      
      imageFrame = CGRect(origin: CGPoint(x: newX, y: newY), size: imageFrame.size)
        
      panLastLocation = point
      return imageFrame
    }
    
    func didDrag(to location: CGPoint) {
      NSLog("didDrag")
      self.imageView.frame = self.draggingFrame(for: location)
    }
    
//    func didPinchStarted() {
//      //model.setStartedPinch()
//        NSLog("didPinchStarted")
//    }
    
    func scalingFrame(for scale: CGFloat) -> CGRect {
        
        NSLog("scalingFrame: \(scale)")
        
        let borders = figureFrame//.shrinkBy(dx: 100, dy: 100)
        let pinchStartSize = CGSize(width: imageFrame.width, height: imageFrame.height)
        var newSize = CGSize(width: pinchStartSize.width * scale, height: pinchStartSize.height * scale)
        
        if newSize.width < borders.width || newSize.height < borders.height {
            newSize = imageView.image!.size.scale(to: borders.size)
        }
        var newX = imageFrame.origin.x - (newSize.width - imageFrame.width) / 2
        var newY = imageFrame.origin.y - (newSize.height - imageFrame.height) / 2
        
        if newX + newSize.width <= borders.maxX {
            newX = borders.maxX - newSize.width
        }
        else if newX >= borders.origin.x {
            newX = borders.origin.x
        }
        
        if newY + newSize.height <= borders.maxY {
            newY = borders.maxY - newSize.height
        }
        else if newY >= borders.origin.y {
            newY = borders.origin.y
        }
        
        if newSize.width / imageView.image!.size.width < 2 || newSize.height / imageView.image!.size.height < 2  {
            
            let newImageFrame = CGRect(origin: CGPoint(x: newX, y: newY), size: newSize)
            NSLog("newImageFrame: \(newImageFrame)")
            if newImageFrame.size.width <= figureFrame.size.width * 5 && newImageFrame.size.height <= figureFrame.size.height  * 5 {
                imageFrame = CGRect(origin: CGPoint(x: newX, y: newY), size: newSize)
            }
        }
        
        return imageFrame
    }
    
    func didScale(with scale: CGFloat) {
        
        //let scaleValue = min(max(scale, 0.0), 1.5)
        self.imageView.frame = self.scalingFrame(for: scale)
    }
    
    func centerFrame() -> CGRect {
      if imageInitialFrame.center != imageFrame.center {
        imageFrame.center = imageInitialFrame.center
      }
      else {
        imageFrame = imageInitialFrame
      }
      
      return imageFrame
    }
    
    func didDoubleTap() {
        NSLog("didDoubleTap")
        
        UIView.animate(withDuration: 0.2) {
            self.imageView.frame = self.centerFrame()
        }
    }
    
    func crop() -> UIImage {
      let borders = figureFrame
        
        NSLog("figureFrame: \(figureFrame)")
        
      let point = CGPoint(x: borders.origin.x - imageFrame.origin.x, y: borders.origin.y - imageFrame.origin.y)
        
        NSLog("imageFrame: \(imageFrame)")
        
        NSLog("point: \(point)")
        
      let frame = CGRect(origin: point, size: borders.size)
        let x = frame.origin.x * self.imageView.image!.size.width / imageFrame.width
      let y = frame.origin.y * self.imageView.image!.size.height / imageFrame.height
      let width = frame.width * self.imageView.image!.size.width / imageFrame.width
      let height = frame.height * self.imageView.image!.size.height / imageFrame.height
        
        
        
      let croppedRect = CGRect(x: x, y: y, width: width, height: height)
        
        NSLog("croppedRect: \(croppedRect)")
        
      guard let imageRef = self.imageView.image!.cgImage?.cropping(to: croppedRect) else {
        return self.imageView.image!
      }
      
      let croppedImage = UIImage(cgImage: imageRef)
      return croppedImage

    }
    
    @IBAction func actionPan(_ sender: UIPanGestureRecognizer) {
      switch sender.state {
      case .began:
        //presenter?.userInteraction(true)
          self.panLastLocation = nil
          break
      case .changed:
        self.didDrag(to: sender.location(in: gridView))
      case .ended:
        //presenter?.userInteraction(false)
          self.panLastLocation = nil
          break
      default:
        return
      }
    }
    
    @IBAction func actionPinch(_ sender: UIPinchGestureRecognizer) {
      switch sender.state {
      case .began:
        guard sender.numberOfTouches >= 2 else { return }
        //presenter?.userInteraction(true)
          self.panLastLocation = nil
        //self.didPinchStarted()
        break
      case .changed:
        guard sender.numberOfTouches >= 2 else { return }
        self.didScale(with: sender.scale)
      case .ended, .cancelled:
        //presenter?.userInteraction(false)
          self.panLastLocation = nil
          break
      default:
        return
      }
    }
    
    @IBAction func actionDoubleTap(_ sender: UITapGestureRecognizer) {
        
        didDoubleTap()

    }
    
    
//    func show(title: String, version: String, date: String, changelog: String, superView: UIView, completion: ((Bool)->Void)?) {
//        
//        self.completionBlock = completion
//        
//        bgView = UIView()
//        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//        superView.addSubview(bgView)
//        
//        NSLayoutConstraint.activate([
//            bgView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
//            bgView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
//            bgView.topAnchor.constraint(equalTo: superView.topAnchor),
//            bgView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
//        ])
//        
//        self.isHidden = true
//        superView.addSubview(self)
//        NSLayoutConstraint.activate([
////            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 40),
////            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -40),
//            self.widthAnchor.constraint(equalToConstant: Tool.isIpad() ? 360:300),
//            self.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
//            self.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
//        ])
//        superView.layoutIfNeeded()
//        
//        self.titleLabel.text = title
//        //self.versionLabel.text = version
//        self.changelogTV.text = changelog
//        
//        let prefix = LS("Latest version: ")
//        let versionAttributedText = NSMutableAttributedString(string: prefix + version)
//        
//        var attrs1 : [NSAttributedString.Key : Any] = [
//            .font : UIFont.systemFont(ofSize: 15),
//            NSAttributedString.Key.foregroundColor : UIColor.black,
//        ]
//
//        var attrs2 : [NSAttributedString.Key : Any] = [
//            .font : UIFont.boldSystemFont(ofSize: 15),
//            NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
//        ]
//        
//        versionAttributedText.addAttributes(attrs1, range: NSRange(location: 0, length: prefix.count))
//        versionAttributedText.addAttributes(attrs2, range: NSRange(location: prefix.count, length: version.count))
//        
//        self.versionLabel.attributedText = versionAttributedText
//        self.dateLabel.text = LS("Publish date: ") + date
//        
//        // Create a NSMutableParagraphStyle
////        let paragraphStyle = NSMutableParagraphStyle()
////        paragraphStyle.lineSpacing = 2.0
////
////        // Create an NSAttributedString with the desired line spacing
////        let attributedText = NSMutableAttributedString(string: changelog)
////        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
////        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, attributedText.length))
//        
//        // Set the attributed text to the UITextView
//        //self.changelogTV.attributedText = attributedText
//        
//        //确保layer计算时，位置信息已经完成autolayout
//        setNeedsLayout()
//        layoutIfNeeded()
//        
//        
//        let fixedWidth = self.changelogTV.frame.size.width
//        let newSize = self.changelogTV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        if newSize.height > 150 {
//            changelogTVConstraintHeight.constant = 150
//        } else {
//            changelogTVConstraintHeight.constant = newSize.height
//        }
//        
//        let lineLayer = CALayer()
//        let lineHeight: CGFloat = 0.5
//        let lineColor = UIColor.lightGray.cgColor
//        lineLayer.frame = CGRect(x: 0, y:-10, width: self.stackView.bounds.width, height: lineHeight)
//        lineLayer.backgroundColor = lineColor
//        self.stackView.layer.addSublayer(lineLayer)
//        
//        let lineLayer2 = CALayer()
//        let lineWidth: CGFloat = 0.5
//
//        lineLayer2.frame = CGRect(x: self.cancelButton.frame.size.width, y:0, width: lineWidth, height: self.cancelButton.bounds.height)
//        lineLayer2.backgroundColor = lineColor
//        self.cancelButton.layer.addSublayer(lineLayer2)
//        
//        self.isHidden = false
//        
//        popupAnimation()
//    }

    
}
