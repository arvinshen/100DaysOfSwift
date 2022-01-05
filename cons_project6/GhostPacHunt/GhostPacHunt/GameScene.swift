//
//  GameScene.swift
//  GhostPacHunt
//
//  Created by Arvin Shen on 1/4/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var possibleEnemies = ["ghost1", "ghost2", "ghost3", "ghost4", "ghost5"]
    var gameTimer: Timer?
    var enemyTimer: Timer?
    var timeInterval = 1.0
    var isGameOver = false
    var numEnemies = 0
    var numLives = 3
    
    var gameTime: SKLabelNode!
    var time = 60 {
        didSet {
            gameTime.text = "\(time)"
        }
    }
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: width / 2, y: height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Helvetica Neue")
        gameScore.text = "Score: \(score)"
        gameScore.position = CGPoint(x: 40, y: 684)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.fontColor = .white
        addChild(gameScore)
        
        score = 0
        
        gameTime = SKLabelNode(fontNamed: "Helvetica Neue")
        gameTime.text = "\(time)"
        gameTime.position = CGPoint(x: width / 2, y: 684)
        gameTime.horizontalAlignmentMode = .center
        gameTime.fontSize = 48
        gameTime.fontColor = .white
        addChild(gameTime)
        
        time = 60

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        createLiveStock()
        
        enemyTimer = Timer.scheduledTimer(timeInterval: TimeInterval(Double.random(in: 0.75...1.25)), target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    @objc func countDown() {
        if time <= 0 {
            gameTimer?.invalidate()
        }
        time -= 1
    }
    
    func createLiveStock() {
        for i in 1...numLives {
            let sprite = SKSpriteNode(imageNamed: "pac")
            sprite.name = "life\(i)"
            sprite.xScale = 0.3
            sprite.yScale = sprite.xScale
            
            sprite.position = CGPoint(x: Int(width) - 40 * i, y: 704)
            addChild(sprite)
        }
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.name = "ghost"
        numEnemies += 1
        
        if numEnemies >= 10 {
            let sprite2 = SKSpriteNode(imageNamed: "pac")
            sprite2.name = "pac-man"
            sprite2.physicsBody = SKPhysicsBody(texture: sprite2.texture!, size: sprite2.size)
            sprite2.physicsBody?.categoryBitMask = 1
            sprite2.physicsBody?.angularVelocity = 0
            sprite2.physicsBody?.linearDamping = 0
            sprite2.physicsBody?.angularDamping = 0
            
            sprite.xScale = CGFloat(Double.random(in: 0.5...1.0))
            sprite.yScale = sprite.xScale
            
            sprite2.position = CGPoint(x: -50, y: Int.random(in: 50...650))
            sprite2.physicsBody?.velocity = CGVector(dx: Int.random(in: 250...350), dy: 0)

            numEnemies = 0
            addChild(sprite2)
        }
        
        sprite.xScale = CGFloat(Double.random(in: 0.2...1.2))
        sprite.yScale = sprite.xScale
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.angularVelocity = 0
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        sprite.position = CGPoint(x: -100, y: Int.random(in: 50...650))
        sprite.physicsBody?.velocity = CGVector(dx: Int.random(in: 200...400), dy: 0)
//            } else {
//                sprite.position = CGPoint(x: Int.random(in: Int((width / 10) * 8)...Int((width / 10) * 8)), y: Int.random(in: 50...736))
//                sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//            }
        
        addChild(sprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "pac-man" {
                hit(node: node)
                deleteNode(node: node)
                deleteNode(node: self.childNode(withName: "life\(numLives)")!)
                numLives -= 1
                score -= 1
            } else if node.name == "ghost" {
                hit(node: node)
                deleteNode(node: node)
                score += 1
            }
        }
    }
    
    func hit(node: SKNode) {
        if let smokeParticles = SKEmitterNode(fileNamed: "SmokeParticles") {
            smokeParticles.position = node.position
            addChild(smokeParticles)
        }
    }
    
    func deleteNode(node: SKNode) {
        let nodeToDelete = node
        nodeToDelete.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1300 {
                node.removeFromParent()
            }
        }
        
        if time <= 0 || numLives <= 0 {
            isGameOver = true
            gameTimer?.invalidate()
            enemyTimer?.invalidate()
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: width / 2, y: height / 2)
            gameOver.zPosition = 1
            addChild(gameOver)
            return
        }
    }
}
