//
//  LivesLabel.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 13/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation
import SpriteKit

class LivesLabel : SKLabelNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        self.fontName = "Glimstick"
        self.text = "Lives: X"
        self.fontColor = SKColor.black
        self.fontSize = 100
        self.zPosition = 150
        self.horizontalAlignmentMode = .left
        self.verticalAlignmentMode = .bottom
    }
    
    func setPosition(playableRect: CGRect) {
        self.position = CGPoint(
            x: -playableRect.size.width/2 + CGFloat(20),
            y: -playableRect.size.height/2 + CGFloat(20))
    }
    
    func updateLivesText(lives: Int) {
        self.text = "Lives: \(lives)"
    }
}
