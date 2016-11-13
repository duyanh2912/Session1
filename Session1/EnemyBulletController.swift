//
//  EnemyBulletController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyBulletController: BulletController {
    var bullet: View! = View(texture: SKTexture(image: #imageLiteral(resourceName: "bullet-round")))
    var SPEED: CGFloat! = 300
    weak var parent: SKNode!
    weak var plane: View!
    var isTargetingPlayer = false
    
    required init() {}
    
    deinit {
        print("bye Enemy Bullet Controller")
    }
    
    func configProperties() {
        bullet.name = "enemy_bullet"
        bullet.position = plane.position.add(
            x: 0,
            y: -plane.height / 2 - self.height / 2)
    }
    
    func configBitMask() {
        bullet.physicsBody?.categoryBitMask = BitMask.enemyBullet.rawValue
        bullet.physicsBody?.contactTestBitMask = BitMask.player.rawValue | BitMask.wall.rawValue
        bullet.physicsBody?.collisionBitMask = 0
    }
    
    func runAction() {
        // Action
        let action: SKAction
        if !isTargetingPlayer {
            action = SKAction.moveToBottom(
                node: bullet,
                speed: SPEED
            )
        } else {
            action = SKAction.shootToTarget(
                node: bullet,
                target: (parent as! GameScene).playerController.view,
                parent: parent,
                speed: SPEED
            )
        }
        bullet.run(.sequence([action, .removeFromParent()]))
        self.parent.run(SoundController.ENEMY_SHOOT)
    }
}

