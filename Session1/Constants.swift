//
//  Constants.swift
//  Session1
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

struct LuckRate {
    // Luck rate is 1/ n
    static var powerup: UInt32 = 10
}

struct BitMask: OptionSet {
    let rawValue: UInt32
    
    static let player = BitMask(rawValue: 1 << 0)
    static let playerBullet = BitMask(rawValue: 1 << 1)
    static let enemy = BitMask(rawValue: 1 << 2)
    static let enemyBullet = BitMask(rawValue: 1 << 3)
    static let wall = BitMask(rawValue: 1 << 4)
    static let powerup = BitMask(rawValue: 1 << 5)
    static let livesUp = BitMask(rawValue: 1 << 6)
}

struct Textures {
    static let sharedInstance = Textures()
    
    static let bullet_single = SKTexture(image: #imageLiteral(resourceName: "bullet-single"))
    static let bullet_round = SKTexture(image: #imageLiteral(resourceName: "bullet-round"))
    static let bullet_double = SKTexture(image: #imageLiteral(resourceName: "bullet-double"))
    
    static let enemy_green_1 = SKTexture(image: #imageLiteral(resourceName: "enemy_green_1"))
    static let enemy_green_2 = SKTexture(image: #imageLiteral(resourceName: "enemy_green_2"))
    static let enemy_green_3 = SKTexture(image: #imageLiteral(resourceName: "enemy_green_3"))
    static let plane1 = SKTexture(image: #imageLiteral(resourceName: "plane1"))
    
    static let plane2 = SKTexture(imageNamed: "player_image/plane2")
    static let plane3 = SKTexture(imageNamed: "player_image/plane3")
    static let plane4 = SKTexture(imageNamed: "player_image/plane4")
    
    static let powerup = SKTexture(image: #imageLiteral(resourceName: "200px-FireFlowerMK8"))
    static let lives_up = SKTexture(image: #imageLiteral(resourceName: "1_up"))
}

enum EnemyType: String {
    case enemy_plane_white_animated = "enemy_plane_white"
    case enemy_plane_yellow_animated = "enemy_plane_yellow"
    case enemy_green_3 = "enemy_green_3"
    case enemy_green_2 = "enemy_green_2"
    case enemy_green_1 = "enemy_green_1"
    case plane1 = "plane1"
    
    static let types = [enemy_plane_white_animated,
                        enemy_plane_yellow_animated,
                        enemy_green_3,
                        enemy_green_2,
                        enemy_green_1,
                        plane1]
}
