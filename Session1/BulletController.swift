//
//  BulletController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol BulletController {
    var view: View { get }
    var SPEED: CGFloat { get set }
    weak var parent: SKNode! { get set }
    weak var plane: SKSpriteNode! { get set }
    
    init()
    
    func configProperties()
    func configBitMask()
    func runAction()
  }

extension BulletController {
    init(plane: SKSpriteNode, parent: SKNode) {
        self.init()
        
        // Configure properties
        self.plane = plane
        self.parent = parent
        configProperties()
        
        // Physics
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        configBitMask()
        
        // Config Bullet's onContact
        configOnContact()
        
    }
    
    func configOnContact() {
        let bullet = self.view
        bullet.onContact = { [unowned bullet] other in
            bullet.removeFromParent()
        }
    }
}
