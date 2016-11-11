//
//  ExplosionController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation
class ExplosionController {
    let atlas = SKTextureAtlas(named: "explosion")
    var textures = [SKTexture]()
    let time: Double = 0.5
    let view: SKNode
    
    init(at position: CGPoint) {
        let textureNamesSorted = atlas.textureNames.sorted()
        for textureName in textureNamesSorted {
            textures.append(atlas.textureNamed(textureName))
        }
        
        view = SKSpriteNode(texture: textures[0])
        view.position = position
    }
    
    func explode() {
        let animate = SKAction.animate(
            with: textures,
            timePerFrame: time / Double(textures.count)
        )
        view.run(.sequence([animate, SKAction.removeFromParent()]))
    }
    
    deinit {
        print("bye Explosion Controller")
    }
}
