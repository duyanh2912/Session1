//
//  EnemyAnimatedController.swift
//  Session1
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation
class EnemyAnimatedController: EnemyController {
    var textures = [SKTexture]()
    var atlas: SKTextureAtlas!
    
    convenience init(imageName: String, parent: SKScene) {
        self.init()
        self.parent = parent
        
        atlas = SKTextureAtlas(named: imageName)
        textures = [SKTexture]()
        
        let textureNamesSorted = atlas.textureNames.sorted()
        for textureName in textureNamesSorted {
            textures.append(atlas.textureNamed(textureName))
        }
        
        view = View(texture: textures[0])
    }
    
    override func runAction() {
        view.run(.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.05)))
        super.runAction()
    }
    
    required init() {}
}
