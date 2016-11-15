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
    weak var parent: SKScene!
    weak var planeController: PlaneController!
    
    required init() {}
    
    func set(customTexture: SKTexture?) {
        if customTexture != nil {
            self.texture = customTexture
        } else {
            self.texture = Textures.bullet_double
        }
        self.view = View(texture: texture)
    }
    
    deinit {
        print("bye Player Bullet Controller")
    }
    
    func configProperties() {
        view.name = "player_bullet"
        view.position = planeController.position.add(
            x: 0,
            y: planeController.height / 4 )
    }
    
    func configPhysics() {
        view.physicsBody?.categoryBitMask = BitMask.playerBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemy.rawValue | BitMask.wall.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func configActions() {
        // Action
        view.physicsBody?.velocity = CGVector(dx: 0, dy: SPEED)
        self.parent.run(SoundController.PLAYER_SHOOT)
    }
}
