//
//  CatLady.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 13/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation
import SpriteKit

class CatLady : SKSpriteNode {
    init(cameraRect: CGRect) {
        let texture = SKTexture(imageNamed: "enemy")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.position = CGPoint(
            x: cameraRect.maxX + self.size.width/2,
            y: CGFloat.random(
                min: cameraRect.minY + self.size.height/2,
                max: cameraRect.maxY - self.size.height/2))
        self.zPosition = 50
        self.name = "enemy"
        
        animate(cameraRect: cameraRect)
    }
    
    func animate(cameraRect: CGRect) {
        let actionMove =
            SKAction.moveBy(x: -(cameraRect.width + self.size.width), y: 0, duration: 2.0)
        
        let actionRemove = SKAction.removeFromParent()
        
        self.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
