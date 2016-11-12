//
//  ExplosionController.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation
class ExplosionController: Controller {
    
    let atlas = SKTextureAtlas(named: "explosion")
    var textures = [SKTexture]()
    let time: Double = 0.5
    var view: View!
    weak var plane: SKSpriteNode!
    weak var parent: SKNode!
    
    init(parent: SKNode) {
        self.parent = parent
        
        
        let textureNamesSorted = atlas.textureNames.sorted()
        for textureName in textureNamesSorted {
            textures.append(atlas.textureNamed(textureName))
        }
        
        view = View(texture: textures[0])
    }
    
    func explode(at plane: SKSpriteNode) {
        self.plane = plane
        view = View(texture: textures[0])
        config()
//        explodeAction(completion: completion)
    }
    
    func configProperties() {
        view.position = plane.position
        view.size = plane.size
    }
    
    func configPhysics() {}
    
    func configActions() {
        let animate = SKAction.animate(
            with: textures,
            timePerFrame: time / Double(textures.count)
        )
        view.run(.sequence([animate, .removeFromParent()]))
        let soundController = (parent as! GameScene).soundController
        soundController?.playSound(sound: (SoundController.EXPLOSION))
    }
    
    func explodeAction(completion: (() -> Void)?) {
        let animate = SKAction.animate(
            with: textures,
            timePerFrame: time / Double(textures.count)
        )
        if completion != nil {
            view.run(.sequence([animate, .removeFromParent()]), completion: completion!)
        } else {
            view.run(.sequence([animate, .removeFromParent()]))
        }
        let soundController = (parent as! GameScene).soundController
        soundController?.playSound(sound: (SoundController.EXPLOSION))
    }

    func configOnContact() {}
    
    deinit {
        print("bye Explosion Controller")
    }
    
   
}
