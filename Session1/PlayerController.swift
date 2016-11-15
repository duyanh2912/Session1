//
//  PlayerController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation
class PlayerController: PlaneController {
    var texture: SKTexture!
    var view: View!
    var SPEED: CGFloat! = 80
    weak var parent: SKScene!
    var hp = 10 {
        didSet {
            let scene = parent as? GameScene
            scene?.hpLabel.text = "HP: \(self.hp)"
            scene?.hpLabelBlock.size = (scene?.hpLabel.frame.size.add(dWidth: 6, dHeight: 6))!
        }
    }
    var FIRING_INTERVAL: Double! = 0.5
    var activeBulletControllers = [BulletController]()
    var powerLevel = 1 {
        didSet {
            view.removeAllActions()
            self.configActions()
        }
    }
    
    init(parent: SKScene) {
        self.parent = parent
    }
    
    func set(customTexture: SKTexture?) {
        if let playerTexture = customTexture {
            texture = playerTexture
        } else {
            texture = Textures.plane4
        }
    }
    
    func spawnPlayer() {
        view = View(texture: texture)
        config()
    }
    
    deinit {
        print("bye Player Controller")
    }
    
    func configProperties() {
        view.position = CGPoint(x: parent.frame.midX, y: view.height / 2)
        view.name = "player"
        
        // chặn không cho máy bay ra khỏi màn hình
        let rangeX = SKRange(lowerLimit: 0, upperLimit: parent.size.width)
        let rangeY = SKRange(lowerLimit: 0, upperLimit: parent.size.height)
        let constraint = SKConstraint.positionX(rangeX, y: rangeY)
        view.constraints = [constraint]
    }
    
    func configPhysics() {
        view.physicsBody?.categoryBitMask = BitMask.player.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemyBullet.rawValue | BitMask.enemy.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func shootAction() {
        let addBullet: SKAction
        
        if powerLevel == 1 {
            addBullet = SKAction.run { [unowned self] in
                let bulletController = PlayerBulletController(planeController: self)
                bulletController.set(customTexture: nil)
                bulletController.spawnBullet(scale: 0.25)
            }
        } else {
            addBullet = SKAction.run { [unowned self] in
                let bulletController = PlayerMultipleBulletsController(planeController: self)
                bulletController.set(customTexture: nil)
                bulletController.spawnBullet(scale: 0.25)
            }
        }
        let delay = SKAction.wait(forDuration: self.FIRING_INTERVAL)
        self.view.run(.repeatForever(.sequence([addBullet, delay])))
    }
    
    func flyAction() {}
    
    func configOnContact() {
        view.onContact = { [weak self] (other, contact) in
            if (other as? SKNode)?.physicsBody?.categoryBitMask == BitMask.powerup.rawValue {
                self?.powerup()
                return
            }
            
            self?.hp -= 1
            if (self?.hp)! == 0 {
                // die bitch
                self?.die()
            } else {
                // máy bay cháy
                self?.ignite(at: contact)
            }
        }
    }
    
    func powerup() {
        guard powerLevel < 3 else {
            (parent as? GameScene)?.score += 30
            return }
        powerLevel += 1
        FIRING_INTERVAL = FIRING_INTERVAL * 0.75
        self.parent.run(SoundController.POWERUP)
    }
    
    func die() {
        self.view.removeFromParent()
        
        let explosionController = (self.parent as! GameScene).explosionController!
        explosionController.explode(at: (self.view)!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + explosionController.time * 1.2) {
            if let gameoverScene = SKScene(fileNamed: "GameoverScene") {
                guard let scene = self.parent else { return }
                gameoverScene.size = scene.size
                gameoverScene.scaleMode = .aspectFill
                scene.view?.presentScene(gameoverScene)
            }
        }
    }
    
    func ignite(at contact: SKPhysicsContact) {
        self.parent.run(SoundController.PLAYER_HIT)
        let emitter = SKEmitterNode(fileNamed: "Fire")
        emitter?.position = contact.contactPoint.positionRelative(to: (self.view)!)
        emitter?.targetNode = self.parent
        self.view.addChild(emitter!)
    }
    
    func move(location: CGPoint, previous: CGPoint) {
        let dx = location.x - previous.x
        let dy = location.y - previous.y
        
        let vector = CGVector(dx: dx, dy: dy)
        
        let distance = location.distance(to: previous)
        let time = Double(distance / SPEED)
        
        view.run(.move(by: vector, duration: time))
    }
}

