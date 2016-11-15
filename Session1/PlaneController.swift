//
//  PlaneController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol PlaneController: Controller {
    var view: View! { get set }
    var texture: SKTexture! { get set }
    var SPEED: CGFloat! { get set }
    weak var parent: SKScene! { get set }
    var FIRING_INTERVAL: Double! { get set }
    var activeBulletControllers: [BulletController] { get set }
    
    func flyAction()
    func shootAction()
}

extension PlaneController {
    func config() {
        // Config Properties
        configProperties()
        
        // Plane's Physics
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size.scaled(by: 0.9))
        configPhysics()
        
        // Action
        configActions()
        
        // Config plane's onContact
        configOnContact()
        
        parent.addChild(view)
    }
    
    func configActions() {
        flyAction()
        shootAction()
    }
}
