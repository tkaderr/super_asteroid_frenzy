//
//  GameScene.swift
//
//  Created by Tahim Kader on 5/31/17.
//  Copyright © 2017 Tahim Kader. All rights reserved.
//

import SpriteKit
import GameplayKit
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "shuttle2")
    
    let bulletSound = SKAction.playSoundFileNamed("laser.mp3", waitForCompletion: false)
    
    let explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    
    let gameArea: CGRect
    
    let scorelabel = SKLabelNode(fontNamed: "Edge Racer")
    
    var levelNumber = 0
    
    let tapToStartLabel = SKLabelNode(fontNamed: "Edge Racer")
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 1500.0
    
    enum gameState {
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame
    
    struct PhysicsCategories {
        
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1
        static let Bullet : UInt32 = 0b10
        static let Enemy : UInt32 = 0b100
    }
    
    override init(size:CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size:size)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode //same scaling as game scene
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    override func didMove(to view: SKView) {
        gameScore = 0 //have to reset the score here even after you set the gamescore globally
        
        var EnemyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("spawnEnemy"), userInfo: nil, repeats: true)
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 {
            
            let background = SKSpriteNode(imageNamed: "back")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Backgrounds"
            self.addChild(background)
            
        }
        
        player.setScale(2)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scorelabel.text  = "Score: 0"
        scorelabel.fontSize = 70
        scorelabel.fontColor = SKColor.white
        scorelabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scorelabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height + scorelabel.frame.size.height)
        scorelabel.zPosition = 100
        self.addChild(scorelabel)
        
 
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scorelabel.run(moveOnToScreenAction)
        
        tapToStartLabel.text = "Tap To Start!"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        
        
        tapToStartLabel.run(scaleSequence)
        
    }
    
    
    
    func startGame() {
        
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOnToScreenAction, startLevelAction])
        player.run(startGameSequence)
        
    }
    
    func GameOver() {
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            
            if body1.node != nil {
                spawnExplosion(spawnPos: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPos: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            GameOver()
        }
        
       // if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height{
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy{
            if body2.node != nil {
                spawnExplosion(spawnPos: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            addScore()
        }
    }
    
    func spawnExplosion(spawnPos: CGPoint) {
        
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")
  
        explosion?.position = spawnPos
        explosion!.zPosition = 3
        explosion!.setScale(1)
        
        self.addChild(explosion!)
        
        let ScaleIn = SKAction.scale(to: 1, duration: 0.1)
        let FadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, ScaleIn, FadeOut, delete])
        explosion?.run(explosionSequence)
    }
    
    
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "beam3")
        bullet.name = "Bullet"
        bullet.setScale(2)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
        }
            
        else if currentGameState == gameState.inGame{
            fireBullet()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointofTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointofTouch.x
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDragged
            }
            
            
            if player.position.x > gameArea.maxX - player.size.width / 2 {
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            else if player.position.x < gameArea.minX + player.size.width / 2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
    }
    
    func addScore () {
        gameScore += 1
        scorelabel.text = "Score: \(gameScore)"
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        scorelabel.run(scaleSequence)
        
        
        if gameScore == 5 || gameScore == 10 || gameScore == 20 || gameScore == 30 || gameScore == 40 || gameScore == 50 || gameScore == 60{
            startNewLevel()
        }
    }
    
    
    func spawnEnemy(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "boulder")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.0)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
    }
    
    func startNewLevel () {
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        switch levelNumber {
        case 1:
            levelDuration = 1.2
        case 2:
            levelDuration = 1
        case 3:
            levelDuration = 0.8
        case 4:
            levelDuration = 0.5
        case 5:
            levelDuration = 0.3
        case 6:
            levelDuration = 0.2
        case 7:
            levelDuration = 0.1
        default:
            levelDuration = 0.1
            print("cant find level info")
        }
        
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else {
            deltaFrameTime = currentTime  - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Backgrounds") {
            backgrnd, stop in
            backgrnd.position.y -= amountToMoveBackground
            
            if backgrnd.position.y < -self.size.height {
                backgrnd.position.y += self.size.height*2
            }
        }
    }
    
    
    
}
