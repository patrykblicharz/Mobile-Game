//
//  GameScene.swift
//  Desert Run
//
//  Created by BLICHARZ, PATRYK on 13/11/2019.
//  Copyright © 2019 BLICHARZ, PATRYK. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct Physics {
        static let Player : UInt32 = 1
        static let Water : UInt32 = 2
        static let Fence : UInt32 = 3
        static let Screen : UInt32 = 4
        static let None : UInt32 = 5
    }

    let sand = SKSpriteNode(imageNamed: "sand")
    let sand2 = SKSpriteNode(imageNamed: "sand")
    let sand3 = SKSpriteNode(imageNamed: "sand") //background images
    let player = SKSpriteNode(imageNamed: "player") //player
    let screen = UIScreen.main.bounds //screen
    var parallax = SKAction() //scrolling background
    var motionManager : CMMotionManager?
    var jumpTime = 10.0
    let jumpCooldown = 0.9
    var isJumping = false
    var lastUpdate: TimeInterval = 0 //jump cooldown
    var gameOver = false
    lazy var countdownLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "BubbleGum")
        label.fontSize = 20
        label.zPosition = 6
        label.color = SKColor.white
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.text = "Heat: \(counterStartValue)"
        return label
    }()
    var counter = 0
    var counterTimer = Timer()
    var counterStartValue = 30 //timer
    
    func startCounter() {
        counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
    }
    @objc func decrementCounter() {
        counter -= 1
        countdownLabel.text = "Heat: \(counter)"
    }   //heat timer
    
    func spawnWater() {
        func RandomX(width: CGFloat) ->CGFloat {
            return CGFloat(arc4random()) .truncatingRemainder(dividingBy: CGFloat(width / 3))
        }
        func random() -> CGFloat{
            return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        }
        func random(min: CGFloat, max: CGFloat) -> CGFloat {
            return random() * (max - min) + min
        }
        
        func createWater()
      {
          let water = SKSpriteNode(imageNamed: "water") //pickup
          water.name = "water"
          water.zPosition = 4
          water.position = CGPoint(x: Int(arc4random()%400), y: 750)
          water.physicsBody = SKPhysicsBody(rectangleOf: water.size)
          water.physicsBody?.affectedByGravity = false
          water.physicsBody?.isDynamic = false
          water.physicsBody?.categoryBitMask = Physics.Water
          water.physicsBody?.collisionBitMask = Physics.Player
          self.addChild(water)
         // let actionMoveDone = SKAction.removeFromParent()
          let actionMove = SKAction.moveBy(x: 0, y: -1000, duration: 4)
          water.run(SKAction.sequence([actionMove]))
        }
        let wait = SKAction.wait(forDuration: 5)
        let spawn = SKAction.run { createWater() }
        let sequenceW = SKAction.sequence([wait, spawn])
        let forever = SKAction.repeatForever(sequenceW)
        self.run(forever)
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        createSceneContents()
        createPlayer(scene: self)
        spawnWater() //calling all the functions
        spawnFence()
        countdownLabel.position = CGPoint(x: frame.midX, y: 700)
        addChild(countdownLabel)
        counter = counterStartValue
        startCounter()

        sand.position = CGPoint(x: frame.midX, y: 0)
        sand.size = CGSize(width: screen.width * 1.1, height: self.frame.size.height)
        sand.zPosition = 3
        self.addChild(sand)
        
        sand2.position = CGPoint(x: frame.midX, y: self.frame.size.height)
        sand2.size = CGSize(width: screen.width * 1.1, height: self.frame.size.height)
        sand2.zPosition = 3
        self.addChild(sand2)
        
        sand3.position = CGPoint(x: frame.midX, y: self.frame.size.height + sand2.position.y)
        sand3.size = CGSize(width: screen.width * 1.1, height: self.frame.size.height)
        sand3.zPosition = 3
        self.addChild(sand3)
        
        parallax = SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: -self.frame.size.height),duration: 5))
        sand.run(parallax)
        sand2.run(parallax)
        sand3.run(parallax) //scrolling background
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    override func update(_ currentTime: TimeInterval) {
    if let accelerometerData = motionManager?.accelerometerData {
        physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 10, dy: 0) //player movement
        }
        if sand.position.y <= -self.frame.size.height {
            sand.position.y = self.frame.size.height * 2
        }
        if sand2.position.y <= -self.frame.size.height {
            sand2.position.y = self.frame.size.height * 2
        }
        if sand3.position.y <= -self.frame.size.height {
            sand3.position.y = self.frame.size.height * 2
        } //scrolling backgroud
        jumpTime += currentTime - lastUpdate
        lastUpdate = currentTime
        
//        if counter <= 0 {
//                  gameOver = true
//                  player.removeFromParent()
//                  exit(0)
//              } //game over when heat runs out
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //giving the player abiliy to jump
        if jumpTime > jumpCooldown {
            jumpTime = 0
            isJumping = true
            let jumpAction = SKAction.moveBy(x: 0, y: 100, duration: 0.4) //move up
            let jumpDownAction = SKAction.moveBy(x: 0, y: -100, duration: 0.4) // move down
            let jumpSequence = SKAction.sequence([jumpAction, jumpDownAction]) // the whole sequence
            player.run(jumpSequence)
        }
        else{
            isJumping = false
        }
    }
      func createPlayer(scene: SKScene) {  //player creation and physics
        player.name = "player"
        player.isUserInteractionEnabled = false;
        player.position.x = scene.frame.minX + 250
        player.position.y = scene.frame.minY + 10
        player.zPosition = 4
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = Physics.Player
        player.physicsBody?.collisionBitMask = Physics.Water
        player.physicsBody?.collisionBitMask = Physics.Fence
        player.physicsBody?.collisionBitMask = Physics.Screen
        player.physicsBody?.contactTestBitMask = Physics.Screen
        player.physicsBody?.contactTestBitMask = Physics.Water
        player.physicsBody?.contactTestBitMask = Physics.Fence
        scene.addChild(player)
      }
    func spawnFence() //creating the fence obstacle, giving it physics and movement
    {
       func createFence(){
        let fence = SKSpriteNode(imageNamed: "fence") //obstacle
        fence.name = "fence"
        fence.zPosition = 4
        fence.size.width = screen.width
        fence.position = CGPoint(x: 200, y: 750)
        fence.physicsBody = SKPhysicsBody(rectangleOf: fence.size)
        fence.physicsBody?.affectedByGravity = false
        fence.physicsBody?.isDynamic = false
        fence.physicsBody?.categoryBitMask = Physics.Fence
        fence.physicsBody?.collisionBitMask = Physics.Player
        fence.physicsBody?.contactTestBitMask = Physics.Player
        self.addChild(fence)
        let actionMoveDone = SKAction.removeFromParent()
        let actionMove = SKAction.moveBy(x: 0, y: -1000, duration: 3)
        fence.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
        let wait = SKAction.wait(forDuration: 10)
        let spawn = SKAction.run {createFence()}
        let sequenceW = SKAction.sequence([wait, spawn])
        let forever = SKAction.repeatForever(sequenceW)
        self.run(forever)
    }
  
    func didBegin(_ contact: SKPhysicsContact) { //what happens on certain collisions
        // var entity1 entity2
        // make sure that entity1 is player
       var body1 = SKPhysicsBody()
       var body2 = SKPhysicsBody()

        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else
        {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if(body1.categoryBitMask == Physics.Player && body2.categoryBitMask == Physics.Water)
       {
          counter += 8
          contact.bodyB.node?.removeFromParent()
       }
        if(!isJumping){
        if(body1.categoryBitMask == Physics.Player && body2.categoryBitMask == Physics.Fence)
        {
            exit(0)
        }
      }
    }
    func createSceneContents(){ //used to set up what the screen collides with and what it doesn't
        self.backgroundColor = .orange
        self.scaleMode = .aspectFill
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.name = "sand"
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = Physics.Screen
    }
    
}
    

    
    
    
