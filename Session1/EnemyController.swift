//
//  EnemyController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class EnemyController: PlaneController {
    var view: View = View(imageNamed: "enemy-green-3")
    var SPEED: CGFloat!
    weak var parent: SKNode!
    var FIRING_INTERVAL: Double!
    
    required init() {}
    
    deinit {
        print("bye Enemy Controller")
    }
    
    func configProperties() {
        SPEED = 80
        FIRING_INTERVAL = 1
        
        view.name = "enemy"
        
        let beginX = CGFloat(drand48() * Double(parent.frame.width))
        let beginY = parent.frame.height + view.frame.height / 2
        view.position = CGPoint(x: beginX, y: beginY)
    }
    
    func configBitMask() {
        view.physicsBody?.categoryBitMask = BitMask.enemy.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.playerBullet.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func runAction() {
        // Fly Action
        let flyAction = SKAction.moveToBottom(node: view, parent: parent, speed: SPEED)
        self.view.run(.sequence([flyAction, SKAction.removeFromParent()]))
        
        // Shoot Action
        let plane = self.view
        let scene = self.parent
        
        let addBullet = SKAction.run { [unowned plane, weak scene] in
            let bulletController = EnemyBulletController(plane: plane, parent: scene!)
            scene?.addChild(bulletController.view)
            bulletController.runAction()
        }
        let delay = SKAction.wait(forDuration: self.FIRING_INTERVAL)
        
        self.view.run(.repeatForever(.sequence([addBullet, delay])))
    }
    
    func configOnContact() {
        let plane = self.view
        let scene = self.parent
        plane.onContact = { [unowned plane, weak scene] other in
            let explosionController = ExplosionController(at: plane.position)
            plane.removeFromParent()
            scene?.addChild(explosionController.view)
            explosionController.explode()
        }
    }

}
