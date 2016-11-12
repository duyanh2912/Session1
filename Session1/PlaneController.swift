//
//  PlaneController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol PlaneController {
    var view: View! { get set }
    var SPEED: CGFloat! { get set }
    weak var parent: SKScene! { get set }
    var FIRING_INTERVAL: Double! { get set }
    
    init()
    
    func configProperties()
    func configBitMask()
    func runAction()
    func configOnContact()
}

extension PlaneController {
    init(parent: SKScene) {
        self.init()
        self.parent = parent
    }
    
    func config() {
        // Config Properties
        configProperties()
        
        // Plane's Physics
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size.scaled(by: 0.9))
        configBitMask()
        
        // Action
        runAction()
        
        // Config plane's onContact
        configOnContact()
        
        parent.addChild(view)
    }
}
