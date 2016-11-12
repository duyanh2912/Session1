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
    var bullet: View! { get set }
    var SPEED: CGFloat! { get set }
    weak var parent: SKNode! { get set }
    weak var plane: View! { get set }
    
    init()
    
    func configProperties()
    func configBitMask()
    func runAction()
  }

extension BulletController {
    var width: CGFloat {
        get {
            return self.bullet.width
        }
    }
    var height: CGFloat {
        get {
            return self.bullet.height
        }
    }
    
    init(plane: View, parent: SKNode) {
        self.init()
        self.plane = plane
        self.parent = parent
    }
    
    func config() {
        // Properties
        configProperties()
        
        // Physics
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: bullet.size)
        configBitMask()
        
        // Action
        runAction()
        
        // On Contact
        configOnContact()
        
        parent.addChild(bullet)
    }
    
    func configOnContact() {
        let bullet = self.bullet!
        bullet.onContact = { [unowned bullet] other in
            bullet.removeFromParent()
        }
    }
    
    init(bulletImage: UIImage, plane: View, parent: SKScene){
        self.init(plane: plane, parent: parent)
        self.bullet = View(texture: SKTexture(image: bulletImage))
    }
}
