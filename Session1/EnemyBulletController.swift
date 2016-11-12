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
    var SPEED: CGFloat! = 200
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
        bullet.physicsBody?.contactTestBitMask = BitMask.player.rawValue
        bullet.physicsBody?.collisionBitMask = 0
    }
    
    func runAction() {
        // Action
        let moveToBottomAction = SKAction.moveToBottom(
            node: bullet,
            parent: parent,
            speed: SPEED
        )
        bullet.run(.sequence([moveToBottomAction, SKAction.removeFromParent()]))
        let soundController = (parent as! GameScene).soundController
        soundController?.playSound(sound: (SoundController.ENEMY_SHOOT))
    }
}
