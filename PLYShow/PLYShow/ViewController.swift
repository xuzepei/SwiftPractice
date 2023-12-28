//
//  ViewController.swift
//  PLYShow
//
//  Created by xuzepei on 2023/10/20.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let scene = SCNScene()
        let modelNode = SCNNode()
        
        let url = Bundle.main.url(forResource: "myModel", withExtension: "ply")!
        let asset = MDLAsset(url: url)
        let mesh = asset.object(at: 0) as! MDLMesh
        let geometry = SCNGeometry(mdlMesh: mesh)
        
        modelNode.geometry = geometry
        scene.rootNode.addChildNode(modelNode)
        
    }


}

