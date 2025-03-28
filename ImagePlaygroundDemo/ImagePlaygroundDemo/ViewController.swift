//
//  ViewController.swift
//  ImagePlaygroundDemo
//
//  Created by xuzepei on 2025/3/25.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        
        
    }
    
    @IBAction func clickedShowButton(_ sender: Any) {

        if #available(iOS 18.1, macOS 15.1, *) {
            let vc = ImagePGViewController()
            self.navigationController?.present(vc, animated: true)
            
            
        }
    }


}

