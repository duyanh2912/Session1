//
//  RandomEnemyGenerator.swift
//  Session1
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class RandomEnemyGenerator {
    weak var parent: SKScene!
    var hardcoreMode = false {
        didSet {
            for enemyController in RandomEnemyGenerator.activeEnemyControllers {
                enemyController.isTargetingPlayer = self.hardcoreMode
            }
        }
    }
    static var activeEnemyControllers = [EnemyController]()
    
    deinit {
        print("bye Random Enemy Generator")
        RandomEnemyGenerator.activeEnemyControllers.removeAll()
    }
    
    init(parent: SKScene) {
        self.parent = parent
    }
    
    func generate(interval: Double) {
        let add = SKAction.run { [unowned self] in
            let i = Int(arc4random_uniform(UInt32(EnemyType.types.count)))
            let enemyController: EnemyController
            switch EnemyType.types[i] {
                
            case EnemyType.enemy_green_1:
                enemyController = EnemyDiagonalController(parent: self.parent)
                (enemyController as! EnemyDiagonalController).set(isFromLeft: true)
                
            case EnemyType.enemy_green_2:
                enemyController = EnemyDiagonalController(parent: self.parent)
                (enemyController as! EnemyDiagonalController).set(isFromLeft: false)
                
            case EnemyType.enemy_plane_white_animated, EnemyType.enemy_plane_yellow_animated:
                enemyController = EnemyAnimatedController(parent: self.parent)
                (enemyController as! EnemyAnimatedController).set(customAnimation: EnemyType.types[i].rawValue)
            
            case EnemyType.plane1:
                enemyController = EnemyController(parent: self.parent)
                enemyController.set(customTexture: Textures.plane1)
                
            default:
                enemyController = EnemyController(parent: self.parent)
                enemyController.set(customTexture: nil)
            }
            enemyController.isTargetingPlayer = self.hardcoreMode
            if self.hardcoreMode {
                enemyController.FIRING_INTERVAL = enemyController.FIRING_INTERVAL / 2
            }
            enemyController.spawnEnemy()
            
        }
        let delay = SKAction.wait(forDuration: interval)
        parent.run(.repeatForever(.sequence([add, delay])))
    }

}
