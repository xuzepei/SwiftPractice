//
//  ViewController.swift
//  PageScrollViewDemo
//
//  Created by xuzepei on 2023/6/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    var itemArray: [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        itemArray.append(view1)
        itemArray.append(view2)
        
        pageControl.numberOfPages = itemArray.count
        pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .valueChanged)
        
//        let tempView = FullscreenPageView()
//        tempView.backgroundColor = .green
//        tempView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(tempView)
//
//        NSLayoutConstraint.activate([
//            tempView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            tempView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            tempView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            tempView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//        ])
//
//        tempView.addArrangedSubviews([view1,view2])
        
        let tempView2 = InfiniteScrollView()
        tempView2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tempView2)
        NSLayoutConstraint.activate([
            tempView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tempView2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tempView2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            tempView2.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        self.view.layoutIfNeeded()
        
        
        let view3 = UIView()
        view3.backgroundColor = .red
        
        let view4 = UIView()
        view4.backgroundColor = .green
        
        let view5 = UIView()
        view5.backgroundColor = .blue
        
        tempView2.addSubviews([view3,view4,view5])
        
        
        
    }

    @objc func pageControlTapped(sender: UIPageControl) {
      let pageWidth = scrollView.bounds.width
      let offset = sender.currentPage * Int(pageWidth)
      UIView.animate(withDuration: 0.33, animations: { [weak self] in
        self?.scrollView.contentOffset.x = CGFloat(offset)
      })
    }

}

extension ViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = scrollView.bounds.width
    let pageFraction = scrollView.contentOffset.x/pageWidth
    
    pageControl.currentPage = Int((round(pageFraction)))
  }
}

