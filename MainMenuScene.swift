//
//  MainMenuScene.swift
//
//  Created by Tahim Kader on 5/31/17.
//  Copyright © 2017 Tahim Kader. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    let startlabel = SKLabelNode(fontNamed: "Edge Racer")
    let jump = true
    
   
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "back")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameName0 = SKLabelNode(fontNamed: "Edge Racer")
        gameName0.text = "Super"
        gameName0.fontSize = 220
        gameName0.fontColor = SKColor.white
        gameName0.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8)
        gameName0.zPosition = 1
        self.addChild(gameName0)
        
        let gameName1 = SKLabelNode(fontNamed: "Edge Racer")
        gameName1.text = "Asteroid"
        gameName1.fontSize = 220
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "Edge Racer")
        gameName2.text = "Frenzy!"
        gameName2.fontSize = 220
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        startlabel.text = "Start Game"
        startlabel.fontSize = 125
        startlabel.fontColor = SKColor.white
        startlabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        startlabel.zPosition = 1
        self.addChild(startlabel)
        
        let player = SKSpriteNode(imageNamed: "shuttle2")
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])

        gameName0.run(scaleSequence)
        gameName1.run(scaleSequence)
        gameName2.run(scaleSequence)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if startlabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
    
}
