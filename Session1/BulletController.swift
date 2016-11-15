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
    
    func spawnBullet() {
        config()
    }
    
    func spawnBullet(scale: CGFloat) {
        self.view.setScale(scale)
        self.spawnBullet()
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
