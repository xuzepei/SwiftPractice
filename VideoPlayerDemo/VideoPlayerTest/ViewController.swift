//
//  ViewController.swift
//  VideoPlayerTest
//
//  Created by xuzepei on 2023/5/28.
//

import UIKit
import AVKit
import AVFoundation
import RimhTypingLetters
import Floaty
import Charts

class ViewController: UIViewController {
    
    var player: AVPlayer? = nil
    var playerLayer: AVPlayerLayer? = nil
    var container: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var playImageLayer: CALayer = CALayer()
    var videoPlayer: VideoPlayer? = nil
    
    
    @IBOutlet weak var typingLabel: UILabel!
    @IBOutlet weak var typingTextView: TypingLetterUITextView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    let players = ["Ozil", "Ramsey", "Laca", "Auba"]
    let goals = [30/100.0, 50/100.0, 10/100.0, 10/100.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
        
        setup()
    }
    
    func setupCircularProgressView() {
        // set view
        let circleProgressView = CircleProgressView(frame: CGRectMake(0, 0, 50, 50))
        // align to the center of the screen
        circleProgressView.center = view.center
        // call the animation with circularViewDuration
        circleProgressView.updateContent(progress: 2/3.0, progressColor: UIColor.yellow)
        // add this view to the view controller
        view.addSubview(circleProgressView)
    }
    
    func setup() {
        
        setupCircularProgressView()
        
        
        // Create a container view with a fixed size
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.container.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.container.heightAnchor.constraint(equalToConstant: 200).isActive = true
        //self.container.backgroundColor = .black
        
        // Add the container view to your view hierarchy
        view.addSubview(self.container)
        
        // Position the container view using Auto Layout constraints
        NSLayoutConstraint.activate([
            self.container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.container.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        

        
//        // Add a UITapGestureRecognizer to the playerLayer's view
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerLayerTapped))
//        self.container.addGestureRecognizer(tapGestureRecognizer)
        
        
        if let filepath = Bundle.main.path(forResource: "test", ofType: "mp4") {
            
            self.videoPlayer = VideoPlayer()
            self.videoPlayer?.setup(filepath: filepath, container: self.container)
            
            // Define the delay time in seconds
            let delay = 5.0

            // Get the default dispatch queue
            let queue = DispatchQueue.main

            // Define the block of code to be executed after the delay
            let codeToExecute = {
                print("Hello, after \(delay) seconds!")
                
                self.container .removeFromSuperview()
                self.videoPlayer = nil
            }

            // Schedule the block of code to be executed after the delay
            queue.asyncAfter(deadline: DispatchTime.now() + delay, execute: codeToExecute)
            
//            // Create an AVPlayerItem with the URL
//            let playerItem = AVPlayerItem(url: URL(fileURLWithPath: filepath))
//
//            // Initialize the AVPlayer with the AVPlayerItem
//            self.player = AVPlayer(playerItem: playerItem)
//
//            // Set up the AVPlayerLayer to display the video
//            self.playerLayer = AVPlayerLayer(player: self.player)
//            self.playerLayer?.frame = self.container.bounds
//            self.container.layer.addSublayer(self.playerLayer!)
//
//            // Set actionAtItemEnd to .none so that the video automatically restarts from the beginning
//            self.player?.actionAtItemEnd = .none
//
//
//            // Create a new CALayer for the image overlay
//            playImageLayer.contents = UIImage(named: "play")?.cgImage // Set the layer's contents to an image
//            playImageLayer.frame = CGRect(x: (self.playerLayer!.bounds.size.width - 40)/2.0, y: (self.playerLayer!.bounds.size.height - 40)/2.0, width: 40, height: 40) // Set the layer's frame
//
//            //playImageLayer.isHidden = true
//            // Add the image layer as a sublayer of the playerLayer
//            self.playerLayer?.addSublayer(playImageLayer)
//
//
//
//
//            // Add an observer for when the video ends
//            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
//
//            self.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.initial, .new], context: nil)
//
//
//            // Start playing the video
//            self.player?.play()
            
            
            // Extension function in UILabel is similar to TypingLetterUITextView's function, just only delimiter parameter is not exist.
//            self.typeLabel.typeText("A simple typing animation for UITextView and UILabel.", typingSpeedPerChar: 0.1, didResetContent = true, completeCallback:{
//                       // complete action after finished typing
//            })
            
            let message = "2023年6月4日，与前来“接班”的神舟十六号乘组共同工作生活5天后，神舟十五号乘组依依作别中国空间站，梦圆载誉而归。"
//            self.typingLabel.typeText(message, typingSpeedPerChar: 0.1) {
//                print("typingLabel: Done.")
//            }
            
            self.typingTextView.typeText(message, delimiter: nil, typingSpeedPerChar: 0.1, didResetContent: true) {
                print("typingTextView: Done.")
            }
            
            
            let floaty = Floaty()
            floaty.addItem("", icon: UIImage(systemName: "square.and.arrow.down")!, handler: { item in
                let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                floaty.close()
            })
            self.view.addSubview(floaty)
            
        }
    }
    
//    @objc func playerItemDidPlayToEndTime(noti: NSNotification) {
//        // Restart the video from the beginning
//        self.player?.seek(to: CMTime.zero)
//        self.player?.play()
//    }
//
//    // Handle the tap gesture
//    @objc func playerLayerTapped() {
//        // Handle the playerLayer click event
//        print("Player layer tapped!")
//
//        if self.player?.timeControlStatus == .playing {
//            self.player?.pause()
//            //playImageLayer.isHidden = true
//        } else if self.player?.timeControlStatus == .paused {
//            self.player?.play()
//        }
//    }
//
//    // Handle changes to the player's timeControlStatus property
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "timeControlStatus" {
//            if let statusNumber = change?[.newKey] as? NSNumber, let status = AVPlayer.TimeControlStatus(rawValue: statusNumber.intValue) {
//                switch status {
//                case .paused:
//                    // Handle paused status
//                    playImageLayer.isHidden = false
//                    break
//                case .playing:
//                    // Handle playing status
//                    playImageLayer.isHidden = true
//                    break
//                case .waitingToPlayAtSpecifiedRate:
//                    // Handle waiting status
//                    break
//                @unknown default:
//                    // Handle any future statuses that may be added to the enum
//                    break
//                }
//            }
//        }
//    }
    
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
//            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        // 2. Set ChartDataSet
        //let pieChartDataSet = PieChartDataSet(values: dataEntries, label: nil)
        let pieChartDataSet = PieChartDataSet(entries:dataEntries, label: "Pie Chart")
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChartDataSet.sliceSpace = 2 //部分板块之间的间距
        pieChartDataSet.selectionShift = 5 //点击之后错位效果
        
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        //pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.data = pieChartData
        //要在赋值data之后，再设置数据格式，否则%不能显示
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
//        let number = 0.75
//        let formatter1 = NumberFormatter()
//        formatter1.numberStyle = .percent
//        let formattedString = formatter1.string(from: NSNumber(value: number)) // "75%"
//        print("formattedString: \(formattedString)")
        // 4. Assign it to the chart’s data
        
        pieChartView.centerText = "Hello Pie Chart!"
        //pieChartView.usePercentValuesEnabled = true
        pieChartView.animate(yAxisDuration: 1.3, easingOption: .easeOutBack)
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
}

