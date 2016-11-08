//
//  GameScene.swift
//  Session1
//
//  Created by Developer on 11/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene {
    var player: SKSpriteNode!
    var numberOfEnemies = 0
    
    let PLAYER_SPEED: CGFloat = 80
    let PLAYER_BULLET_SPEED: CGFloat = 300
    let PLAYER_FIRING_INTERVAL = 0.1
    
    let TIME_BETWEEN_SPAWN: Double = 1
    
    let ENEMY_SPEED: CGFloat = 80
    let ENEMY_BULLET_SPEED: CGFloat = 200
    let ENEMY_FIRING_INTERVAL = 1.2
    
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
    
    override func didMove(to view: SKView) {
        addBackground()
        addPlayer()
        addEnemies()
    }
    
    func addBackground() {
        let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "background")))
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        
        let widthRatio = background.size.width / size.width
        let heightRatio = background.size.height / size.height
        let ratio = min(widthRatio, heightRatio)
        background.xScale = 1/ratio
        background.yScale = 1/ratio
        
        addChild(background)
    }
    
    func addPlayer() {
        guard var path = Bundle.main.resourcePath else { return }
        path.append("/player_image")
        let contents = (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? [String]()
        let index = Int(arc4random_uniform(UInt32(contents.count)))
        
        player = SKSpriteNode(imageNamed: "player_image/\(contents[index])")
        player.position = CGPoint(x: size.width / 2, y: player.size.height / 2)
        player.name = "player"
        addChild(player)
        
        player.run(addBullet(for: player))
    
        // chặn không cho máy bay ra khỏi màn hình
        let rangeX = SKRange(lowerLimit: 0, upperLimit: size.width)
        let rangeY = SKRange(lowerLimit: 0, upperLimit: size.height)
        let constraint = SKConstraint.positionX(rangeX, y: rangeY)
        
        player.constraints = [constraint]
    }
    
    func addEnemies() {
        let add = SKAction.run { [unowned self] in
            let i = Int(arc4random_uniform(UInt32(EnemyType.types.count)))
            self.addEnemyOf(type: EnemyType.types[i])
        }
        
        let delay = SKAction.wait(forDuration: TIME_BETWEEN_SPAWN)
        
        self.run(.repeatForever(.sequence([add, delay])))
    }
    
    func addEnemyOf(type: EnemyType) {
        let texture: SKTexture
        var atlas: SKTextureAtlas? = nil
        var destination: CGPoint? = nil
        let name = type.rawValue
    
        var beginX = CGFloat(drand48() * Double(self.size.width))
        var beginY: CGFloat? = nil
        
        switch type {
        case .enemy_green_3:
            texture = SKTexture(imageNamed: name)
           
        case .enemy_plane_white_animated, .enemy_plane_yellow_animated:
            atlas = SKTextureAtlas(named: name)
            texture = (atlas?.textureNamed((atlas?.textureNames[0])!))!
            
        case .enemy_green_2, .enemy_green_1:
            texture = SKTexture(imageNamed: name)
            let destinationY: CGFloat = -texture.size().height / 2
            let destinationX: CGFloat
            
            beginY = CGFloat(drand48()) * size.height / 2 + size.height / 2 + texture.size().height / 2
            
            if type == .enemy_green_1 {
                beginX = -texture.size().width / 2
                destinationX = beginX + beginY! - destinationY
            } else {
                beginX = size.width + texture.size().width / 2
                destinationX = beginX - beginY! + destinationY
            }
          
            destination = CGPoint(x: destinationX, y: destinationY)
        }
       
        if beginY == nil {
            beginY = self.size.height + texture.size().height / 2
        }

        let enemy = SKSpriteNode(texture: texture)
        enemy.position = CGPoint(x: beginX, y: beginY!)
        enemy.name = name
        
        if destination == nil {
            destination = CGPoint(x: beginX, y: -enemy.size.height / 2)
        }
        
        if atlas != nil {
            var frames = [SKTexture]()
            for name in (atlas?.textureNames)! {
                frames.append((atlas?.textureNamed(name))!)
            }
            enemy.run(.repeatForever(.animate(with: frames, timePerFrame: 0.05)))
        }
        
        addChild(enemy)
        numberOfEnemies += 1
    
        enemy.run(addBullet(for: enemy))
        
        let dx = (destination?.x)! - beginX
        let dy = (destination?.y)! - beginY!
        
        let distance = sqrt(dx * dx + dy * dy)
        let time = Double(distance / ENEMY_SPEED)
        let vector = CGVector(dx: dx, dy: dy)
        
        let move = SKAction.move(by: vector, duration: time)
        let disappear = SKAction.run {
            enemy.removeFromParent()
        }
        
        enemy.run(.sequence([move, disappear]))
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
        var bulletPositionX: CGFloat = 0
        var bulletPositionY: CGFloat = 0
        var bulletDestinationX: CGFloat = 0
        var bulletDestinationY: CGFloat = 0
        var firingInterval: Double
        
        switch plane.name! {
            case "player":
                bulletImage = #imageLiteral(resourceName: "bullet-single")
                bulletSpeed = PLAYER_BULLET_SPEED
                firingInterval = PLAYER_FIRING_INTERVAL
            
            default:
                bulletImage = #imageLiteral(resourceName: "bullet-round")
                bulletSpeed = ENEMY_BULLET_SPEED
                firingInterval = ENEMY_FIRING_INTERVAL
        }
        
        let fireBullet = SKAction.run { [unowned self] in
            switch plane.name! {
            case "player":
                bulletPositionX = plane.position.x
                bulletPositionY = plane.position.y + plane.size.height / 2 + bulletImage.size.height / 2
                
                bulletDestinationX = plane.position.x
                bulletDestinationY = self.size.height + bulletImage.size.height / 2
            
            case EnemyType.enemy_green_1.rawValue, EnemyType.enemy_green_2.rawValue :
                bulletPositionY = plane.position.y - plane.size.height / 2 - bulletImage.size.height / 2
                bulletDestinationY = -bulletImage.size.height / 2
                
                if plane.name! == EnemyType.enemy_green_1.rawValue {
                    bulletPositionX = plane.position.x + plane.size.width / 2 + bulletImage.size.width / 2
                    bulletDestinationX = bulletPositionX + bulletPositionY - bulletDestinationY
                } else {
                    bulletPositionX = plane.position.x - plane.size.width / 2 - bulletImage.size.width / 2
                    bulletDestinationX = bulletPositionX - bulletPositionY + bulletDestinationY
                }

            default:
                bulletPositionX = plane.position.x
                bulletPositionY = plane.position.y - plane.size.height / 2
                
                bulletDestinationX = plane.position.x
                bulletDestinationY = -bulletImage.size.height / 2
            }
            
            let bullet = SKSpriteNode(texture: SKTexture(image: bulletImage))
            bullet.position = CGPoint(x: bulletPositionX, y: bulletPositionY)
            
            let dx = bulletDestinationX - bulletPositionX
            let dy = bulletDestinationY - bulletPositionY
            let distance = sqrt(dx * dx + dy * dy)
            let time = Double(distance / bulletSpeed)
            
            let move = SKAction.move(to: CGPoint(x: bulletDestinationX, y: bulletDestinationY), duration: time)
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
