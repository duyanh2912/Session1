//
//  Shootable.swift
//  Session1
//
//  Created by Developer on 11/19/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol Shootable {
    var FIRING_INTERVAL: Double! { get set }
    var activeBulletControllers: [BulletController] { get set }
    
    func shoot() 
}
