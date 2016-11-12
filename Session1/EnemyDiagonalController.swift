//
//  EnemyDiagonalController.swift
//  Session1
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class EnemyDiagonalController: EnemyController {
    var isFromLeft: Bool = true
    
    init(isFromLeft: Bool, parent: SKScene) {
        super.init()
        self.isFromLeft = isFromLeft
        self.parent = parent
    }
    
    required init() {
    }
    
    override func configProperties() {
        let beginX: CGFloat
        if isFromLeft {
            view = View(texture: SKTexture(image: #imageLiteral(resourceName: "enemy-green-1")))
            beginX = -view.width / 2
        } else {
            view = View(texture: SKTexture(image: #imageLiteral(resourceName: "enemy-green-2")))
            beginX = parent.size.width + view.width / 2
        }
        let beginY = CGFloat(drand48()) * parent.size.height / 2 + parent.size.height / 2 + view.height / 2
        view.position = CGPoint(x: beginX, y: beginY)
        view.name = "enemy_diagonal"
        
    }
    
    override func runAction() {
        // Fly Action
        let move: SKAction
        if isFromLeft {
            move = SKAction.moveDiagonallyToBottomRigt(node: view, parent: parent, speed: SPEED)
        } else {
            move = SKAction.moveDiagonallyToBottomLeft(node: view, parent: parent, speed: SPEED)
        }
        view.run(.sequence([move, SKAction.removeFromParent()]))
        
        // Shoot Action
        let iFL = self.isFromLeft
        let plane = self.view
        let scene = self.parent
        
        let shoot = SKAction.run { [weak plane, weak scene] in
            let bullet = EnemyDiagonalBulletController(isFromLeft: iFL, plane: plane!, parent: scene!)
            bullet.config()
        }
        view.run(.repeatForever(.sequence([shoot, SKAction.wait(forDuration: FIRING_INTERVAL)])))
        
    }
}
