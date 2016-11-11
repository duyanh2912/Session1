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
    
    deinit {
        print("bye Enemy Diagonal Bullet Controller")
    }
    
    override func configProperties() {
        view.name = "enemy_bullet"
        
        guard let planeName = plane.name else {
            fatalError("Enemy plane's name is not set")
        }
        switch planeName {
        case EnemyType.enemy_green_1.rawValue:
            view.position = plane.position.add(
                x: plane.size.width / 2 + view.size.width / 2,
                y: -plane.size.height / 2 - view.size.height / 2
            )
            
        case EnemyType.enemy_green_2.rawValue:
            view.position = plane.position.add(
                x: -plane.size.width / 2 - view.size.width / 2,
                y: -plane.size.height / 2 - view.size.height / 2
            )
            
        default:
            break
        }
    }
    
    override func runAction() {
        let action: SKAction
        guard let planeName = plane.name else {
            fatalError("Enemy plane's name is not set")
        }
        switch planeName {
        case EnemyType.enemy_green_1.rawValue:
            action = SKAction.moveDiagonallyToBottomRigt(node: view, parent: parent, speed: SPEED)
            
        case EnemyType.enemy_green_2.rawValue:
            action = SKAction.moveDiagonallyToBottomLeft(node: view, parent: parent, speed: SPEED)
            
        default:
            fatalError("plane not supported")
        }
        
        view.run(.repeatForever(.sequence([action, SKAction.removeFromParent()])))
        print(SPEED)
    }
}
