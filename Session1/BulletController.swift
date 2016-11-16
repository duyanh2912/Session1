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
    weak var planeController: PlaneController! { get set }
    
    init()
  }

extension BulletController {
    init(planeController: PlaneController) {
        self.init()
        self.planeController = planeController
        self.parent = planeController.parent
        self.planeController.activeBulletControllers.append(self)
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
    
    func configOnContact() {
        let bullet = self.view!
        
        bullet.onContact = { [unowned bullet, weak self] other in
            bullet.removeFromParent()
            self?.view = nil
            self?.removeFromPlaneController()
        }
    }
    
    func removeFromPlaneController() {
        if let index = planeController.activeBulletControllers.index(where: { $0 === self }) {
            planeController.activeBulletControllers.remove(at: index)
        }
    }
}
