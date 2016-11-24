//
//  GiftPlaneController.swift
//  Session1
//
//  Created by Developer on 11/19/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class GiftPlaneController: PlaneController {
    var texture: SKTexture!
    var view: View!
    var initialPosition: CGPoint!
    weak var parent: SKScene!
    
    var SPEED: CGFloat! = 160
    
    func configProperties() {
        view.setScale(0.5)
        view?.name = "gift_plane"
        
        let beginX = CGFloat(drand48() * Double(parent.frame.width)) / 2
        let beginY = parent.frame.height + (view?.frame.height)! / 2
        initialPosition = CGPoint(x: beginX, y: beginY)
        view.position = initialPosition
    }
    
    init(parent: SKScene) {
        self.parent = parent
    }
    
    func set(customTexture: SKTexture?){
        if customTexture != nil {
            texture = customTexture!
        } else {
            texture = Textures.plane4
        }
    }
    
    func spawn() {
        view = View(texture: texture)
        config()
        parent.addChild(view)
    }
    
    func configPhysics() {
        view?.physicsBody?.categoryBitMask = BitMask.enemy.rawValue
        view?.physicsBody?.contactTestBitMask = BitMask.playerBullet.rawValue | BitMask.wall.rawValue
        view?.physicsBody?.collisionBitMask = 0
    }
    
    func configActions() {
        fly()
    }
    
    func fly() {
        // Fly Action
        let path = UIBezierPath()
        let firstPoint = CGPoint.zero
        path.move(to: firstPoint)
        path.addCurve(
            to: .init(x: 195 - 170, y: -236),
            controlPoint1: .init(x: 52 - 170, y: -42),
            controlPoint2: .init(x: 78 - 170, y: -232)
        )
        path.addCurve(
            to: .init(x: 215 - 170, y: -117),
            controlPoint1: .init(x: 324 - 170, y: -241),
            controlPoint2: .init(x: 308 - 170, y: -118)
        )
        path.addCurve(
            to: .init(x: 100 - 170, y: -329),
            controlPoint1: .init(x: 153 - 170, y: -117),
            controlPoint2: .init(x: 80 - 170, y: -229)
        )
        path.addCurve(
            to: CGPoint(x: (parent.size.width + self.width / 2 - self.position.x), y: -439),
            controlPoint1: .init(x: 127 - 170, y: -449),
            controlPoint2: .init(x: 300 - 170, y: -439)
        )
        view.run(.follow(path.cgPath, asOffset: true, orientToPath: true, speed: SPEED)) { [weak view] in
            view?.removeFromParent()
        }
//        view.physicsBody?.velocity = CGVector(dx: 0, dy: -SPEED)
    }
    
    func configOnContact() {
        view.onContact = { [unowned plane = self.view!, unowned parent = self.parent!] (other, _) in
            if (other as? SKNode)?.physicsBody?.categoryBitMask != BitMask.wall.rawValue {
                (parent as? GameScene)?.explosionController.explode(at: plane)
                
                let controller = LivesUpController(parent: parent)
                controller.set(position: plane.position, customSpeed: nil)
                controller.spawn()
            }
            plane.removeFromParent()
        }
    }
}
