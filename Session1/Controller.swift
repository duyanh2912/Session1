//
//  Controllers.swift
//  Session1
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol Controller: class {
    var view: View! { get set }
    var parent: SKScene! { get set }
    
    func configProperties()
    func configPhysics()
    func configActions()
    func configOnContact()
}

extension Controller {
    var width: CGFloat {
        get {
            return self.view.width
        }
    }
    var height: CGFloat {
        get {
            return self.view.height
        }
    }
    var position: CGPoint {
        get {
            return self.view.position
        }
    }
    
    func config() {
        configProperties()
        configPhysics()
        configActions()
        configOnContact()
        
        parent.addChild(view)
    }
}
