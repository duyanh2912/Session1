//
//  PlaneController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol PlaneController: Controller, Flyable {
    var SPEED: CGFloat! { get set }
}

extension PlaneController {
    func config() {
        // Config Properties
        configProperties()
        
        // Plane's Physics
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size.scaled(by: 0.9))
        view.physicsBody?.linearDamping = 0
        configPhysics()
        
        // Action
        configActions()
        
        // Config plane's onContact
        configOnContact()
    }
    
    func spawn() {
        view = View(texture: texture)
        config()
        parent.addChild(view)
    }
}
