//
//  GameoverScene.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class GameoverScene: SKScene {
    var replayLabel: SKLabelNode!
    
    deinit {
        print("bye GameOver Scene")
    }
    
    override func didMove(to view: SKView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
             self.run(SoundController.GAME_OVER)
        }
       
        let gameoverLabel = childNode(withName: "gameoverLabel") as! SKLabelNode
        gameoverLabel.position = frame.middePoint()
        
        replayLabel = SKLabelNode(text: "Replay")
        replayLabel.position = gameoverLabel.position.add(x: 0, y: -30)
        replayLabel.fontSize = 20
        replayLabel.name = "replayLabel"
        replayLabel.alpha = 0
        addChild(replayLabel)
        
        gameoverLabel.run(SKAction.fadeAlpha(to: 1, duration: 1)) { [unowned self] in
            self.replayLabel.run(.fadeAlpha(to: 1, duration: 0.4)) {
                self.replayLabel.run(.repeatForever(.sequence([.fadeAlpha(to: 0.2, duration: 0.4),
                                                               .fadeAlpha(to: 1, duration: 0.4)
                    ])))
            }
        }
        
        print(self.frame)
        print(view.frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        if nodes(at: location).contains(replayLabel) {
            view?.presentScene(GameScene(size: size))
        }
    }
}
