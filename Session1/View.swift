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
    var width: CGFloat {
        return self.size.width
    }
    var height: CGFloat {
        return self.size.height
    }
    
    deinit {
        print("bye View")
    }
}
