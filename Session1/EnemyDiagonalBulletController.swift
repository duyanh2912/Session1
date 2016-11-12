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
    
    init(isFromLeft: Bool, plane: View, parent: SKNode) {
        super.init()
        self.isFromLeft = isFromLeft
        self.plane = plane
        self.parent = parent
    }
    
    required init() {}
    
    override func configProperties() {
        bullet.name = "enemy_bullet"
        switch isFromLeft {
        case true:
            bullet.position = plane.position.add(
                x: plane.width / 2 + bullet.width / 2,
                y: -plane.height / 2 - bullet.height / 2
            )
            
        case false:
            bullet.position = plane.position.add(
                x: -plane.width / 2 - bullet.width / 2,
                y: -plane.height / 2 - bullet.height / 2
            )
        }
    }
    
    override func runAction() {
        let action: SKAction
        switch isFromLeft {
        case true:
            action = SKAction.moveDiagonallyToBottomRigt(node: bullet, parent: parent, speed: SPEED)
            
        case false:
            action = SKAction.moveDiagonallyToBottomLeft(node: bullet, parent: parent, speed: SPEED)
        }
        
        bullet.run(.repeatForever(.sequence([action, SKAction.removeFromParent()])))
        parent.run(SKAction.playSoundFileNamed("enemy_shoot", waitForCompletion: false))
        print(SPEED)
    }
}
