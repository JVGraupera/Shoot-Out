//
//  Player.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/17/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {//, SKPhysicsContactDelegate {
    //Use a convenience init when you want to hard code values
    init() {
        let texture = SKTexture(imageNamed: "Bad4")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.scaleTo(screenWidthPercentage: 0.075)
        self.zPosition = 2
        self.name = "hero"
        self.physicsBody = SKPhysicsBody(circleOfRadius: ScreenSize.width * 0.02)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.hero
        self.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        self.physicsBody?.collisionBitMask = PhysicsCategory.cac
        
    }

    //We need to override this to allow for class to work in SpriteKit Scene Builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    
}
