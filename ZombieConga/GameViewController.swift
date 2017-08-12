//
//  GameViewController.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 12/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScene()
    }
    
    func initScene() {
        let scene = GameScene(size: CGSize(width: 2048, height: 1536))
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
