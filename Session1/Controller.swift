//
//  Controllers.swift
//  Session1
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol Controller: class, Configurable {
    var texture: SKTexture! { get set }
    var view: View! { get set }
    var initialPosition: CGPoint! { get set }
    weak var parent: SKScene! { get set }
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
        configOnContact()
        configActions()
    }
}
