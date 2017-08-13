//
//  GameScene.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 12/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

/*
 TODO :
 - rename Zombie into Player
 - rename Cat into Follower
 - rename CatLady into Enemy
 */

import SpriteKit

class GameScene: SKScene {
    let cameraNode = Camera()
    let backgroundMusicPlayer = BackgroundMusicPlayer()
    
    let zombie = Zombie()
    let livesLabel = LivesLabel()
    let catsLabel = CatsLabel()
    
    var invincible = false
    var lives = 5
    var gameOver = false
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var lastTouchLocation: CGPoint?
    
    override init(size: CGSize) {
        cameraNode.setDimensions(sceneWidth: size.width, sceneHeight: size.height)
        
        super.init(size: size)
        
        backgroundMusicPlayer.play(filename: "backgroundMusic.mp3")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Update
    
    override func didMove(to view: SKView) {
        for i in 0...1 {
            let background = Background(position: i)
            addChild(background.getNode())
        }
        
        addChild(zombie)
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnEnemy()
                },
                               SKAction.wait(forDuration: 2.0)])))
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnCat()
                },
                               SKAction.wait(forDuration: 1.0)])))
        
        addChild(cameraNode)
        self.camera = cameraNode
        
        livesLabel.setPosition(playableRect: cameraNode.getPlayableRect())
        cameraNode.addChild(livesLabel)
        
        catsLabel.setPosition(playableRect: cameraNode.getPlayableRect())
        cameraNode.addChild(catsLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        zombie.move(dt: dt)
        zombie.rotate(dt: dt)
        zombie.boundsCheck(cameraRect: cameraNode.getRect())
        
        moveTrain()
        moveCamera()
        livesLabel.updateText(count: self.lives)
        
        
        if lives <= 0 && !gameOver {
            gameOver = true
            backgroundMusicPlayer.stop()
            
            // 1
            let gameOverScene = GameOverScene(size: size, won: false)
            gameOverScene.scaleMode = scaleMode
            // 2
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            // 3
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
    }
    
    // MARK: Touch event
    
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        
        zombie.moveToward(location: touchLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    // MARK: Spawn
    
    func spawnEnemy() {
        let enemy = CatLady(cameraRect: cameraNode.getRect())
        addChild(enemy)
    }
    
    func spawnCat() {
        let cat = Cat(cameraRect: cameraNode.getRect())
        addChild(cat)
    }
    
    // MARK: Zombie Hit
    
    func zombieHit(enemy: CatLady) {
        invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() { [weak self] in
            self?.zombie.isHidden = false
            self?.invincible = false
        }
        zombie.run(SKAction.sequence([blinkAction, setHidden]))
        
        enemy.playCollideSound()
        
        loseCats()
        lives -= 1
    }
    
    func checkCollisions() {
        enumerateChildNodes(withName: "cat") { node, _ in
            let cat = node as! Cat
            if cat.frame.intersects(self.zombie.frame) {
                cat.addToTrain()
            }
        }
        
        if invincible {
            return
        }
        
        enumerateChildNodes(withName: "enemy") { node, _ in
            let enemy = node as! CatLady
            if node.frame.insetBy(dx: 20, dy: 20).intersects(
                self.zombie.frame) {
                self.zombieHit(enemy: enemy)
            }
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    func moveTrain() {
        var trainCount = 0
        var targetPosition = zombie.position
        
        enumerateChildNodes(withName: "train") { node, stop in
            trainCount += 1
            
            let cat = node as! Cat
            if !cat.hasActions() {
                cat.moveAsTrain(targetPosition: targetPosition)
            }
            
            targetPosition = cat.position
        }
        
        if trainCount >= 15 && !gameOver {
            gameOver = true
            backgroundMusicPlayer.stop()
            
            // 1
            let gameOverScene = GameOverScene(size: size, won: true)
            gameOverScene.scaleMode = scaleMode
            // 2
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            // 3
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
        catsLabel.updateText(count: trainCount)
    }
    
    func loseCats() {
        var loseCount = 0
        
        enumerateChildNodes(withName: "train") { node, stop in
            let cat = node as! Cat
            cat.removeFromTrain()
            
            loseCount += 1
            if loseCount >= 2 {
                stop[0] = true
            }
        }
    }
    
    func moveCamera() {
        cameraNode.move(dt: dt)
        
        let cameraRect = cameraNode.getRect()
        
        enumerateChildNodes(withName: "background") { node, _ in
            let background = node as! SKSpriteNode
            if background.position.x + background.size.width <
                cameraRect.origin.x {
                background.position = CGPoint(
                    x: background.position.x + background.size.width*2,
                    y: background.position.y)
            }
        }
        
    }
}
