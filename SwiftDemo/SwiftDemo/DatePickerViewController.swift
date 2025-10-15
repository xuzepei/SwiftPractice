//
//  DatePickerViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/9/18.
//

import UIKit

class DatePickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    
    func setup() {
        let button = ProminentButton(type: .system)
        button.setTitle("选择日期", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        button.frame = CGRect(x: 50, y: 200, width: 120, height: 44)
        view.addSubview(button)
        
        
        let slider = UISlider(frame: CGRect(x: 50, y: 300, width: 250, height: 40))
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        
        // 只修改滑块颜色
        slider.thumbTintColor = UIColor(patternImage: UIImage(named: "makeup")!)
        
        view.addSubview(slider)
        
        
        // 系统样式 UIButton，iOS26 上会自动带 Liquid Glass 效果
                let glassButton = UIButton(type: .system)
                glassButton.setTitle("Liquid Glass Button", for: .normal)
                
                // 使用系统推荐的样式
                if #available(iOS 26.0, *) {
                    glassButton.configuration = .filled()   // 或 .tinted(), .bordered()
                    glassButton.configuration?.baseBackgroundColor = .systemFill
                }

                glassButton.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(glassButton)
                
                NSLayoutConstraint.activate([
                    glassButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    glassButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    glassButton.widthAnchor.constraint(equalToConstant: 200),
                    glassButton.heightAnchor.constraint(equalToConstant: 50)
                ])
    }
    
    @objc func showDatePicker2() {
            // 1️⃣ 创建自定义控制器作为弹框
            let datePickerVC = UIViewController()
            datePickerVC.preferredContentSize = CGSize(width: 360, height: 320)
            
            // 2️⃣ 创建 UIDatePicker
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 340, height: 300))
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline  // iOS16 新样式
            datePicker.minimumDate = Date() // 可选：设置最小日期
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) // 可选：最大日期
            datePickerVC.view.addSubview(datePicker)
            
            // 3️⃣ 创建 UIAlertController
            let alert = UIAlertController(title: "选择日期", message: nil, preferredStyle: .alert)
            alert.setValue(datePickerVC, forKey: "contentViewController") // iOS16 支持
            
            // 4️⃣ 添加操作
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                let selectedDate = datePicker.date
                print("选中的日期：\(selectedDate)")
                // 在这里处理选中的日期
            }))
            
            // 5️⃣ 弹出
            self.present(alert, animated: true)
        }
    
    @objc func showDatePickerCustom() {
        let pickerVC = UIViewController()
        pickerVC.view.backgroundColor = .white
        pickerVC.modalPresentationStyle = .formSheet
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.preferredContentSize = CGSize(width: view.frame.width, height: 350)
        
        let datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 0, y: 0, width: pickerVC.preferredContentSize.width, height: 300)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        pickerVC.view.addSubview(datePicker)
        
        // 添加确定按钮
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.frame = CGRect(x: 0, y: 310, width: pickerVC.preferredContentSize.width, height: 40)
        confirmButton.addTarget(self, action: #selector(confirmDate(_:)), for: .touchUpInside)
        pickerVC.view.addSubview(confirmButton)
        
        self.present(pickerVC, animated: true)
    }

    @objc func confirmDate(_ sender: UIButton) {
        // 通过 sender.superview 找到 datePicker 或用闭包回调
        self.dismiss(animated: true)
    }


    @objc func showDatePicker() {
        var datePicker: DatePicker = DatePicker.instance()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.show(title: LS("Select Date"), superView: self.view) { [weak self] (b) in
            
            guard let self = self else {
                return
            }
        }
    }

}
