//
//  GameScene.swift
//  1. ZombieConga
//
//  Created by fl on 03.02.15.
//  Copyright (c) 2015 lwo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let playableRect:CGRect
    let zombieAnimation:SKAction

    var lastTouchLocation: CGPoint?
    
    lazy var lastUpdateTime:NSTimeInterval = 0
    lazy var dt:NSTimeInterval = 0
    lazy var velocity = CGPointZero
    let zombieMovePointsPerSec:CGFloat = 480
    let zombieRotateRadiansPerSec:CGFloat = 4.0 * π
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0

        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        var textures = [SKTexture]()
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        
        zombieAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.1))
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        addChild(background1)
        addChild(zombie1)
        startZombieAnimation()
        spawnEnemy()
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnCat), SKAction.waitForDuration(1.0)])))
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if let lastTouch = lastTouchLocation {
            let diff = lastTouch - zombie1.position
            if (diff.length() <= zombieMovePointsPerSec * CGFloat(dt)) {
                zombie1.position = lastTouchLocation!
                velocity = CGPointZero
            } else {
                moveSprite(zombie1, velocity: velocity)
                rotateSprite(zombie1, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
            }
        }
        
        boundsCheckZombie()
    }
    
    //MARK:Actions
    
    let zombieAnimationKey = "animation"
    
    func startZombieAnimation() {
        if zombie1.actionForKey(zombieAnimationKey) == nil {
            zombie1.runAction(SKAction.repeatActionForever(zombieAnimation), withKey: zombieAnimationKey)
        }
    }
    
    func stopZombieAnimation() {
        zombie1.removeActionForKey(zombieAnimationKey)
    }
    
    func spawnCat() {
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.position = CGPoint(x: CGFloat.random(min: CGRectGetMinX(playableRect), max: CGRectGetMaxX(playableRect)), y: CGFloat.random(min: CGRectGetMinY(playableRect), max: CGRectGetMaxY(playableRect)))
        cat.setScale(0)
        addChild(cat)
        
        let appear = SKAction.scaleBy(1.0, duration: 0.5)
        let wait = SKAction.waitForDuration(10.0)
        let dissappear = SKAction.scaleTo(0, duration: 0.5)
        let remoteFromParent = SKAction.removeFromParent()
        let actions = [appear, wait, dissappear]
        cat.runAction(SKAction.sequence(actions))
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2,
            y: CGFloat.random(min:CGRectGetMinY(playableRect) + enemy.size.height / 2,
                max:CGRectGetMaxY(playableRect) - enemy.size.height / 2))
        addChild(enemy)
        
        let actionMidMove = SKAction.moveByX( -size.width/2-enemy.size.width/2, y: -CGRectGetHeight(playableRect)/2 + enemy.size.height/2, duration: 1.0)
        let actionMove = SKAction.moveToX(-enemy.size.width / 2, duration: 2.0)
        enemy.runAction(SKAction.repeatActionForever(SKAction.sequence([actionMove, actionMove.reversedAction(), actionMidMove.reversedAction()])))
    }
    
    //MARK:Move
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    func moveZombieToward(location: CGPoint) {
        let offset = location - zombie1.position
        let direction = offset.normalized()
        velocity = direction * zombieMovePointsPerSec
    }
    
    //MARK:Touches
    
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        moveZombieToward(touchLocation)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    //MARK:----
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0, y: CGRectGetMinY(playableRect))
        let topRight = CGPoint(x: size.width, y: CGRectGetMaxY(playableRect))
        
        
        if zombie1.position.x <= bottomLeft.x {
            zombie1.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if zombie1.position.x >= topRight.x {
            zombie1.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie1.position.y <= bottomLeft.y {
            zombie1.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie1.position.y >= topRight.y {
            zombie1.position.y = topRight.y
            velocity.y = -velocity.y
        } 
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        // Your code here!
        let shortest = shortestAngleBetween(sprite.zRotation, velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
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
