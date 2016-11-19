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
                (enemyController as? EnemyController)?.isTargetingPlayer = self.hardcoreMode
            }
        }
    }
    static var activeEnemyControllers = [PlaneController]()
    
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
            var enemyController: PlaneController
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
            
            case EnemyType.enemy_green_3:
                enemyController = EnemyController(parent: self.parent)
                (enemyController as! EnemyController).set(customTexture: nil)
                
            default:
                enemyController = GiftPlaneController(parent: self.parent)
                (enemyController as! GiftPlaneController).set(customTexture: nil)
            }
            
            (enemyController as? EnemyController)?.isTargetingPlayer = self.hardcoreMode
            if self.hardcoreMode {
                (enemyController as? EnemyController)?.FIRING_INTERVAL = ((enemyController as? EnemyController)?.FIRING_INTERVAL)! / 2
            }
            enemyController.spawn()
        }
        let delay = SKAction.wait(forDuration: interval)
        parent.run(.repeatForever(.sequence([add, delay])))
    }

}
