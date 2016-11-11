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
    var view: View { get set }
    var SPEED: CGFloat! { get set }
    weak var parent: SKNode! { get set }
    var FIRING_INTERVAL: Double! { get set }
    
    init()
    
    func configProperties()
    func configBitMask()
    func runAction()
    func configOnContact()
}

extension PlaneController {
    init(parent: SKNode) {
        self.init()
        
        // Config Properties
        self.parent = parent
        configProperties()
        
        // Plane's bitmask
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size.scaled(by: 0.9))
        configBitMask()
        
        // Config plane's onContact
        configOnContact()
        
    }
}
