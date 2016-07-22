//
//  BitWatchViewController.swift
//  SwiftPractice
//
//  Created by xuzepei on 16/7/20.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import UIKit

class BitWatchViewController: UIViewController {
    
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var arrowImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var updatingTime: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "BitWatch"

        let timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "updateData", userInfo: nil, repeats: true)
        timer.fire()
        // Do any additional setup after loading the view.
        //updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateData() {
    
        let url = "https://api.bitcoinaverage.com/ticker/USD"
        HttpRequest.sharedInstance.request(.Get, url: url, token: nil) { (result, httpStatusCode, error) -> Void in
            
            if let jsonString = result as? String {
                
                if let dict = Tool.parseToDictionary(jsonString) {
                    
                    NSLog("%@",dict)
                    
                    if let lastPrice = dict["last"] as? NSNumber  {
                        
                        self.currentPrice.text = String(format:"$%.2f", lastPrice.floatValue)
                        
                        if let avgPrice = dict["24h_avg"] as? NSNumber {
                            let arrowImageName = lastPrice.floatValue > avgPrice.floatValue ? "UpArrow" : "DownArrow"
                            self.arrowImageViewWidthConstraint.constant = 32;
                            self.arrowImageView.image = UIImage(named: arrowImageName)
                        }
                        
                        self.lastUpdatedTime()
                        
                        self.saveBitcoinInfo(dict)
                    }
                }
            }
        }
    }
    
    func saveBitcoinInfo(info: AnyObject?) {
        NSUserDefaults.standardUserDefaults().setObject(info, forKey: "bitcoin_info")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func lastUpdatedTime() {
    
        let date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.updatingTime.text = "Last updated " + dateFormatter.stringFromDate(date)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
