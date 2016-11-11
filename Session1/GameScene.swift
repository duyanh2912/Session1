//
//  GameScene.swift
//  Session1
//
//  Created by Developer on 11/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var playerController: PlayerController!
    var hpLabel: SKLabelNode!
    var hpLabelBlock: SKSpriteNode!
    
    let TIME_BETWEEN_SPAWN: Double = 3
    
    deinit {
        print("bye Game Scene")
    }
    
    override func didMove(to view: SKView) {
        configPhysics()
        addBackground()
        addPlayer()
        addEnemies()
        addHpLabel()
    }
    
    func addHpLabel() {
        hpLabel = SKLabelNode(text: "HP: \(playerController.hp)")
        hpLabel.horizontalAlignmentMode = .left
        hpLabel.position = CGPoint(x: 8, y: 8)
        hpLabel.zPosition = 2
        hpLabel.blendMode = .replace
        hpLabel.fontColor = UIColor.white
        
        hpLabelBlock = SKSpriteNode(
            color: .black,
            size: hpLabel.frame.size.add(dWidth: 6, dHeight: 6)
        )
        hpLabelBlock.zPosition = 2
        hpLabelBlock.alpha = 0.3
        hpLabelBlock.anchorPoint = CGPoint.zero
        hpLabelBlock.position = hpLabel.position.add(x: -3, y: -3)
        
        addChild(hpLabel)
        addChild(hpLabelBlock)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? View, let nodeB = contact.bodyB.node as? View else { return
        }
        guard let onContactA = nodeA.onContact, let onContactB = nodeB.onContact else {
            return
        }
        onContactA(nodeB, contact)
        onContactB(nodeA, contact)
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
    
    func configPhysics() {
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.contactDelegate = self
    }
    
    func addPlayer() {
        playerController = PlayerController(parent: self)
        let player = playerController.view
        addChild(player)
        playerController.runAction()
    
        // chặn không cho máy bay ra khỏi màn hình
        let rangeX = SKRange(lowerLimit: 0, upperLimit: size.width)
        let rangeY = SKRange(lowerLimit: 0, upperLimit: size.height)
        let constraint = SKConstraint.positionX(rangeX, y: rangeY)
        player.constraints = [constraint]
    }
    
    func addEnemies() {
        let add = SKAction.run { [unowned self] in
            let enemyController = EnemyController(parent: self)
            self.addChild(enemyController.view)
            enemyController.runAction()
        }
        
        let delay = SKAction.wait(forDuration: TIME_BETWEEN_SPAWN)
        
        self.run(.repeatForever(.sequence([add, delay])))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            let dx = location.x - previous.x
            let dy = location.y - previous.y
            
            let vector = CGVector(dx: dx, dy: dy)
            
            let distance = location.distance(to: previous)
            let time = Double(distance / playerController.SPEED)
            
            playerController.view.run(.move(by: vector, duration: time))
        }
    }
}
