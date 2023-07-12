//
//  AutoLayoutViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2023/7/11.
//

import UIKit

class AutoLayoutViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        view3.heightAnchor.constraint(equalTo: view3.widthAnchor, multiplier: 1.0/2.0).isActive = true
        
        imageView.image = UIImage(systemName: "tray.full.fill")
        //imageView.isHidden = true
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
