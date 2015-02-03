//
//  GameScene.swift
//  1. ZombieConga
//
//  Created by fl on 03.02.15.
//  Copyright (c) 2015 lwo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    lazy var lastUpdateTime:NSTimeInterval = 0
    lazy var dt:NSTimeInterval = 0
    let zombieMovePointsPerSec:CGFloat = 240
    var velocity = CGPointZero
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        
        self.addChild(self.background1)
        self.addChild(self.zombie1)
    }
    
    override func update(currentTime: NSTimeInterval) {

        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }

        lastUpdateTime = currentTime
        
        moveSprite(self.zombie1, velocity: velocity)
//        boundsCheckZombie()
//        rotateSprite(zombie, direction: velocity)
    }
    
    //MARK:Touches
    
    func sceneTouched(touchLocation:CGPoint) {
        moveZombieToward(touchLocation)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            let touchLocation = touch.locationInNode(self)
            sceneTouched(touchLocation)
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            let touchLocation = touch.locationInNode(self)
            sceneTouched(touchLocation)
        }
    }
    
    //MARK:Move
    
    func moveSprite(sprite:SKSpriteNode, velocity:CGPoint) {
        let amountToMove = self.velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    func moveZombieToward(location:CGPoint) {
        let offset = location - self.zombie1.position
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = offset / CGFloat(length)
        velocity = direction * self.zombieMovePointsPerSec
    }
    
    //MARK:Lazy
    
    lazy var background1:SKSpriteNode = {
        let background = SKSpriteNode(imageNamed: "background1")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        return background
    }()
    
    lazy var zombie1:SKSpriteNode = {
        let zombie1 = SKSpriteNode(imageNamed: "zombie1")
        zombie1.position = CGPoint(x: 400, y: 400)
        return zombie1
    }()
}
