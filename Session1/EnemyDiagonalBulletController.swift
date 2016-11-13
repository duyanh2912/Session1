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
    
    init(isFromLeft: Bool, plane: View, parent: SKScene) {
        super.init()
        self.isFromLeft = isFromLeft
        self.plane = plane
        self.parent = parent
    }
    
    required init() {}
    
    override func configProperties() {
        view.name = "enemy_bullet"
        switch isFromLeft {
        case true:
            view.position = plane.position.add(
                x: plane.width / 2 + view.width / 2,
                y: -plane.height / 2 - view.height / 2
            )
            
        case false:
            view.position = plane.position.add(
                x: -plane.width / 2 - view.width / 2,
                y: -plane.height / 2 - view.height / 2
            )
        }
    }
    
    override func configPhysics() {
        let action: SKAction
        if isTargetingPlayer {
            action = SKAction.shootToTarget(
                node: view,
                target: (parent as! GameScene).playerController.view,
                parent: parent,
                speed: SPEED
            )
        } else {
            switch isFromLeft {
            case true:
                action = SKAction.moveDiagonallyToBottomRigt(node: view, speed: SPEED)
                
            case false:
                action = SKAction.moveDiagonallyToBottomLeft(node: view, speed: SPEED)
            }
        }
        view.run(.repeatForever(.sequence([action, SKAction.removeFromParent()])))
        parent.run(SKAction.playSoundFileNamed("enemy_shoot", waitForCompletion: false))
        print(SPEED)
    }
}
