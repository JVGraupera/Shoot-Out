//
//  PlayerLegs.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/17/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerLegs: SKSpriteNode {
    init() {
      let texture = SKTexture(imageNamed: "kcirNoLegs")
      super.init(texture: texture, color: .clear, size: texture.size())
      self.scaleTo(screenWidthPercentage: 0.05)
      self.zPosition = 1
      self.position = CGPoint.zero
      self.name = "heroLegs"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
