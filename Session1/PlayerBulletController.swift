//
//  PlayerController.swift
//  Session1
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit

class PlayerBulletController: BulletController {
    var texture: SKTexture! = SKTexture(image: #imageLiteral(resourceName: "bullet-double"))
    var view: View!
    var SPEED: CGFloat! = 300
    weak var parent: SKScene!
    weak var plane: View!
    
    required init() {}
    
    deinit {
        print("bye Player Bullet Controller")
    }
    
    func configProperties() {
        view.name = "player_bullet"
        view.position = plane.position.add(
            x: 0,
            y: plane.height / 2 + self.height / 2)
    }
    
    func configPhysics() {
        view.physicsBody?.categoryBitMask = BitMask.playerBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemy.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func configActions() {
        // Action
        let moveToTopAction = SKAction.moveToTop(
            node: view,
            parent: parent,
            speed: SPEED
        )
        
        view.run(.sequence([moveToTopAction, SKAction.removeFromParent()]))
        self.parent.run(SoundController.PLAYER_SHOOT)
    }
}
