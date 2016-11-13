//
//  PlayerController.swift
//  Session1
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit

class PlayerBulletController: BulletController {
    var bullet: View! = View(texture: SKTexture(image: #imageLiteral(resourceName: "bullet-double")))
    var SPEED: CGFloat! = 300
    weak var parent: SKNode!
    weak var plane: View!
    
    required init() {}
    
    deinit {
        print("bye Player Bullet Controller")
    }
    
    func configProperties() {
        bullet.name = "player_bullet"
        bullet.position = plane.position.add(
            x: 0,
            y: plane.height / 2 + self.height / 2)
    }
    
    func configBitMask() {
        bullet.physicsBody?.categoryBitMask = BitMask.playerBullet.rawValue
        bullet.physicsBody?.contactTestBitMask = BitMask.enemy.rawValue
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func runAction() {
        // Action
        let moveToTopAction = SKAction.moveToTop(
            node: bullet,
            parent: parent,
            speed: SPEED
        )
        
        bullet.run(.sequence([moveToTopAction, SKAction.removeFromParent()]))
        self.parent.run(SoundController.PLAYER_SHOOT)
    }
}
