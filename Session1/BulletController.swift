//
//  BulletController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol BulletController: Controller {
    var texture: SKTexture! { get set }
    var view: View! { get set }
    var SPEED: CGFloat! { get set }
    weak var parent: SKScene! { get set }
    weak var plane: View! { get set }
    
    init()
  }

extension BulletController {
    init(parent: SKScene) {
        self.init()
        self.parent = parent
    }
    
    mutating func spawnBullet(of plane: View) {
        view = View(texture: texture)
        self.plane = plane
        config()
        view = nil
    }
    
    mutating func spawnBullet(of plane: View, scale: CGFloat) {
        view = View(texture: texture)
        view.setScale(scale)
        self.plane = plane
        config()
        view = nil
    }
    
    func config() {
        // Properties
        configProperties()
        
        // Physics
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        configPhysics()
        
        // Action
        configActions()
        
        // On Contact
        configOnContact()
        
        parent.addChild(view)
    }
    
    func configOnContact() {
        let bullet = self.view!
        bullet.onContact = { [unowned bullet] other in
            bullet.removeFromParent()
        }
    }
}
