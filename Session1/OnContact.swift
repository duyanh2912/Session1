//
//  OnContact.swift
//  Session1
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

typealias OnContactType = ((_ other: OnContact, _ contact: SKPhysicsContact) -> Void)

protocol OnContact: class {
    var onContact: OnContactType? { get set }
}
