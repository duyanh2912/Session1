//
//  LivesUpController.swift
//  Session1
//
//  Created by Developer on 11/19/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class LivesUpController: PowerupController {
    override init(parent: SKScene) {
        super.init(parent: parent)
        texture = Textures.lives_up
    }
    
    override func configPhysics() {
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        view.physicsBody?.categoryBitMask = BitMask.livesUp.rawValue
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = BitMask.player.rawValue | BitMask.wall.rawValue
    }
}
