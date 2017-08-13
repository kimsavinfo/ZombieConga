//
//  GameScene.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 12/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let gameLogic = GameLogic()
    let cameraNode = Camera()
    let backgroundMusicPlayer = BackgroundMusicPlayer()
    
    let zombie = Zombie()
    let livesLabel = LivesLabel()
    let catsLabel = CatsLabel()
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var lastTouchLocation: CGPoint?
    
    // MARK: init
    
    override init(size: CGSize) {
        super.init(size: size)
        cameraNode.setDimensions(sceneWidth: size.width, sceneHeight: size.height)
        backgroundMusicPlayer.play(filename: "backgroundMusic.mp3")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: didMove
    
    override func didMove(to view: SKView) {
        for i in 0...1 {
            let background = backgroundNode(position: i)
            addChild(background)
        }
        
        addChild(zombie)
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnEnemy()
                }, SKAction.wait(forDuration: 2.0)])))
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnCat()
                }, SKAction.wait(forDuration: 1.0)])))
        
        addChild(cameraNode)
        self.camera = cameraNode
        
        livesLabel.setPosition(playableRect: cameraNode.getPlayableRect())
        cameraNode.addChild(livesLabel)
        
        catsLabel.setPosition(playableRect: cameraNode.getPlayableRect())
        cameraNode.addChild(catsLabel)
    }
    
    func spawnEnemy() {
        let enemy = CatLady(cameraRect: cameraNode.getRect())
        addChild(enemy)
    }
    
    func spawnCat() {
        let cat = Cat(cameraRect: cameraNode.getRect())
        addChild(cat)
    }
    
    // MARK: update
    
    override func update(_ currentTime: TimeInterval) {
        updateTimer(currentTime)
        
        zombie.move(dt: dt)
        zombie.rotate(dt: dt)
        zombie.boundsCheck(cameraRect: cameraNode.getRect())
        
        moveTrain()
        moveCamera()
        
        livesLabel.updateText(count: self.gameLogic.lives)
        
        if(self.gameLogic.isGameOver()) {
            showGameOverScene(hasWon: false)
        }
    }
    
    func updateTimer(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
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
        catsLabel.updateText(count: trainCount)
        
        if(self.gameLogic.isGameOver(followersCount: trainCount)) {
            showGameOverScene(hasWon: true)
        }
    }
    
    func moveCamera() {
        cameraNode.move(dt: dt)
        
        let cameraRect = cameraNode.getRect()
        enumerateChildNodes(withName: "background") { node, _ in
            let background = node as! SKSpriteNode
            scrollBackground(backgroundNode: background, cameraRect: cameraRect)
        }
    }
    
    func showGameOverScene(hasWon: Bool) {
        backgroundMusicPlayer.stop()
        
        let gameOverScene = GameOverScene(size: size, won: hasWon)
        gameOverScene.scaleMode = self.scaleMode
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: reveal)
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
    
    // MARK: Zombie Hit
    
    func zombieHit(enemy: CatLady) {
        enemy.playCollideSound()
        zombie.blink()
        self.gameLogic.hurt()
        
        loseCats()
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
    
    // MARK: didEvaluateActions
    
    func checkCollisions() {
        enumerateChildNodes(withName: "cat") { node, _ in
            let cat = node as! Cat
            if cat.frame.intersects(self.zombie.frame) {
                cat.addToTrain()
            }
        }
        
        if !zombie.invincible {
            enumerateChildNodes(withName: "enemy") { node, _ in
                let enemy = node as! CatLady
                if node.frame.insetBy(dx: 10, dy: 10).intersects(
                    self.zombie.frame) {
                    self.zombieHit(enemy: enemy)
                }
            }
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
}
