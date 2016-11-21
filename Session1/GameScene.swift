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
    var audioPlayer: AVAudioPlayer?
    var onContact: OnContactType? = nil
    let fontSize: CGFloat = 30
    
    let TIME_BETWEEN_SPAWN: Double = 1.5
    
    var hardcoreMode = false {
        didSet {
            randomEnemyGenerator.hardcoreMode = self.hardcoreMode
            if hardcoreMode {
                hardcoreLabel.text = "Hardcore: on"
            } else {
                hardcoreLabel.text = "Hardcore: off"
            }
            hardcoreLabelBlock.size = hardcoreLabel.frame.size.add(dWidth: 6, dHeight: 6)
            
            if hardcoreMode == true {
                LuckRate.powerup /= 2
            } else {
                LuckRate.powerup *= 2
            }
        }
    }
    var hardcoreLabel: SKLabelNode!
    var hardcoreLabelBlock: SKSpriteNode!
    
    var playerController: PlayerController!
    var randomEnemyGenerator: RandomEnemyGenerator!
    var explosionController: ExplosionController!
    var soundController: SoundController = SoundController.sharedInstance
    
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
    
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    
    deinit {
        print("bye Game Scene")
        if hardcoreMode {
            LuckRate.powerup *= 2
        }
        
        PlayerController.sharedInstance.reset()
    }
    
    override func willMove(from view: SKView) {
    }
    
    override func didMove(to view: SKView) {
        playMusic()
        addExplosionController()
        configPhysics()
        addBackground()
        addPlayer()
        addEnemies()
        addHpLabel()
        addScoreLabel()
        addHardcoreLabel()
    }
    
    func playMusic() {
        if let path = Bundle.main.url(forResource: "background", withExtension: "mp3") {
            print("music")
            audioPlayer = try! AVAudioPlayer(contentsOf: path)
            audioPlayer?.volume = 1
            audioPlayer?.play()
        }
    }
    
    func addExplosionController() {
        explosionController = ExplosionController.sharedInstance
        explosionController.set(parent: self)
    }
    
    func addHardcoreLabel() {
        hardcoreLabel = SKLabelNode(text: "Hardcore: off")
        hardcoreLabel.fontSize = self.fontSize
        hardcoreLabel.horizontalAlignmentMode = .left
        hardcoreLabel.verticalAlignmentMode = .top
        hardcoreLabel.position = CGPoint(x: 8, y: self.size.height - 8)
        hardcoreLabel.zPosition = 2
        hardcoreLabel.blendMode = .replace
        hardcoreLabel.fontColor = UIColor.white
        
        hardcoreLabelBlock = SKSpriteNode(
            color: .black,
            size: hardcoreLabel.frame.size.add(dWidth: 6, dHeight: 6)
        )
        hardcoreLabelBlock.zPosition = 2
        hardcoreLabelBlock.alpha = 0.3
        hardcoreLabelBlock.anchorPoint = CGPoint(x: 0, y: 1)
        hardcoreLabelBlock.position = hardcoreLabel.position.add(x: -3, y: 3)
        
        addChild(hardcoreLabel)
        addChild(hardcoreLabelBlock)
        
    }
    
    func addScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontSize = self.fontSize
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
        hpLabel.fontSize = self.fontSize
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
        guard let nodeA = contact.bodyA.node as? OnContact, let nodeB = contact.bodyB.node as? OnContact else { return }
        
        nodeA.onContact?(nodeB, contact)
        nodeB.onContact?(nodeA, contact)
    }
    
    func addBackground() {
        background1 = SKSpriteNode(imageNamed: "background")
        background2 = SKSpriteNode(imageNamed: "background")
        let widthRatio = background1.size.width / size.width
        let heightRatio = background1.size.height / size.height
        let ratio = min(widthRatio, heightRatio)
        
        background1.xScale = 1/ratio
        background1.yScale = 1/ratio
        
        background2.xScale = 1/ratio
        background2.yScale = 1/ratio
        
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint.zero
        background1.zPosition = -20
        self.addChild(background1)
        
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: 0, y: background1.size.height - 1)
        background2.zPosition = -20
        self.addChild(background2)
        
        background1.blendMode = .replace
        background2.blendMode = .replace
    }
    
    override func update(_ currentTime: TimeInterval) {
        background1.position = CGPoint(x: background1.position.x, y: background1.position.y - 1)
        background2.position = CGPoint(x: background2.position.x, y: background2.position.y - 1)
        
        if background1.position.y < -background1.size.height
        {
            background1.position = CGPoint(
                x: 0,
                y: background1.position.y + 2 * background2.size.height - 2
            )
        }
        
        if background2.position.y < -background2.size.height
        {
            background2.position = CGPoint(
                x: 0,
                y: background2.position.y + 2 * background1.size.height - 2
            )
        }
    }
    
    func configPhysics() {
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame.insetBy(
            dx: size.width * -0.15,
            dy: size.height * -0.15)
        )
        self.physicsBody?.categoryBitMask = BitMask.wall.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        //        self.speed = 2
    }
    
    func addPlayer() {
        playerController = PlayerController.sharedInstance
        playerController.set(parent: self)
        playerController.spawnPlayer()
    }
    
    func addEnemies() {
        randomEnemyGenerator = RandomEnemyGenerator(parent: self)
        randomEnemyGenerator.generate(interval: TIME_BETWEEN_SPAWN)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            playerController.move(location: location, previous: previous)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if nodes(at: (touches.first?.location(in: self))!).contains(hardcoreLabelBlock) {
            hardcoreMode = !hardcoreMode
            return
        }
        if touches.count == 2 {
            hardcoreMode = !hardcoreMode
        }
    }
}
