//
//  BackgroundScroller.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 13/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation
import SpriteKit

func backgroundNode(position: Int) -> SKSpriteNode {
    let backgroundNode = SKSpriteNode()
    backgroundNode.anchorPoint = CGPoint.zero
    backgroundNode.name = "background"
    
    let background1 = SKSpriteNode(imageNamed: "background1")
    background1.anchorPoint = CGPoint.zero
    background1.position = CGPoint(x: 0, y: 0)
    backgroundNode.addChild(background1)
    
    let background2 = SKSpriteNode(imageNamed: "background2")
    background2.anchorPoint = CGPoint.zero
    background2.position =
        CGPoint(x: background1.size.width, y: 0)
    backgroundNode.addChild(background2)
    
    backgroundNode.size = CGSize(
        width: background1.size.width + background2.size.width,
        height: background1.size.height)
    
    backgroundNode.position = CGPoint(x: CGFloat(position)*backgroundNode.size.width, y: 0)
    backgroundNode.zPosition = -1

    return backgroundNode
}

func scrollBackground(backgroundNode: SKSpriteNode, cameraRect: CGRect) {
    if backgroundNode.position.x + backgroundNode.size.width < cameraRect.origin.x {
        
        backgroundNode.position = CGPoint(
            x: backgroundNode.position.x + backgroundNode.size.width*2,
            y: backgroundNode.position.y)
    }
}
