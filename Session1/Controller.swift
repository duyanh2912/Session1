//
//  Controllers.swift
//  Session1
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol Controller {
    var view: View! { get set }
    var parent: SKScene! { get set }
    
    func configProperties()
    func configPhysics()
    func configActions()
    func configOnContact()
}

extension Controller {
   func config() {
        configProperties()
        configPhysics()
        configActions()
        configOnContact()
        
        parent.addChild(view)
    }
}
