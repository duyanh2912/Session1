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
    var view: View! = View(imageNamed: "player_image/plane3")
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
    
    required init() {}
    
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
    
    func configBitMask() {
        view.physicsBody?.categoryBitMask = BitMask.player.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemyBullet.rawValue | BitMask.enemy.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func runAction() {
        let addBullet = SKAction.run { [unowned self] in
            let bulletController = PlayerBulletController(
                plane: self.view,
                parent: self.parent
            )
            
            bulletController.bullet = View(texture: self.view.texture, size: self.view.size.scaled(by: 0.25))
            bulletController.SPEED = 200
            
            bulletController.config()
        }
        
        let delay = SKAction.wait(forDuration: self.FIRING_INTERVAL)
        
        self.view.run(.repeatForever(.sequence([addBullet, delay])))
    }
    
    func configOnContact() {
        view.onContact = { [weak self] (other, contact) in
            let soundController = (self?.parent as! GameScene).soundController
            soundController?.playSound(sound: (SoundController.PLAYER_HIT))
            
            self?.hp -= 1
            
            // máy bay cháy
            let emitter = SKEmitterNode(fileNamed: "Fire")
            emitter?.position = contact.contactPoint.positionRelative(to: (self?.view)!)
            emitter?.targetNode = self?.parent
            self?.view.addChild(emitter!)
            
            // die bitch
            if self?.hp == 0 {
                self?.view.removeFromParent()
                
                let explosionController = (self?.parent as! GameScene).explosionController!
                explosionController.explode(at: (self?.view)!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + explosionController.time * 1.2) {
                if let gameoverScene = SKScene(fileNamed: "GameoverScene") {
                    guard let scene = self?.parent else { return }
                    gameoverScene.size = scene.size
                    gameoverScene.scaleMode = .aspectFill
                    scene.view?.presentScene(gameoverScene)
                    }
                }
            }
        }
    }
    
    func move(touches: Set<UITouch>) {
        if let touch = touches.first {
            let location = touch.location(in: self.parent)
            let previous = touch.previousLocation(in: self.parent)
            
            let dx = location.x - previous.x
            let dy = location.y - previous.y
            
            let vector = CGVector(dx: dx, dy: dy)
            
            let distance = location.distance(to: previous)
            let time = Double(distance / SPEED)
            
            view.run(.move(by: vector, duration: time))
        }
    }
}
