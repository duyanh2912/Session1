//
//  PlayerController.swift
//  Session1
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit

class PlayerBulletController: BulletController {
    var view = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "bullet-double")))
    var SPEED: CGFloat = 300
    var parent: SKNode!
    var plane: SKSpriteNode!
    
    required init() {}
    
    func configProperties() {
        view.name = "player_bullet"
        view.position = plane.position.add(
            x: 0,
            y: plane.size.height / 2 + view.size.height / 2)
    }
    
    func configBitMask() {
        view.physicsBody?.categoryBitMask = BitMask.playerBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemy.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func runAction() {
        // Action
        let moveToTopAction = SKAction.moveToTop(
            node: view,
            parent: parent,
            speed: SPEED
        )
        view.run(.sequence([moveToTopAction, SKAction.removeFromParent()]))
    }
}
