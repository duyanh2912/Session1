//
//  View.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit

typealias OnContactType = ((_ other: View, _ contact: SKPhysicsContact) -> Void)

class View: SKSpriteNode {
    
    var onContact : OnContactType?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    deinit {
        print("bye View")
    }
}
