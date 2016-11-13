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
    var texture: SKTexture! = SKTexture(image: #imageLiteral(resourceName: "bullet-round"))
    var view: View!
    weak var parent: SKScene!
    weak var plane: View!
    var isTargetingPlayer = false
    var SPEED: CGFloat! = 300
    
    required init() {}
    
    deinit {
        print("bye Enemy Bullet Controller")
    }
    
    func configProperties() {
        view.name = "enemy_bullet"
        view.position = plane.position.add(
            x: 0,
            y: -plane.height / 2 - self.height / 2)
    }
    
    func configPhysics() {
        view.physicsBody?.categoryBitMask = BitMask.enemyBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.player.rawValue 
        view.physicsBody?.collisionBitMask = 0
    }
    
    func configActions() {
        // Action
        let action: SKAction
        if !isTargetingPlayer {
            action = SKAction.moveToBottom(
                node: view,
                speed: SPEED
            )
        } else {
            action = SKAction.shootToTarget(
                node: view,
                target: (parent as! GameScene).playerController.view,
                parent: parent,
                speed: SPEED
            )
        }
        view.run(.sequence([action, .removeFromParent()]))
        self.parent.run(SoundController.ENEMY_SHOOT)
    }
}

