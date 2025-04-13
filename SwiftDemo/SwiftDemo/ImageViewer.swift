//
//  ImageViewer.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/4/12.
//

import UIKit

class ImageViewer: UIView, UIScrollViewDelegate {
    
    var images: [UIImage] = []
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var zoomScrollViews: [UIScrollView] = []
    let closeButton = UIButton(type: .custom)
    let saveButton = UIButton(type: .custom)
    
    static func show(with images: [UIImage], from parent: UIView?) {
        
        let viewer = ImageViewer()
        viewer.translatesAutoresizingMaskIntoConstraints = false
        viewer.alpha = 0
        viewer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        viewer.images = images
        
        if let parentView = parent {
            parentView.addSubview(viewer)
            
            NSLayoutConstraint.activate([
                viewer.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
                viewer.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor),
                viewer.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
                viewer.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            guard let window = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first(where: { $0.isKeyWindow }) else {
                    print("No key window")
                    return
            }
            
            window.addSubview(viewer)
            NSLayoutConstraint.activate([
                viewer.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                viewer.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                viewer.topAnchor.constraint(equalTo: window.topAnchor),
                viewer.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            ])
        }

        viewer.setup()

        // Animate appearance
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
            viewer.alpha = 1
            viewer.transform = .identity
        }, completion: nil)
        
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        self.backgroundColor = .black.withAlphaComponent(0.8)
        setupScrollView()
        setupPageControl()
        setupCloseButton()
        setupSaveButton()
    }
    
    // MARK: - Setup ScrollView
    private func setupScrollView() {
        scrollView.subviews.forEach { $0.removeFromSuperview() } // 清除旧内容
        zoomScrollViews.removeAll()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        
        var previous: UIView? = nil
        for (index, image) in images.enumerated() {
            let zoomView = UIScrollView()
            zoomView.delegate = self
            zoomView.translatesAutoresizingMaskIntoConstraints = false
            zoomView.minimumZoomScale = 1.0
            zoomView.maximumZoomScale = 3.0
            zoomView.showsVerticalScrollIndicator = false
            zoomView.showsHorizontalScrollIndicator = false
            zoomView.tag = index
            zoomScrollViews.append(zoomView)
            
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTap.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(doubleTap)
            
            zoomView.addSubview(imageView)
            contentView.addSubview(zoomView)
            
            NSLayoutConstraint.activate([
                zoomView.topAnchor.constraint(equalTo: contentView.topAnchor),
                zoomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                zoomView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
            if let prev = previous {
                zoomView.leadingAnchor.constraint(equalTo: prev.trailingAnchor).isActive = true
            } else {
                zoomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            }
            previous = zoomView
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: zoomView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: zoomView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: zoomView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: zoomView.heightAnchor),
            ])
        }
        
        if let last = previous {
            last.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
    }
    
    // MARK: - Setup Page Control
    private func setupPageControl() {
        pageControl.removeFromSuperview()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        self.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close_btn"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        self.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func closeTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        //saveButton.backgroundColor = .systemGreen
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = true
        
        saveButton.setBackgroundImage(UIImage.image(withColor: .black), for: .normal)
        saveButton.setBackgroundImage(UIImage.image(withColor: .black.withAlphaComponent(0.6)), for: .highlighted)
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        self.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "save_btn1")?.withTintColor(.white)
        saveButton.addSubview(iv)
        
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 30),
            iv.heightAnchor.constraint(equalToConstant: 30),
            iv.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            iv.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
        ])

    }
    
    @objc private func saveTapped() {
//        if let image = self.image {
//            Tool.saveImageToPhotoLibrary(image: image, rootVC: nil)
//        }
    }
    
    // MARK: - Zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        guard width > 0 else { return }
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetOtherZoomScales()
    }
    
    private func resetOtherZoomScales() {
        let currentPage = pageControl.currentPage
        for (index, zoomScrollView) in zoomScrollViews.enumerated() {
            if index != currentPage {
                zoomScrollView.setZoomScale(1.0, animated: false)
            }
        }
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view,
              let zoomView = imageView.superview as? UIScrollView else { return }
        
        let newZoomScale: CGFloat = zoomView.zoomScale == 1.0 ? 2.0 : 1.0
        zoomView.setZoomScale(newZoomScale, animated: true)
    }
}

