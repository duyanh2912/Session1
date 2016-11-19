//
//  EnemyController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class EnemyController: PlaneController, Shootable, CanTargetPlayer {
    var option = [Textures.enemy_green_3, Textures.plane1]
    
    var texture: SKTexture!
    var view: View!
    var initialPosition: CGPoint!
    weak var parent: SKScene!
    
    var SPEED: CGFloat! = 160
    var FIRING_INTERVAL: Double! = 1
    var isTargetingPlayer = false {
        didSet {
            for bulletController in activeBulletControllers where bulletController is EnemyBulletController {
                (bulletController as! EnemyBulletController).isTargetingPlayer = self.isTargetingPlayer
            }
        }
    }
    var activeBulletControllers = [BulletController]()
    var enemyGenerator: RandomEnemyGenerator!
    
    deinit {
        print("bye Enemy Controller")
    }
    
    func configProperties() {
        view?.name = "enemy"
        
        let beginX = CGFloat(drand48() * Double(parent.frame.width))
        let beginY = parent.frame.height + (view?.frame.height)! / 2
        view.position = CGPoint(x: beginX, y: beginY)
    }
    
    init(parent: SKScene) {
        self.parent = parent
        RandomEnemyGenerator.activeEnemyControllers.append(self)
    }
    
    func set(customTexture: SKTexture?){
        if customTexture != nil {
            texture = customTexture!
        } else {
            texture = option[Int(arc4random_uniform(UInt32(option.count)))]
        }
    }
    
    func spawn() {
        view = View(texture: texture)
        config()
        parent.addChild(view)
    }
    
    func configPhysics() {
        view?.physicsBody?.categoryBitMask = BitMask.enemy.rawValue
        view?.physicsBody?.contactTestBitMask = BitMask.playerBullet.rawValue | BitMask.wall.rawValue
        view?.physicsBody?.collisionBitMask = 0
    }
    
    func configActions() {
        fly()
        shoot()
    }
    
    func fly() {
        // Fly Action
        view.physicsBody?.velocity = CGVector(dx: 0, dy: -SPEED)
    }
    
    func shoot() {
        // Shoot Action
        let addBullet = SKAction.run { [unowned self] in
            let bulletController = EnemyBulletController(planeController: self)
            bulletController.set(customTexture: nil, isTargetingPlayer: self.isTargetingPlayer)
            bulletController.spawnBullet()
        }
        let delay = SKAction.wait(forDuration: self.FIRING_INTERVAL)
        
        self.view?.run(.repeatForever(.sequence([addBullet, delay])))
    }
    
    func configOnContact() {
        self.view.onContact = { [unowned self] (other, contact) in
            if (other as? SKNode)?.physicsBody?.categoryBitMask != BitMask.wall.rawValue {
                let scene = self.parent as! GameScene
                scene.explosionController.explode(at: self.view)
                scene.score += 10
                
                let position = self.position
                // Randomize
                DispatchQueue.global().async { [unowned scene] in
                    if arc4random_uniform(UInt32(LuckRate.powerup)) == 0 {
                        print(LuckRate.powerup)
                        let powerupController = PowerupController(parent: scene)
                        powerupController.set(position: position, customSpeed: nil)
                        DispatchQueue.main.async {
                            powerupController.spawn()
                        }
                    }
                }
            }
            self.view.removeFromParent()
            self.removeFromEnemyGenerator()
        }
    }
    func removeFromEnemyGenerator() {
        if let index = RandomEnemyGenerator.activeEnemyControllers.index(where: { $0 === self }) {
            RandomEnemyGenerator.activeEnemyControllers.remove(at: index)
        }
    }
}
