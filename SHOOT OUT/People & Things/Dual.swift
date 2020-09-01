//
//  Dual.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/18/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Dual: SKSpriteNode {
    init(X: Double, Y: Double) {
      let texture = SKTexture(imageNamed: "Dual2.0")
      super.init(texture: texture, color: .clear, size: texture.size())
      self.position = CGPoint(x: X, y: Y)
      self.scaleTo(screenWidthPercentage: 0.07)
      self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
      self.physicsBody?.affectedByGravity = false
      self.physicsBody?.categoryBitMask = PhysicsCategory.dual
      self.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
      self.physicsBody?.collisionBitMask = PhysicsCategory.cac
      self.physicsBody?.isDynamic = false
      self.name = "Dual"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
