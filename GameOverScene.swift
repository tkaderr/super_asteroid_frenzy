//
//  GameOverScene.swift
//
//  Created by Tahim Kader on 5/31/17.
//  Copyright © 2017 Tahim Kader. All rights reserved.
//

import Foundation
import SpriteKit



class GameOverScene: SKScene {
    
    
    let restartLabel = SKLabelNode(fontNamed: "Edge Racer")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "back")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Edge Racer")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 170
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        
        
        gameOverLabel.run(scaleSequence)
        
        let scoreLabel = SKLabelNode(fontNamed: "Edge Racer")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        
        let defaults = UserDefaults()
        var highscore = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highscore {
            highscore = gameScore
            defaults.set(highscore, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "Edge Racer")
        highScoreLabel.text = "High Score: \(highscore)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 125
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            
            
        }
        
    }
    
    
}
