//
//  InterfaceController.swift
//  BitWatch Extension
//
//  Created by xuzepei on 16/7/21.
//  Copyright © 2016年 xuzepei. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var currentPriceLabel: WKInterfaceLabel!
    @IBOutlet var arrowImage: WKInterfaceImage!
    @IBOutlet var updatedTime: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        updateData()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func clickedRefreshButton() {
        
        updateData()
    }
    
    
    func parseToDictionary(jsonString:String?) -> [String:AnyObject]? {
        
        if let data = jsonString?.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject]
            } catch let error as NSError{
                print(error)
            }
        }
        
        return nil
    }
    
    func updateData() {
        
        let url = "https://api.bitcoinaverage.com/ticker/USD"
        
        self.arrowImage.setWidth(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                
                if let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                
                    if let dict = self.parseToDictionary(jsonString) {
                        
                        NSLog("%@",dict)
                        
                        if let lastPrice = dict["last"] as? NSNumber  {
                            
                            self.currentPriceLabel .setText(String(format:"$%.2f", lastPrice.floatValue))
                            
                            if let avgPrice = dict["24h_avg"] as? NSNumber {
                                let arrowImageName = lastPrice.floatValue > avgPrice.floatValue ? "UpArrow" : "DownArrow"
                                self.arrowImage.setImageNamed(arrowImageName)
                                self.arrowImage.setWidth(16);
                            }
                            
                            self.lastUpdatedTime()
                            
                            //self.saveBitcoinInfo(dict)
                        }
                    }
                }
                
            }
        }
    }
    
    func lastUpdatedTime() {
        
        let date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        updatedTime.setText("Last updated " + dateFormatter.stringFromDate(date))
    }

}
