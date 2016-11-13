//
//  OnContact.swift
//  Session1
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

typealias OnContactType = ((_ other: View, _ contact: SKPhysicsContact) -> Void)

protocol OnContact {
    var onContact: OnContactType? { get set }
}
