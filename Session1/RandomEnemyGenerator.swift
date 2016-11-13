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
    var hardcoreMode = true {
        didSet {
            if hardcoreMode == true {
                enemyController.isTargetingPlayer = true
                enemyDiagonalController.isTargetingPlayer = true
                enemyAnimatedController.isTargetingPlayer = true
            } else {
                enemyController.isTargetingPlayer = false
                enemyDiagonalController.isTargetingPlayer = false
                enemyAnimatedController.isTargetingPlayer = false
            }
        }
    }
    let enemyController: EnemyController
    let enemyDiagonalController: EnemyDiagonalController
    let enemyAnimatedController: EnemyAnimatedController
    
    init(parent: SKScene) {
        self.parent = parent
        
        enemyController = EnemyController(parent: parent)
        enemyDiagonalController = EnemyDiagonalController(parent: parent)
        enemyAnimatedController = EnemyAnimatedController(parent: parent)
    }
    
    func generate(interval: Double) {
        let add = SKAction.run { [unowned self] in
            let i = Int(arc4random_uniform(UInt32(EnemyType.types.count)))
            switch EnemyType.types[i] {
                
            case EnemyType.enemy_green_1:
                self.enemyDiagonalController.set(isFromLeft: true)
                self.enemyDiagonalController.spawnEnemy()
                
            case EnemyType.enemy_green_2:
                self.enemyDiagonalController.set(isFromLeft: false)
                self.enemyDiagonalController.spawnEnemy()
                
            case EnemyType.enemy_plane_white_animated, EnemyType.enemy_plane_yellow_animated:
                self.enemyAnimatedController.set(customAnimation: EnemyType.types[i].rawValue)
                self.enemyAnimatedController.spawnEnemy()
                print(EnemyType.types[i].rawValue)
            
            case EnemyType.plane1:
                self.enemyController.set(customImage: #imageLiteral(resourceName: "plane1"))
                self.enemyController.spawnEnemy()
                
            default:
                self.enemyController.set(customImage: nil)
                self.enemyController.spawnEnemy()
            }
        }
        let delay = SKAction.wait(forDuration: interval)
        parent.run(.repeatForever(.sequence([add, delay])))
    }
 
    deinit {
        print("bye Random Enemy Generator")
    }
}
