//
//  ExplosionController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation
class ExplosionController: Controller, Animated {
    static let sharedInstance = ExplosionController()
    
    var texture: SKTexture!
    var view: View!
    var initialPosition: CGPoint!
    weak var parent: SKScene!
    
    let atlas = SKTextureAtlas(named: "explosion")
    var textures = [SKTexture]()
    let time: Double = 0.5
    weak var plane: View!
    
    init() {
        let textureNamesSorted = atlas.textureNames.sorted()
        for textureName in textureNamesSorted {
            textures.append(atlas.textureNamed(textureName))
        }
    }
    
    func set(parent: SKScene) {
        self.parent = parent
    }
    
    func explode(at plane: View, scale: CGFloat = 1) {
        self.plane = plane
        view = View(texture: textures[0])
        view.setScale(scale)
        config()
        parent.addChild(view)
    }
    
    func configProperties() {
        view.position = plane.position
        view.size = plane.size
    }
    
    func configPhysics() {}
    
    func configActions() {
        animate()
    }
    
    func animate() {
        let animate = SKAction.animate(
            with: textures,
            timePerFrame: time / Double(textures.count)
        )
        view.run(.sequence([animate, .removeFromParent()]))
        self.parent.run(SoundController.sharedInstance.EXPLOSION)
    }

    func configOnContact() {}
    
    deinit {
        print("bye Explosion Controller")
    }
}
