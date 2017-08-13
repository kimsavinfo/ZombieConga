//
//  Cat.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 13/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation
import SpriteKit

class Cat : SKSpriteNode {
    let collisionSound: SKAction = SKAction.playSoundFileNamed(
        "hitCat.wav", waitForCompletion: false)
    
    init(cameraRect: CGRect) {
        let texture = SKTexture(imageNamed: "cat")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.name = "cat"
        self.position = CGPoint(
            x: CGFloat.random(min: cameraRect.minX,
                              max: cameraRect.maxX),
            y: CGFloat.random(min: cameraRect.minY,
                              max: cameraRect.maxY))
        self.zPosition = 50
        self.setScale(0)
        
        runActions()
    }
    
    func runActions() {
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        
        self.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence(
            [scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        
        let removeFromParent = SKAction.removeFromParent()
        
        let actions = [appear, groupWait, disappear, removeFromParent]
        self.run(SKAction.sequence(actions))
    }
    
    // MARK: Collision
    
    func addToTrain() {
        self.name = "train"
        self.removeAllActions()
        self.setScale(1.0)
        self.zRotation = 0
        
        let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
        self.run(turnGreen)
        
        self.run(collisionSound)
    }
        
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
