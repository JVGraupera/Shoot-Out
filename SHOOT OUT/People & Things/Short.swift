//
//  Short.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/17/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Short: SKSpriteNode {
    init(X: Double, Y: Double) {
       let texture = SKTexture(imageNamed: "short")
       super.init(texture: texture, color: .clear, size: texture.size())
       self.size = CGSize(width: 100, height: 100)
       self.position = CGPoint(x: X, y: Y)
       self.scaleTo(screenWidthPercentage: 0.07)
       self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
       self.physicsBody?.affectedByGravity = false
       self.physicsBody?.categoryBitMask = PhysicsCategory.short
       self.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
       self.physicsBody?.collisionBitMask = PhysicsCategory.cac
       self.physicsBody?.isDynamic = false
       self.name = "short"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
