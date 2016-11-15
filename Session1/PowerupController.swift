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
    var view: View!
    var parent: SKScene!
    var initialPosition: CGPoint!
    var SPEED: CGFloat = 120
    
    init(parent: SKScene) {
        self.parent = parent
        print("hello Powerup C")
    }
    
    func set(position: CGPoint, customSpeed: CGFloat?) {
        self.initialPosition = position
        if customSpeed != nil {
            self.SPEED = customSpeed!
        }
        view = View(texture: Textures.powerup)
        view.setScale(0.25)
    }
    
    func spawnPowerup() {
        config()
    }
    
    func configProperties() {
        view.position = self.initialPosition
        view.name = "booster_powerup"
    }
    
    func configPhysics() {
        view.physicsBody?.categoryBitMask = BitMask.powerup.rawValue
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = BitMask.player.rawValue | BitMask.wall.rawValue
    }
    
    func configActions() {
        view.physicsBody?.velocity = CGVector(dx: 0, dy: -SPEED)
    }
}
