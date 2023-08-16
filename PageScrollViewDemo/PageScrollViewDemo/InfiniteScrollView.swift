//
//  InfiniteScrollView.swift
//  PageScrollViewDemo
//
//  Created by xuzepei on 2023/8/15.
//

import UIKit

class InfiniteScrollView: UIView, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var stackView: UIStackView!
    
    var pageWidth: CGFloat = 0
    var currentPage = 0
    
    var isMoving = false

    var itemArray: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = true
        setup()
    }

    //don't call loadNib() method here, if you added class name to view.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    func setup() {
        
        localize()
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false //避免拖拽超出边界
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)
        

        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        //pageControl.backgroundColor = .red
        self.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .valueChanged)
        
    
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            pageControl.widthAnchor.constraint(equalToConstant: 120),
            pageControl.heightAnchor.constraint(equalToConstant: 26),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -26),
        ])
        
        self.layoutIfNeeded()

    }
    
    func localize() {

        
    }
    
    @objc func pageControlTapped(sender: UIPageControl) {
      let offset = sender.currentPage * Int(pageWidth)
      UIView.animate(withDuration: 0.33, animations: { [weak self] in
        self?.scrollView.contentOffset.x = CGFloat(offset)
      })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        if self.isMoving {
//            return
//        }
        
        let index = self.scrollView.contentOffset.x / pageWidth
        if index > 1 {
            NSLog("forwards")
            //self.isMoving = true
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.pageWidth*2, y: 0)
                }, completion: { (finished : Bool) in
                    //self.isMoving = false
                    self.scrollView.contentOffset = CGPoint(x: self.pageWidth, y: 0)
                    self.rearrageSubviews(orientation: 1)
                    
                    if self.currentPage == self.stackView.arrangedSubviews.count - 1 {
                        self.currentPage = 0
                    } else {
                        self.currentPage += 1;
                    }
                    
                    self.pageControl.currentPage = self.currentPage
            })

        } else if index < 1 {

            NSLog("backwards")
            
            //self.isMoving = true
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                }, completion: { (finished: Bool) in
                    //self.isMoving = false
                    self.scrollView.contentOffset = CGPoint(x: self.pageWidth, y: 0)
                    self.rearrageSubviews(orientation: -1)
                    
                    if self.currentPage == 0 {
                        self.currentPage = self.stackView.arrangedSubviews.count - 1
                    } else {
                        self.currentPage -= 1;
                    }
                    
                    self.pageControl.currentPage = self.currentPage
            })

        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if pageWidth <= 0 {
//            return
//        }
//
//        let pageFraction = scrollView.contentOffset.x/pageWidth
//        pageControl.currentPage = Int((round(pageFraction)))
    }
    
    func rearrageSubviews(orientation: Int) {
    
        for subView in self.itemArray {
            subView.removeConstraints(self.constraints)
            subView.removeFromSuperview()
        }
        
        if orientation == 1 {
            let firstElement = self.itemArray.removeFirst()
            self.itemArray.append(firstElement)
        } else if orientation == -1 {
            let lastElement = self.itemArray.removeLast()
            self.itemArray.insert(lastElement, at: 0)
        }
        
        for (_, pageView) in self.itemArray.enumerated() {
            stackView.addArrangedSubview(pageView)
            pageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        
        self.layoutIfNeeded()
     }
    
    func addSubviews(_ pageViews: [UIView])
    {
        for subView in self.itemArray {
            subView.removeConstraints(self.constraints)
            subView.removeFromSuperview()
        }
        itemArray.removeAll()
        
        itemArray += pageViews
        rearrageSubviews(orientation: 0)
        
        pageControl.numberOfPages = stackView.arrangedSubviews.count
        pageControl.currentPage = self.currentPage
        
        pageWidth = self.frame.width
        NSLog("pageWidth: \(pageWidth)")
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(stackView.arrangedSubviews.count), height: self.frame.height)
        scrollView.contentOffset = CGPoint(x: pageWidth, y: 0)
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
