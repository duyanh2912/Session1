//
//  GameScene.swift
//  Session1
//
//  Created by Developer on 11/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var player: SKSpriteNode!
    var numberOfEnemies = 0
    
    let PLAYER_SPEED: CGFloat = 80
    let PLAYER_BULLET_SPEED: CGFloat = 200
    let PLAYER_FIRING_INTERVAL = 0.2
    
    let TIME_BETWEEN_SPAWN: Double = 3
    
    let ENEMY_SPEED: CGFloat = 80
    let ENEMY_BULLET_SPEED: CGFloat = 200
    let ENEMY_FIRING_INTERVAL = 0.8
    
    override func didMove(to view: SKView) {
        addBackground()
        addPlayer()
        addEnemies()
    }
    
    func addBackground() {
        let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "background")))
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
    }
    
    func addPlayer() {
        player = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "plane3")))
        player.position = CGPoint(x: size.width / 2, y: player.size.height / 2)
        player.name = "player"
        addChild(player)
        
        self.run(addBullet(for: player))
    
        // chặn không cho máy bay ra khỏi màn hình
        let rangeX = SKRange(lowerLimit: 0, upperLimit: size.width)
        let rangeY = SKRange(lowerLimit: 0, upperLimit: size.height)
        let constraint = SKConstraint.positionX(rangeX, y: rangeY)
        
        player.constraints = [constraint]
    }
    
    func addEnemies() {
        let add = SKAction.run { [unowned self] in
            let enemyImage = #imageLiteral(resourceName: "enemy-green-3")
            
            let x = CGFloat(drand48() * Double(self.size.width))
            let y = self.size.height + enemyImage.size.height / 2
            
            self.addEnemy(image: enemyImage, position: CGPoint(x: x, y: y), destination: CGPoint(x: x, y: -enemyImage.size.height / 2))
        }
        
        let delay = SKAction.wait(forDuration: TIME_BETWEEN_SPAWN)
        
        self.run(.repeatForever(.sequence([add, delay])))
    }
    
    func addEnemy(image enemyImage: UIImage, position: CGPoint, destination: CGPoint) {
        let enemy = SKSpriteNode(texture: SKTexture(image: enemyImage))
        enemy.position = position
        enemy.name = "enemy1"
        addChild(enemy)
        numberOfEnemies += 1
        
        let key = "enemyFire\(numberOfEnemies)"
        self.run(addBullet(for: enemy), withKey: key)
        
        let dx = destination.x - position.x
        let dy = destination.y - position.y
        
        let distance = sqrt(dx * dx + dy * dy)
        let time = Double(distance / ENEMY_SPEED)
        
        let move = SKAction.move(to: destination, duration: time)
        let disappear = SKAction.run { [unowned self] in
            enemy.removeFromParent()
            self.removeAction(forKey: key)
        }
        
        enemy.run(.sequence([move, disappear]))
    }
    
    func addBullet(for plane: SKSpriteNode) -> SKAction {
        
        var bulletImage: UIImage
        var bulletSpeed: CGFloat
        var bulletDestination: CGFloat
        var firingInterval: Double
        
        switch plane.name! {
            case "player":
                bulletImage = #imageLiteral(resourceName: "bullet-single")
                bulletSpeed = PLAYER_BULLET_SPEED
                bulletDestination = size.height + bulletImage.size.height / 2
                firingInterval = PLAYER_FIRING_INTERVAL
            
            default:
                bulletImage = #imageLiteral(resourceName: "bullet-round")
                bulletSpeed = ENEMY_BULLET_SPEED
                bulletDestination = -bulletImage.size.height / 2
                firingInterval = ENEMY_FIRING_INTERVAL
        }
        
        let fireBullet = SKAction.run { [unowned self] in
            
            let bullet = SKSpriteNode(texture: SKTexture(image: bulletImage))
            
            if plane.name == "player" {
                bullet.position = CGPoint(x: plane.position.x, y: plane.position.y + plane.size.height / 2 + bullet.size.height / 2)
            } else {
                bullet.position = CGPoint(x: plane.position.x, y: plane.position.y - plane.size.height / 2 - bullet.size.height / 2)            }
            
            let distance = abs(bulletDestination - bullet.position.y)
            let time = Double(distance / bulletSpeed)
            
            let move = SKAction.moveTo(y: bulletDestination, duration: time)
            let disappear = SKAction.run {
                bullet.removeFromParent()
            }
            
            self.addChild(bullet)
            bullet.run(.sequence([move, disappear]))
        }
        
        let delay = SKAction.wait(forDuration: firingInterval)
        
        return SKAction.repeatForever(.sequence([fireBullet, delay]))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            let dx = location.x - previous.x
            let dy = location.y - previous.y
            
            let vector = CGVector(dx: dx, dy: dy)
            
            let distance = sqrt(dx * dx + dy * dy)
            let time = Double(distance / PLAYER_SPEED)
            
            player.run(.move(by: vector, duration: time))
        }
    }
}
