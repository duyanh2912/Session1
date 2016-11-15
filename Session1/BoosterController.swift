//
//  PowerupController.swift
//  Session1
//
//  Created by Developer on 11/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol BoosterController: Controller {
    var view: View! { get set }
    var parent: SKScene! { get set }
    var initialPosition: CGPoint! { get set }
    var SPEED: CGFloat { get set }
}

extension BoosterController {
    
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
        let booster = self.view!
        booster.onContact = { [unowned booster] other in
            booster.removeFromParent()
        }
    }
}
