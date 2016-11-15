//
//  SoundController.swift
//  Session1
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit

class SoundController {
    static let PLAYER_SHOOT = SKAction.playSoundFileNamed("player_shoot", waitForCompletion: false)
    static let ENEMY_SHOOT = SKAction.playSoundFileNamed("enemy_shoot", waitForCompletion: false)
    static let EXPLOSION = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)
    static let PLAYER_HIT = SKAction.playSoundFileNamed("player_hit", waitForCompletion: false)
    static let GAME_OVER = SKAction.playSoundFileNamed("game_over", waitForCompletion: false)
    static let POWERUP = SKAction.playSoundFileNamed("powerup", waitForCompletion: false)
    
    static let sharedInstance = SoundController()
    
    deinit {
        print("bye Sound Controller")
    }
}
