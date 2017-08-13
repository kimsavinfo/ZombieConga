//
//  zombie.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 13/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation
import SpriteKit

class Zombie : SKSpriteNode {
    var zombieAnimation: SKAction
    
    init() {
        var textures:[SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        self.zombieAnimation = SKAction.animate(with: textures,
                                                timePerFrame: 0.1)
        
        let texture = SKTexture(imageNamed: "zombie1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    func startAnimation() {
        if self.action(forKey: "animation") == nil {
            self.run(
                SKAction.repeatForever(zombieAnimation),
                withKey: "animation")
        }
    }
    
    func stopAnimation() {
        self.removeAction(forKey: "animation")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
