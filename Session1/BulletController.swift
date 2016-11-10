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
    var view: SKSpriteNode { get }
    var SPEED: CGFloat { get }
    var parent: SKNode! { get set }
    var plane: SKSpriteNode! { get set }
    
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
        
    }
}
