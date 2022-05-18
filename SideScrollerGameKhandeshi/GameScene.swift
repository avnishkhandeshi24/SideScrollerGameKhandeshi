//
//  GameScene.swift
//  SideScrollerGameKhandeshi
//
//  Created by Avnish Khandeshi on 5/9/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var gameTimer = 1000
    //var timer = Timer()
    
    var onGround = true
    
    var startingDxValue : CGFloat?
    
    var newDxValue : CGFloat?
    
    // Ball
    var ball : SKSpriteNode!
    
    
    // Camera
    let cam = SKCameraNode()
    
    
    var finalScoreLabel : SKLabelNode!
    
    //var entities = [GKEntity]()
    //var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        // Connects ball variable to scene ball
        ball = (self.childNode(withName: "ball") as! SKSpriteNode)
        
        
        // Connects the cam variable to the current cam
        self.camera = cam
        
        finalScoreLabel = self.childNode(withName: "finalScore") as? SKLabelNode

        // Gets starting dx value
        startingDxValue = ball.physicsBody?.velocity.dx
        newDxValue = startingDxValue
        

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
            
            
            
        }
    }
    
    /*
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
     */
    
    
    // Continuously updates the camera
    override func update(_ currentTime: TimeInterval) {
        
        // Sets the center of the camera to the center of the ball
        cam.position = CGPoint(x: ball.position.x, y: 0.0)
        
    }
    
    
    func jumpBall() {
        if (onGround == true) {
            newDxValue! += 15
            ball.physicsBody?.affectedByGravity = false
            ball.physicsBody?.velocity = CGVector(dx: newDxValue!, dy: 750)
            onGround = false
            //ball.physicsBody?.velocity = CGVector(dx : 100.0, dy: 0)
        }
        else {
            newDxValue! += 15
            ball.physicsBody?.velocity = CGVector(dx: newDxValue!, dy: 0)
            ball.physicsBody?.affectedByGravity = true
            onGround = true
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "ground") {
            onGround = true
        }
        else if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "ceiling") {
            ball.physicsBody?.velocity = CGVector(dx: newDxValue!, dy: 0)
        }
        if ((contact.bodyA.node?.name! == "ball" && contact.bodyB.node?.name! == "obstacle") || ( contact.bodyA.node?.name! == "obstacle" && contact.bodyB.node?.name! == "ball")) {
            print("ok")
            reset()
        }
        else if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "finishLine" || contact.bodyB.node?.name == "ball" && contact.bodyA.node?.name == "finishLine") {
            let gameSceneTemp = GameScene(fileNamed: "GameScene")!
            self.scene?.view?.presentScene(gameSceneTemp, transition: SKTransition.fade(withDuration: 6))
            
            let p = ball.physicsBody
            ball.physicsBody = nil
            ball.position = CGPoint(x: 1000, y: -2500)
            ball.physicsBody = p
            
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            ball.isHidden = true
            
            cam.position = CGPoint(x: 1000, y: -2500)
            let finalScore = gameTimer
            finalScoreLabel.text = "Score: \(finalScore)"
            
        }
    }
    func reset() {
        newDxValue = startingDxValue
        let p = ball.physicsBody
        ball.physicsBody = nil
        ball.position = CGPoint(x: -541.914, y: -217.379)
        ball.physicsBody = p
        gameTimer -= 10
    }
    
   /* @objc func updateTimer() {
        gameTimer += 1
    }
    
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.updateTimer), userInfo: nil, repeats: true)
    }*/

    
}
