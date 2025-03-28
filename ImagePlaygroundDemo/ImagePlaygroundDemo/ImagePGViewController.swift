//
//  ImagePGViewController.swift
//  ImagePlaygroundDemo
//
//  Created by xuzepei on 2025/3/25.
//

import UIKit
import ImagePlayground

// The os availability attributes
@available(iOS 18.1,macOS 15.1, *)

class ImagePGViewController: UIViewController, ImagePlaygroundViewController.Delegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var generateBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    func setup() {
        if ImagePlaygroundViewController.isAvailable {

        } else {
            print("#### Can not support ImagePlaygroundViewController")
        }
    }
    
    @IBAction func clickedGenerateBtn(_ sender: Any) {
        
        print("#### clickedGenerateBtn")
        
        openImagePlayground(with: "Fish")
    }
    
    @IBAction
    private func openImagePlayground(with story: String) {
        
        // 1. Initialize the playground
        let playground = ImagePlaygroundViewController()
        
        // 2. Delegation
        playground.delegate = self
        
        // 2. Set extracted concepts from the story in the playground
        playground.concepts = [.extracted(from: story, title: nil)]
        
        // 3. Present the ImagePlaygroundViewController
        present(playground, animated: true, completion: nil)
        
    }
    
    func imagePlaygroundViewController(_ imagePlaygroundViewController: ImagePlaygroundViewController, didCreateImageAt imageURL: URL) {
        
        if let image = UIImage(contentsOfFile: imageURL.path) {
            imageView.image = image
        } else {
            print("Error loading image from URL: \(imageURL)")
        }
        
        // 3. Dismiss the sheet
        dismiss(animated: true, completion: nil)
        
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
