//
//  GameScene.swift
//  1. ZombieConga
//
//  Created by fl on 03.02.15.
//  Copyright (c) 2015 lwo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
//        background.zRotation = CGFloat(M_PI) / 8
        
        self.addChild(background)
    }
}
