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
    }
    
    func set(isFromLeft: Bool?) {
        if isFromLeft != nil {
            self.isFromLeft = isFromLeft!
        } else {
            self.isFromLeft = arc4random_uniform(2) == 0
        }
        
        if self.isFromLeft {
            super.set(customTexture: Textures.enemy_green_1)
        } else {
            super.set(customTexture: Textures.enemy_green_2)
        }
    }
    
    deinit {
        print("bye Enemy Diagonal Controller")
    }
    
    override func configProperties() {
        let beginX: CGFloat
        if isFromLeft {
            view = View(texture: SKTexture(image: #imageLiteral(resourceName: "enemy_green_1")))
            beginX = -view.width / 2
        } else {
            view = View(texture: SKTexture(image: #imageLiteral(resourceName: "enemy_green_2")))
            beginX = parent.size.width + (view?.width)! / 2
        }
        let beginY = CGFloat(drand48()) * parent.size.height / 2 + parent.size.height / 2 + view.height / 2
        view.position = CGPoint(x: beginX, y: beginY)
        view.name = "enemy_diagonal"
        
    }
    
    override func fly() {
        // Fly Action
        if isFromLeft {
            view.physicsBody?.velocity = CGVector(dx: SPEED * -sin(CGFloat.pi * -3 / 4), dy: SPEED * cos(CGFloat.pi * -3 / 4))
        } else {
            view.physicsBody?.velocity = CGVector(dx: SPEED * -sin(CGFloat.pi * 3 / 4), dy: SPEED * cos(CGFloat.pi * 3 / 4))
        }
    }
    
    override func shoot() {
        // Shoot Action
        let shoot = SKAction.run { [unowned self] in
            let bulletController = EnemyDiagonalBulletController(planeController: self)
            bulletController.set(customTexture: nil, isTargetingPlayer: self.isTargetingPlayer, isFromLeft: self.isFromLeft)
            bulletController.spawnBullet()
        }
        view.run(.repeatForever(.sequence([shoot, SKAction.wait(forDuration: FIRING_INTERVAL)])))
        
    }
}
