//
//  GameLogic.swift
//  ZombieConga
//
//  Created by Kim SAVAROCHE on 13/08/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation

class GameLogic {
    var lives = 5
    var gameOver = false
    
    init() {
        
    }
    
    func isGameOver(followersCount: Int) -> Bool {
        if(followersCount >= 15 && !gameOver) {
            gameOver = true
        }
        
        return gameOver
    }
    
    func isGameOver() -> Bool {
        return lives <= 0 && !gameOver
    }
    
    func hurt() {
        lives -= 1
    }
}
