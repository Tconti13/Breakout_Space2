//
//  GameScene.swift
//  Breakout
//
//  Created by roycetanjiashing on 14/10/16.
//  Copyright © 2016 examplecompany. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    var ball:SKSpriteNode!
    var paddle:SKSpriteNode!
    var loseZone:SKSpriteNode!
    var button = SKSpriteNode(imageNamed: "start")
    var numberOfLives = 3
    var gameOn = true
    
    override func didMove(to view: SKView) {
        makeLoseZone()
        makePaddle()
        makeBall()
       button.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
       self.addChild(button)
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        ball.physicsBody?.isDynamic = true

        self.physicsBody = border
        self.physicsWorld.contactDelegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
            if button.contains(location) {
                button.alpha = 0
                ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        
        if bodyAName == "Ball" && bodyBName == "Brick" || bodyAName == "Brick" && bodyBName == "Ball"{
        if bodyAName == "Brick" {
            contact.bodyA.node?.removeFromParent()
        } else if bodyBName == "Brick" {
            contact.bodyB.node?.removeFromParent()
            }
        }
        
        if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone" {
            numberOfLives -= 1
            //Look at Patrick's code for the removal process.
//            brick.removeFromParent() // <---
            print("Life Lost.")
        }
        if numberOfLives == 0{
            gameOn = false
          //  resetGame()
            ball.removeFromParent()
        }
    }
    func makeBall(){
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        ball.position = CGPoint(x:frame.midX, y: frame.midY)
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10) //Physics shape matches ball image.
        ball.physicsBody?.isDynamic = false //Ignores all forces and impulses
        ball.physicsBody?.usesPreciseCollisionDetection = true //Use precise collision detection.
        ball.physicsBody?.friction = 0 //No loss of energy from friction.
        ball.physicsBody?.affectedByGravity = false //Gravity is not a factor.
        ball.physicsBody?.restitution = 1 //Bounces fully off of other objects.
        ball.physicsBody?.linearDamping = 0 //Does not slow down over time.
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
    }
    func makePaddle() {
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
    }
        
        
        func makeLoseZone() {
            loseZone = self.childNode(withName: "LoseZone")as! SKSpriteNode
            loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
            loseZone.name = "loseZone"
            loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
            loseZone.physicsBody?.isDynamic = false
        }
    
    func softReset() {
        
    }
        
        func resetGame() {
            gameOn = true
            numberOfLives = 3
            self.addChild(button)
            ball = self.childNode(withName: "Ball") as! SKSpriteNode
            paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
}        
}
