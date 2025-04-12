//
//  ImageViewerViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/4/12.
//

import UIKit

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {
    
    var images: [UIImage]!
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    private var zoomScrollViews: [UIScrollView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Image Viewer"
        
        setup()
    }
    
    func setup() {
        
        self.view.backgroundColor = .blue
        
        self.images = [UIImage(named: "photo")!, UIImage(named: "photo2")!, UIImage(named: "tes")!]
        
        setupScrollView()
        setupPageControl()
        
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
            zoomView.minimumZoomScale = 0.5
            zoomView.maximumZoomScale = 3.0
            zoomView.showsVerticalScrollIndicator = false
            zoomView.showsHorizontalScrollIndicator = false
            zoomView.tag = index
            zoomScrollViews.append(zoomView)
            
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            
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
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
