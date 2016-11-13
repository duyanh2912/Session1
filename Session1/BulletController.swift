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
    var view: View! { get set }
    var SPEED: CGFloat! { get set }
    weak var parent: SKScene! { get set }
    weak var plane: View! { get set }
    
    init()
  }

extension BulletController {
    init(plane: View, parent: SKScene) {
        self.init()
        self.plane = plane
        self.parent = parent
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
