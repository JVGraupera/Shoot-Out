//
//  Power.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/18/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Power: SKSpriteNode {
    init(pos: CGPoint) {
        super.init(texture: nil, color: .clear, size: CGSize(width: ScreenSize.width * 0.1, height: ScreenSize.width * 0.1))
        self.position = pos
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ScreenSize.width * 0.05, height: ScreenSize.width * 0.05))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.power
        self.physicsBody?.contactTestBitMask = PhysicsCategory.hero
        self.physicsBody?.collisionBitMask = PhysicsCategory.hero
        let chance = Int.random(in: 0...2)
        if (chance == 0) {
            self.texture = SKTexture(imageNamed: "Speed")
            self.name = "speed"
        }
        if (chance == 1){
            self.texture = SKTexture(imageNamed: "immune")
            self.name = "immune"
        }
        if (chance == 2) {
            self.texture = SKTexture(imageNamed: "deadEye")
            self.name = "deadEye"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
