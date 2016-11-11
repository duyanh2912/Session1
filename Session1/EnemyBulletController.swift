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
    var view = View(texture: SKTexture(image: #imageLiteral(resourceName: "bullet-round")))
    var SPEED: CGFloat = 200
    weak var parent: SKNode!
    weak var plane: SKSpriteNode!
    
    required init() {}
    
    deinit {
        print("bye Enemy Bullet Controller")
    }
    
    func configProperties() {
        view.name = "enemy_bullet"
        view.position = plane.position.add(
            x: 0,
            y: -plane.size.height / 2 - view.size.height / 2)
    }
    
    func configBitMask() {
        view.physicsBody?.categoryBitMask = BitMask.enemyBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.player.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func runAction() {
        // Action
        let moveToBottomAction = SKAction.moveToBottom(
            node: view,
            parent: parent,
            speed: SPEED
        )
        view.run(.sequence([moveToBottomAction, SKAction.removeFromParent()]))
    }
}
