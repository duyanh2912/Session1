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
    
    override init(parent: SKScene) {
        super.init(parent: parent)
        self.bulletController = EnemyDiagonalBulletController(parent: self.parent)
    }
    
    func set(isFromLeft: Bool) {
        self.isFromLeft = isFromLeft
        if isFromLeft {
            super.set(customImage: #imageLiteral(resourceName: "enemy-green-1"))
        } else {
            super.set(customImage: #imageLiteral(resourceName: "enemy-green-2"))
        }
        (bulletController as! EnemyDiagonalBulletController).isFromLeft = isFromLeft
    }
    
    deinit {
        print("bye Enemy Diagonal Controller")
    }
    
    override func configProperties() {
        let beginX: CGFloat
        if isFromLeft {
            view = View(texture: SKTexture(image: #imageLiteral(resourceName: "enemy-green-1")))
            beginX = -view.width / 2
        } else {
            view = View(texture: SKTexture(image: #imageLiteral(resourceName: "enemy-green-2")))
            beginX = parent.size.width + (view?.width)! / 2
        }
        let beginY = CGFloat(drand48()) * parent.size.height / 2 + parent.size.height / 2 + view.height / 2
        view.position = CGPoint(x: beginX, y: beginY)
        view.name = "enemy_diagonal"
        
    }
    
    override func flyAction() {
        // Fly Action
        let move: SKAction
        if isFromLeft {
            move = SKAction.moveDiagonallyToBottomRigt(node: view, speed: SPEED)
        } else {
            move = SKAction.moveDiagonallyToBottomLeft(node: view, speed: SPEED)
        }
        view.run(.sequence([move, SKAction.removeFromParent()]))
    }
    
    override func shootAction() {
        // Shoot Action
        let plane = self.view!
        let iFL = self.isFromLeft
        
        let shoot = SKAction.run { [unowned plane, unowned self] in
            (self.bulletController as! EnemyDiagonalBulletController).spawnBullet(of: plane, isFromLeft: iFL)
        }
        view.run(.repeatForever(.sequence([shoot, SKAction.wait(forDuration: FIRING_INTERVAL)])))
        
    }
}
