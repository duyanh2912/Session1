//
//  Constants.swift
//  Session1
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation

enum BitMask: UInt32 {
    case player = 1
    case playerBullet = 2
    case enemy = 4
    case enemyBullet = 8
    
}

enum EnemyType: String {
    case enemy_plane_white_animated = "enemy_plane_white"
    case enemy_plane_yellow_animated = "enemy_plane_yellow"
    case enemy_green_3 = "enemy-green-3"
    case enemy_green_2 = "enemy-green-2"
    case enemy_green_1 = "enemy-green-1"
    
    static let types = [enemy_plane_white_animated,
                        enemy_plane_yellow_animated,
                        enemy_green_3,
                        enemy_green_2,
                        enemy_green_1]
}
