//
//  BulletController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol BulletController: Controller, Flyable {
    var SPEED: CGFloat! { get set }
    weak var planeController: PlaneController! { get set }
    
    init()
}

extension BulletController {
    init(planeController: PlaneController) {
        self.init()
        self.planeController = planeController
        self.parent = planeController.parent
        
        var shootable = planeController as! Shootable
        shootable.activeBulletControllers.append(self)
    }
    
    func spawnBullet(scale: CGFloat = 1) {
        self.view = View(texture: texture)
        self.view.setScale(scale)
        config()
        parent.addChild(view)
    }
    
    func config() {
        // Properties
        view.zPosition = -1
        configProperties()
        
        // Physics
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        view.physicsBody?.linearDamping = 0
        configPhysics()
        
        // Action
        configActions()
        
        // On Contact
        configOnContact()
    }
    
    func configActions() {
        fly()
    }
    
    func configOnContact() {
        let bullet = self.view!
        
        bullet.onContact = { [unowned bullet, weak self] other in
            bullet.removeFromParent()
            self?.view = nil
            self?.removeFromPlaneController()
        }
    }
    
    func removeFromPlaneController() {
        var shootable = planeController as! Shootable
        if let index = shootable.activeBulletControllers.index(where: { $0 === self }) {
            shootable.activeBulletControllers.remove(at: index)
        }
    }
}
