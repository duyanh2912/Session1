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
    
    func positionRelative(to node: SKNode) -> CGPoint {
        let x = self.x - node.position.x
        let y = self.y - node.position.y
        
        return CGPoint(x: x, y: y)
    }
    
}

extension CGRect {
    func middePoint() -> CGPoint {
        return CGPoint(x: self.midX, y:self.midY)
    }
}

extension CGSize {
    func add(dWidth: CGFloat, dHeight: CGFloat) -> CGSize {
        return CGSize(width: self.width + dWidth, height: self.height + dHeight)
    }
    
    func scaled(by ratio: CGFloat) -> CGSize {
        return CGSize(width: self.width * ratio, height: self.height * ratio)
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
    
    static func moveDiagonallyToBottomRigt(node: SKSpriteNode, parent: SKNode, speed: CGFloat) -> SKAction {
        let endingY = -node.size.height / 2
        let endingX = node.position.x + (node.position.y - endingY)
        
        let destination = CGPoint(x: endingX, y: endingY)
        let distance = destination.distance(to: node.position)
        let time = distance/speed
        
        return SKAction.move(to: destination, duration: Double(time))
    }
    
    static func moveDiagonallyToBottomLeft(node: SKSpriteNode, parent: SKNode, speed: CGFloat) -> SKAction {
        let endingY = -node.size.height / 2
        let endingX = node.position.x - (node.position.y - endingY)
        
        let destination = CGPoint(x: endingX, y: endingY)
        let distance = destination.distance(to: node.position)
        let time = distance/speed
        
        return SKAction.move(to: destination, duration: Double(time))
    }

}
