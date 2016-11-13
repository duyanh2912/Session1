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
    var isTargetingPlayer = false
    
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
    }
    
    func set(customImage: UIImage?){
        if let playerImage = customImage {
            texture = SKTexture(image: playerImage)
        }
        texture = SKTexture(image: #imageLiteral(resourceName: "enemy-green-3"))
    }
    
    func spawnEnemy() {
        view = View(texture: texture)
        config()
        view = nil // phải có dòng này ko thì view sẽ ko dealocate ngay => collide nhiều lần
    }
    
    func configPhysics() {
        view?.physicsBody?.categoryBitMask = BitMask.enemy.rawValue
        view?.physicsBody?.contactTestBitMask = BitMask.playerBullet.rawValue
        view?.physicsBody?.collisionBitMask = 0
    }
    
    func flyAction() {
        // Fly Action
        let flyAction = SKAction.moveToBottom(node: view!, speed: SPEED)
        self.view.run(.sequence([flyAction, SKAction.removeFromParent()]))
    }
    
    func shootAction() {
        // Shoot Action
        let plane = self.view
        let scene = self.parent
        
        let addBullet = SKAction.run { [weak plane, weak scene, weak self] in
            let bulletController = EnemyBulletController(plane: plane!, parent: scene!)
            bulletController.isTargetingPlayer = (self?.isTargetingPlayer)!
            bulletController.config()
        }
        let delay = SKAction.wait(forDuration: self.FIRING_INTERVAL)
        
        self.view?.run(.repeatForever(.sequence([addBullet, delay])))
    }
    
    func configOnContact() {
        let plane = self.view!
        
        plane.onContact = { [unowned self, unowned plane] other in
            plane.removeFromParent()
            let scene = self.parent as! GameScene
            scene.explosionController.explode(at: plane)
            scene.score += 1
        }
    }
    
}
