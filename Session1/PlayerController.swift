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
    var view: View = View(imageNamed: "player_image/plane3")
    var SPEED: CGFloat! = 80
    weak var parent: SKNode!
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
        view.position = CGPoint(x: parent.frame.midX, y: view.size.height / 2)
        view.name = "player"
    }
    
    func configBitMask() {
        view.physicsBody?.categoryBitMask = BitMask.player.rawValue
        view.physicsBody?.contactTestBitMask = BitMask.enemyBullet.rawValue
        view.physicsBody?.collisionBitMask = 0
    }
    
    func runAction() {
//        let plane = self.view
//        let closureParent = self.parent
        
        let addBullet = SKAction.run { [unowned self] in
            let bulletController = PlayerBulletController(plane: self.view, parent: self.parent)
            self.parent.addChild(bulletController.view)
            bulletController.runAction()
        }
        let delay = SKAction.wait(forDuration: self.FIRING_INTERVAL)
        
        self.view.run(.repeatForever(.sequence([addBullet, delay])))
    }
    
    func configOnContact() {
        view.onContact = { [weak self] (other, contact) in
            self?.hp -= 1
            
            // máy bay cháy
            let emitter = SKEmitterNode(fileNamed: "Fire")
            emitter?.position = contact.contactPoint.positionRelative(to: (self?.view)!)
            emitter?.targetNode = self?.parent
            self?.view.addChild(emitter!)
            
            // die bitch
            if self?.hp == 0 {
                if let gameoverScene = SKScene(fileNamed: "GameoverScene") {
                    guard let scene = self?.parent as? GameScene else { return }
                    gameoverScene.size = scene.size
                    gameoverScene.scaleMode = .aspectFill
                    scene.view?.presentScene(gameoverScene)
                }
            }
        }
    }
}

