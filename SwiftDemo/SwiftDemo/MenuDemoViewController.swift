//
//  MenuDemoViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/7/24.
//

import UIKit

class MenuDemoViewController: UIViewController {

    @IBOutlet weak var myBtn: UIButton!
    
    var selectedItem: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //myBtn.showsMenuAsPrimaryAction = true
        
        updateMenu()
    }
    
    func updateMenu() {
        var items = ["Item 1","Item 2","Item 3"]
        var actions:[UIAction] = [UIAction]()
        
        for (index, name) in items.enumerated() {
            
            var state:UIMenuElement.State = .off
            if selectedItem.lowercased() == name.lowercased() {
                state = .on
            }

            let action = UIAction(title: name.capitalized, image: nil, identifier: UIAction.Identifier(String(index)), attributes: [], state: state) { action in
                
                print("clicked \(action.title) button.")
                
                self.selectedItem = action.title
                
                self.updateMenu()
            }
            
            actions.append(action)
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: actions)

        myBtn.showsMenuAsPrimaryAction = true
        self.myBtn.menu = menu
    }
    
    @IBAction func clickedBtn(_ sender: Any) {
        print("#### clickedBtn")
        

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
