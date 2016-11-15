//
//  PlayerMultipleBulletsController.swift
//  Session1
//
//  Created by Developer on 11/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class PlayerMultipleBulletsController {
    weak var parent: SKScene!
    weak var playerController: PlayerController!
    var numberOfBullets: Int!
    var views = [View]()
    var SPEED: CGFloat! = 300
    
    init(parent: SKScene, playerController: PlayerController) {
        self.parent = parent
        self.playerController = playerController
        self.numberOfBullets = playerController.powerLevel
    }
    
    deinit {
        print("bye Player Multiple Bullets Controller")
    }
    
    func spawnBullet(customTexture: SKTexture?, customSpeed: CGFloat?, customAngle: CGFloat?, scale: CGFloat) {
        if customSpeed != nil {
            self.SPEED = customSpeed
        }
        
        let texture: SKTexture
        if customTexture != nil {
            texture = customTexture!
        } else {
            texture = Textures.bullet_double
        }
        
        var angle: CGFloat
        if customAngle != nil {
            angle = customAngle!
        } else {
            angle = CGFloat.pi / 24
        }
        
        for _ in 0...1 {
            let view = View(texture: texture)
            config(view: view, angle: angle, scale: scale)
            views.append(view)
            angle = -angle
        }
        if numberOfBullets == 3 {
            let view = View(texture: texture)
            config(view: view, angle: 0, scale: scale)
            views.append(view)
        }
        for view in views {
            parent.addChild(view)
        }
        self.parent.run(SoundController.PLAYER_SHOOT)
    }
    
    func config(view: View, angle: CGFloat, scale: CGFloat) {
        configProperties(view: view, scale: scale)
        configPhysics(view: view)
        configActions(view: view, angle: angle)
        configOnContact(view: view)
    }
    
    func configProperties(view: View, scale: CGFloat) {
        view.setScale(scale)
        view.name = "player_multiple_bullet"
        view.position = playerController.position.add(
            x: 0,
            y: playerController.height / 4
        )
    }
    
    func configPhysics(view: View) {
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        view.physicsBody?.categoryBitMask = BitMask.playerBullet.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemy.rawValue | BitMask.wall.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func configActions(view: View, angle: CGFloat) {
        view.physicsBody?.velocity = CGVector(dx: -sin(angle) * SPEED, dy: cos(angle) * SPEED)
    }
    
    func configOnContact(view: View) {
        view.onContact = { [unowned view] other in
            view.removeFromParent()
        }
    }
    
}
