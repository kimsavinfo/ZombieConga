//
//  Camera.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 13/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation
import SpriteKit

class Camera : SKCameraNode {
    let movePointsPerSec: CGFloat = 200.0
    var sceneWidth:CGFloat = 0
    var sceneHeight:CGFloat = 0.0
    var playableRect:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    func setDimensions(sceneWidth: CGFloat, sceneHeight:CGFloat) {
        self.sceneWidth = sceneWidth
        self.sceneHeight = sceneHeight
        
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = self.sceneWidth / maxAspectRatio
        let playableMargin = (self.sceneHeight - playableHeight) / 2.0
        
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: self.sceneWidth,
                              height: playableHeight)
        
        self.position = CGPoint(x: self.sceneWidth/2, y: self.sceneHeight/2)
    }
    
    func move(dt: TimeInterval) {
        let backgroundVelocity = CGPoint(x: movePointsPerSec, y: 0)
        let amountToMove = backgroundVelocity * CGFloat(dt)
        self.position += amountToMove
    }
    
    func getRect() -> CGRect{
        let x = self.position.x - self.sceneWidth/2
                + (self.sceneWidth - playableRect.width)/2
        let y = self.position.y - self.sceneHeight/2
                + (self.sceneHeight - playableRect.height)/2
        
        return CGRect(
            x: x,
            y: y,
            width: playableRect.width,
            height: playableRect.height)
    }
    
    func getPlayableRect() -> CGRect {
        return playableRect
    }
}
