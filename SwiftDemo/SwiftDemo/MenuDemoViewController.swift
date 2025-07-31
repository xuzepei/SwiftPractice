//
//  MenuDemoViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/7/24.
//

import UIKit

class MenuDemoViewController: UIViewController, UIContextMenuInteractionDelegate {

    @IBOutlet weak var myBtn: UIButton!
    @IBOutlet weak var contextMenuBtn: UIButton!
    
    var selectedItem: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //myBtn.showsMenuAsPrimaryAction = true
        
        //普通UIMenu
        updateMenu()
        
        // 添加 UIContextMenuInteraction
        //用于实现 长按（或右键）弹出上下文菜单，类似桌面系统的右键菜单。相比 UIMenu，它可以自定义预览内容，并且在长按时出现
        initContextMenu()
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
    
    func initContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        contextMenuBtn.addInteraction(interaction)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { action in
                print("Edit action triggered")
            }

            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                print("Delete action triggered")
            }

            return UIMenu(title: "", children: [editAction, deleteAction])
        }
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
