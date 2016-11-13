//
//  GameScene.swift
//  Session1
//
//  Created by Developer on 11/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate, OnContact {
    var onContact: OnContactType! = {(_) in }
    
    var playerController: PlayerController!
    var randomEnemyGenerator: RandomEnemyGenerator!
    var explosionController: ExplosionController!
    var soundController: SoundController!
        
    var hpLabel: SKLabelNode!
    var hpLabelBlock: SKSpriteNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            scoreLabelBlock.size = scoreLabel.frame.size.add(dWidth: 6, dHeight: 6)
        }
    }
    var scoreLabel: SKLabelNode!
    var scoreLabelBlock: SKSpriteNode!
    
    let TIME_BETWEEN_SPAWN: Double = 1.5
    
    deinit {
        print("bye Game Scene")
    }
    
    override func willMove(from view: SKView) {
    }
    
    override func didMove(to view: SKView) {
        addExplosionController()
        addSoundController()
        // Phải có 1 instance của SoundController nếu ko sẽ bị mất tiếng nổ
        // và tiếng ko ổn định
        configPhysics()
        addBackground()
        addPlayer()
        addEnemies()
        addHpLabel()
        addScoreLabel()
    }
    
    func addSoundController() {
        soundController = SoundController(parent: self)
    }
    
    func addExplosionController() {
        explosionController = ExplosionController(parent: self)
    }
    
    func addScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: self.size.width - 8, y: 8)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        scoreLabelBlock = SKSpriteNode(
            color: .black,
            size: scoreLabel.frame.size.add(dWidth: 6, dHeight: 6)
        )
        scoreLabelBlock.zPosition = 2
        scoreLabelBlock.alpha = 0.3
        scoreLabelBlock.anchorPoint = CGPoint(x: 1, y: 0)
        scoreLabelBlock.position = scoreLabel.position.add(x: 3, y: -3)
        addChild(scoreLabelBlock)
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
        
        nodeA.onContact(nodeB, contact)
        nodeB.onContact(nodeA, contact)
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
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = BitMask.wall.rawValue
        self.physicsBody?.collisionBitMask = 0
        
//        self.speed = 2
    }
    
    func addPlayer() {
        playerController = PlayerController(parent: self)
        playerController.set(customImage: UIImage(named: "player_image/plane4"))
        playerController.FIRING_INTERVAL = 0.2
        playerController.spawnPlayer()
    }
    
    func addEnemies() {
        randomEnemyGenerator = RandomEnemyGenerator(parent: self)
        randomEnemyGenerator.hardcoreMode = true
        randomEnemyGenerator.generate(interval: TIME_BETWEEN_SPAWN)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerController.move(touches: touches)
    }
}
