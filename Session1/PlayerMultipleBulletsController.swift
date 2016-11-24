//
//  PlayerMultipleBulletsController.swift
//  Session1
//
//  Created by Developer on 11/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class PlayerMultipleBulletsController: PlayerBulletController {
    var views = [View]()
    var angle: CGFloat! = CGFloat.pi / 48
    var scale: CGFloat!
    
    deinit {
        print("bye Player Multiple Bullets Controller")
    }
    
    func spawnBullet() {
        self.spawnBullet(scale: 1)
    }
    
    func spawnStraightBullet(scale: CGFloat = 1) {
        angle = 0
        self.spawnBullet(scale: scale)
        views[0].position = views[0].position.add(x: planeController.width / 4, y: 0)
        views[1].position = views[1].position.add(x: -planeController.width / 4, y: 0)
    }
    
    func spawnBullet(scale: CGFloat) {
        self.scale = scale
        for _ in 0...1 {
            view = View(texture: texture)
            config()
            views.append(view)
            angle = -angle
        }
        
        if (self.planeController as! PlayerController).powerLevel == 3 {
            angle = 0
            view = View(texture: texture)
            config()
            views.append(view)
        }

        for view in views {
            parent.addChild(view)
        }
        self.parent.run(SoundController.sharedInstance.PLAYER_SHOOT)
    }
    
    override func configProperties() {
        view.setScale(scale)
        view.name = "player_multiple_bullet"
        view.position = planeController.position.add(
            x: 0,
            y: planeController.height / 4
        )
        view.zRotation = angle
    }
    
    override func fly() {
        view.physicsBody?.velocity = CGVector(dx: -sin(angle) * SPEED, dy: cos(angle) * SPEED)
    }
}
