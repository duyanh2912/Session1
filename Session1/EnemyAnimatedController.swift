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
    
    func set(customAnimation: String?) {
        if customAnimation == nil {
            atlas = SKTextureAtlas(named: "enemy_plane_white")
        } else {
            atlas = SKTextureAtlas(named: customAnimation!)
        }
        
        textures = [SKTexture]()
        let textureNamesSorted = atlas.textureNames.sorted()
        for textureName in textureNamesSorted {
            textures.append(atlas.textureNamed(textureName))
        }
        texture = textures[0]
    }
    
    func configActions() {
        
        super.configActions()
    }
    
    override func flyAction() {
        view?.run(.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.05)))
        super.flyAction()
    }
    
    deinit {
        print("bye Enemy Animated Controller")
    }
}
