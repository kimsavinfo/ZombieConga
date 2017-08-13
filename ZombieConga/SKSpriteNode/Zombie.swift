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
    var animation: SKAction
    var velocity = CGPoint.zero
    let movePointsPerSec: CGFloat = 680.0
    let rotateRadiansPerSec:CGFloat = 4.0 * π
    var invincible = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        var textures:[SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        self.animation = SKAction.animate(with: textures,
                                                timePerFrame: 0.1)
        
        let texture = SKTexture(imageNamed: "zombie1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.position = CGPoint(x: 400, y: 400)
        self.zPosition = 100
    }
    
    // MARK: Move to
    
    func move(dt: TimeInterval) {
        let amountToMove = CGPoint(x: self.velocity.x * CGFloat(dt),
                                   y: self.velocity.y * CGFloat(dt))
        
        self.position += amountToMove
    }
    
    func rotate(dt: TimeInterval) {
        let shortest = shortestAngleBetween(angle1: self.zRotation, angle2: self.velocity.angle)
        let amountToRotate = min(self.rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        
        self.zRotation += shortest.sign() * amountToRotate
    }
    
    func moveToward(location: CGPoint) {
        self.startAnimation()
        
        let offset = location - self.position
        let direction = offset.normalized()
        self.velocity = direction * movePointsPerSec
    }
    
    // MARK: Bounds check
    
    func boundsCheck(cameraRect: CGRect) {
        let bottomLeft = CGPoint(x: cameraRect.minX, y: cameraRect.minY)
        let topRight = CGPoint(x: cameraRect.maxX, y: cameraRect.maxY)
        
        if self.position.x <= bottomLeft.x {
            self.position.x = bottomLeft.x
            self.velocity.x = abs(velocity.x)
        }
        if self.position.x >= topRight.x {
            self.position.x = topRight.x
            self.velocity.x = -self.velocity.x
        }
        if self.position.y <= bottomLeft.y {
            self.position.y = bottomLeft.y
            self.velocity.y = -self.velocity.y
        }
        if self.position.y >= topRight.y {
            self.position.y = topRight.y
            self.velocity.y = -self.velocity.y
        }
    }
    
    // MARK: Animation
    
    func startAnimation() {
        if self.action(forKey: "animation") == nil {
            self.run(
                SKAction.repeatForever(animation),
                withKey: "animation")
        }
    }
    
    func stopAnimation() {
        self.removeAction(forKey: "animation")
    }
    
    func blink() {
        self.invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        
        let setHidden = SKAction.run() { [weak self] in
            self?.isHidden = false
            self?.invincible = false
        }
        
        run(SKAction.sequence([blinkAction, setHidden]))
    }
}
