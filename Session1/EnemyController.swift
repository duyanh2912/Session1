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
    var texture: SKTexture!
    var view: View!
    var SPEED: CGFloat! = 160
    weak var parent: SKScene!
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
            texture = Textures.enemy_green_3
        }
    }
    
    func spawnEnemy() {
        view = View(texture: texture)
        config()
    }
    
    func configPhysics() {
        view?.physicsBody?.categoryBitMask = BitMask.enemy.rawValue
        view?.physicsBody?.contactTestBitMask = BitMask.playerBullet.rawValue | BitMask.wall.rawValue
        view?.physicsBody?.collisionBitMask = 0
    }
    
    func flyAction() {
        // Fly Action
        let flyAction = SKAction.moveToBottom(node: view!, speed: SPEED)
        self.view.run(.sequence([flyAction, SKAction.removeFromParent()]))
    }
    
    func shootAction() {
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
                
                // Randomize
                if arc4random_uniform(10) == 0 {
                    let powerupController = PowerupController(parent: self.parent)
                    print(self.position)
                    powerupController.set(position: self.position, customSpeed: nil)
                    powerupController.spawnPowerup()
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
