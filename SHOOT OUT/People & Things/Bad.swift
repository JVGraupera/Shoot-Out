//
//  Bad.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/17/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Bad: SKSpriteNode {
    init(X: Double, Y: Double) {
      let texture = SKTexture(imageNamed: "Rick2.0")
      super.init(texture: texture, color: .clear, size: texture.size())
      self.position = CGPoint(x: X, y: Y)
      self.scaleTo(screenWidthPercentage: 0.1)
      self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
      self.physicsBody?.affectedByGravity = false
      self.physicsBody?.categoryBitMask = PhysicsCategory.bad
      self.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
      self.physicsBody?.collisionBitMask = PhysicsCategory.cac
      self.physicsBody?.isDynamic = false
      self.name = "bad"
   }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
