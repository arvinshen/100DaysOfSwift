//
//  GameScene.swift
//  FireworksNight
//
//  Created by Arvin Shen on 1/5/22.
//

import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = Int(UIScreen.main.bounds.width) + 22

    var scoreLabel: SKLabelNode?
    
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: width / 2, y: height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // 1. Create an SKNode that will act as the firework container, and place it at the position that was specified.
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // 2. Create a rocket sprite node, give it the name "firework" so we know that it's the important thing, adjust its colorBlendFactor property so that we can color it, then add it to the container node.
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        // 3. Give the firework sprite node 1 of 3 random colors: cyan, green or red.
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
            
        case 1:
            firework.color = .green
            
        case 2:
            firework.color = .red
            
        default:
            break
        }
        
        // 4. Create a UIBezierPath that will represent the movement of the firework.
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // 5. Tell the container node to follow that path, turning itself as needed.
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        // 6. Create particles behind the rocket to make it look like the fireworks are lit.
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        // 7. Add the firework to our fireworks array and also to the scene.
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire 5, straight up
            createFirework(xMovement: 0, x: Int(width) / 2, y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width) / 2 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width) / 2 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width) / 2 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: Int(width) / 2 + 200, y: bottomEdge)
            
        case 1:
            // fire 5, in a fan
            createFirework(xMovement: 0, x: Int(width) / 2, y: bottomEdge)
            createFirework(xMovement: -200, x: Int(width) / 2 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: Int(width) / 2 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: Int(width) / 2 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: Int(width) / 2 + 200, y: bottomEdge)
            
        case 2:
            // fire 5, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        
        case 3:
            // fire 5, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { return }
            
            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            // nothing - rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
