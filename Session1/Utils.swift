//
//  Utils.swift
//  Session1
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit
import Foundation

extension CGPoint {
    func add(other: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + other.x, y: self.y + other.y)
    }
    
    func add(x: CGFloat, y: CGFloat) -> CGPoint{
        return CGPoint(x: self.x + x, y: self.y + y)
    }
    
    func distance(to otherPoint: CGPoint) -> CGFloat {
        let dx = otherPoint.x - self.x
        let dy = otherPoint.y - self.y
        
        return sqrt(dx * dx + dy * dy)
    }
    
}

extension CGRect {
    func middePoint() -> CGPoint {
        return CGPoint(x: self.midX, y:self.midY)
    }
}

extension SKAction {
    static func moveToTop(node: SKSpriteNode, parent: SKNode, speed: CGFloat) -> SKAction {
        let distance = abs(parent.frame.height + node.size.height / 2 - node.position.y)
        let time = distance / speed
        
        return SKAction.moveTo(y: parent.frame.height + node.size.height / 2, duration: Double(time))
    }
    
    static func moveToBottom(node: SKSpriteNode, parent: SKNode, speed: CGFloat) -> SKAction {
        let distance = abs(node.position.y - node.size.height / 2)
        let time = distance / speed
        
        return SKAction.moveTo(y: -node.size.height / 2, duration: Double(time))
    }
}
