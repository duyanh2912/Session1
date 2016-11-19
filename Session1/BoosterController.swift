//
//  PowerupController.swift
//  Session1
//
//  Created by Developer on 11/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol BoosterController: Controller, Flyable {
    var SPEED: CGFloat! { get set }
    
}

extension BoosterController {
    func configActions() {
        fly()
    }
}
