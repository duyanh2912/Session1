//
//  PowerupController.swift
//  Session1
//
//  Created by Developer on 11/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class PowerupController: BoosterController {
    var texture: SKTexture! = Textures.powerup
    var view: View!
    var initialPosition: CGPoint!
    weak var parent: SKScene!
    
    var SPEED: CGFloat! = 120
    
    deinit {
        print("bye Powerup")
    }
    
    init(parent: SKScene) {
        self.parent = parent
        print("hello Powerup")
    }
    
    func set(position: CGPoint, customSpeed: CGFloat?) {
        self.initialPosition = position
        if customSpeed != nil {
            self.SPEED = customSpeed!
        }
    }
    
    func spawn() {
        view = View(texture: texture)
        view.setScale(0.25)
        config()
        parent.addChild(view)
    }
    
    func configProperties() {
        view.position = initialPosition
        view.name = "booster_powerup"
    }
    
    func configPhysics() {
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        view.physicsBody?.linearDamping = 0
        view.physicsBody?.categoryBitMask = BitMask.powerup.rawValue
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = BitMask.player.rawValue | BitMask.wall.rawValue
    }
    
    func fly() {
        view.physicsBody?.velocity = CGVector(dx: 0, dy: -SPEED)
    }
    
    func configOnContact() {
        view.onContact = { [unowned view = self.view!] other in
            view.removeFromParent()
        }
    }
}
