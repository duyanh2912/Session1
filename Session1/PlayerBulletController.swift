//
//  PlayerController.swift
//  Session1
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit

class PlayerBulletController: BulletController {
    var texture: SKTexture!
    var view: View!
    var SPEED: CGFloat! = 300
    var initialPosition: CGPoint!
    weak var parent: SKScene!
    weak var planeController: PlaneController!
    
    required init() {}
    
    func set(customPosition: CGPoint? = nil, customTexture: SKTexture = Textures.bullet_single) {
        self.texture = customTexture
        self.initialPosition = customPosition ?? planeController.position.add(
            x: 0,
            y: planeController.height / 4
        )
    }
    
    deinit {
        print("bye Player Bullet Controller")
    }
    
    func configProperties() {
        view.name = "player_bullet"
        view.position = initialPosition
    }
    
    func configPhysics() {
        view.physicsBody?.categoryBitMask = BitMask.playerBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemy.rawValue | BitMask.wall.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func fly() {
        // Action
        view.physicsBody?.velocity = CGVector(dx: 0, dy: SPEED)
        self.parent.run(SoundController.sharedInstance.PLAYER_SHOOT)
    }
}
