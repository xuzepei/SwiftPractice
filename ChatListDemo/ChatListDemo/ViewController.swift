//
//  ViewController.swift
//  ChatListDemo
//
//  Created by xuzepei on 2023/6/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // 消息数据源
    var chatMessages: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 设置UI界面
        setupUI()
        
    }
    
    @IBAction func clickedAddBtn(_ sender: Any) {
        
        // 示例：生成10位长度的随机字符串
        let randomString = generateRandomString(length: 100)
        print(randomString) // 输出类似于：uLAjOFThCz
        
        chatMessages.append(randomString)
        
        // 假设 tableView 是要插入行的 UITableView 实例
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        // 插入新行
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        //tableView.reloadData()
        
        // 滚动到最后一条消息
        let lastIndex = IndexPath(row: chatMessages.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        
    }
    
    func generateRandomString(length: Int) -> String {
        
        // 生成 1 到 100 之间的随机数
        let randomNumber = Int(arc4random_uniform(UInt32(length))) + 1
        print(randomNumber)
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< randomNumber).map{ _ in letters.randomElement()! })
    }
    
    
    
    func setupUI() {
        // 创建UITableView实例
        //chatTableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        // 注册单元格类型
        //tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        
        tableView.register(ChatSentCell.self, forCellReuseIdentifier: "ChatSentCell")
        tableView.register(ChatReceivedCell.self, forCellReuseIdentifier: "ChatReceivedCell")
        
        tableView.separatorStyle = .none

    }
    
    func loadChatMessages() {
        // 模拟加载聊天记录数据
        chatMessages = ["Hello", "Hi", "How are you?", "I'm good, thanks! And you?", "I'm doing well, too.", "Glad to hear that."]
        
        // 刷新表格视图
        tableView.reloadData()
        
        // 滚动到最后一条消息
        let lastIndex = IndexPath(row: chatMessages.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var myCell: UITableViewCell!
        if indexPath.row % 2 == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSentCell", for: indexPath) as! ChatSentCell
            // 设置消息内容和类型
            cell.messageLabel.text = chatMessages[indexPath.row]
            cell.messageType = .sent
            
            myCell = cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceivedCell", for: indexPath) as! ChatReceivedCell
            // 设置消息内容和类型
            cell.messageLabel.text = chatMessages[indexPath.row]
            cell.messageType = .received
            
            myCell = cell
        }

        
        return myCell
    }
    
    
    
}

