//
//  EnemyDiagonalBulletController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class EnemyDiagonalBulletController: EnemyBulletController {
    var isFromLeft: Bool = true
    
    deinit {
        print("bye Enemy Diagonal Bullet Controller")
    }
    
    required init() {
        
    }
    
    func set(customTexture: SKTexture?, isTargetingPlayer: Bool, isFromLeft: Bool) {
        if customTexture != nil {
            self.texture = customTexture
        } else {
            self.texture = Textures.bullet_round
        }
        self.isTargetingPlayer = isTargetingPlayer
        self.isFromLeft = isFromLeft
    }
    
    override func configProperties() {
        view.name = "enemy_bullet"
        switch isFromLeft {
        case true:
            view.position = planeController.position.add(
                x: planeController.width / 2 + view.width / 2,
                y: -planeController.height / 2 - view.height / 2
            )
            
        case false:
            view.position = planeController.position.add(
                x: -planeController.width / 2 - view.width / 2,
                y: -planeController.height / 2 - view.height / 2
            )
        }
    }
    
    override func fly() {
        if isTargetingPlayer {
            let action = SKAction.shootToTarget(
                node: view,
                target: (parent as! GameScene).playerController.view,
                parent: parent,
                speed: SPEED
            )
             view.run(.sequence([action, .removeFromParent()]))
        } else {
            switch isFromLeft {
            case true:
                view.physicsBody?.velocity = CGVector(
                    dx: SPEED * -sin(-CGFloat.pi * 3 / 4),
                    dy: SPEED * cos(-CGFloat.pi * 3 / 4)
                )
                
            case false:
                view.physicsBody?.velocity = CGVector(
                    dx: SPEED * -sin(CGFloat.pi * 3 / 4),
                    dy: SPEED * cos(CGFloat.pi * 3 / 4)
                )
            }
        }
        parent.run(SKAction.playSoundFileNamed("enemy_shoot", waitForCompletion: false))
    }
}
