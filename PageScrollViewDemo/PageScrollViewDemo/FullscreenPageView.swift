//
//  FullscreenPageView.swift
//  PandaCloud
//
//  Created by xuzepei on 2023/8/15.
//

import UIKit

class FullscreenPageView: UIView, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var pageControl: UIPageControl!

    var itemArray: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    //don't call loadNib() method here, if you added class name to view.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.layer.cornerRadius = 15
//        self.layer.masksToBounds = true
//
//        setup()
//
//    }
    
    
    func setup() {
        
        localize()
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
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
        

        self.setNeedsLayout()
    }
    
    func localize() {

        
    }
    
    @objc func pageControlTapped(sender: UIPageControl) {
      let pageWidth = scrollView.bounds.width
      let offset = sender.currentPage * Int(pageWidth)
      UIView.animate(withDuration: 0.33, animations: { [weak self] in
        self?.scrollView.contentOffset.x = CGFloat(offset)
      })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let pageWidth = scrollView.bounds.width
      let pageFraction = scrollView.contentOffset.x/pageWidth
      
      pageControl.currentPage = Int((round(pageFraction)))
    }
    
    func addArrangedSubviews(_ pageViews: [UIView])
    {
        for pageView in pageViews {
            stackView.addArrangedSubview(pageView)
            pageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        
        scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(stackView.arrangedSubviews.count), height: self.frame.height)
        pageControl.numberOfPages = stackView.arrangedSubviews.count
    }

    func updateContent(data: Dictionary<String, AnyObject>?) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
