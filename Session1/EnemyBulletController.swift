//
//  EnemyBulletController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyBulletController: BulletController, CanTargetPlayer {
    var initialPosition: CGPoint!
    var texture: SKTexture!
    var view: View!
    weak var parent: SKScene!
    weak var planeController: PlaneController!
    var isTargetingPlayer = false {
        didSet {
            if isTargetingPlayer == true {
                guard let bullet = view else {
                    return
                }
                bullet.removeAllActions()
                let action = SKAction.shootToTarget(
                    node: bullet,
                    target: (parent as! GameScene).playerController.view,
                    parent: parent,
                    speed: SPEED
                )
                bullet.run(action)
            }
        }
    }
    var SPEED: CGFloat! = 300
    
    required init() {}
    
    deinit {
        print("bye Enemy Bullet Controller")
    }
    
    func set(customTexture: SKTexture?, isTargetingPlayer: Bool) {
        if customTexture != nil {
            self.texture = customTexture
        } else {
            self.texture = Textures.bullet_round
        }
        self.isTargetingPlayer = isTargetingPlayer
    }
    
    func configProperties() {
        view.name = "enemy_bullet"
        view.position = planeController.position.add(
            x: 0,
            y: -planeController.height / 2 - self.height / 2)
    }
    
    func configPhysics() {
        view.physicsBody?.categoryBitMask = BitMask.enemyBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.player.rawValue | BitMask.wall.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func fly() {
        // Action
        if isTargetingPlayer {
            let destination = PlayerController.sharedInstance.position
            let distance = self.position.distance(to: destination)
            var vector = CGVector(dx: destination.x - position.x, dy: destination.y - position.y)
            vector.scale(by: SPEED / distance)
            view.physicsBody?.velocity = vector
            
        } else {
            view.physicsBody?.velocity = CGVector(dx: 0, dy: -SPEED)
        }
        self.parent.run(SoundController.ENEMY_SHOOT)
    }
}

