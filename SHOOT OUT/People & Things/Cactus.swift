//
//  Cactus.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/17/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Cactus: SKSpriteNode {
    init(X: Double, Y: Double) {
        let texture = SKTexture(imageNamed: "Cactus2.00")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = CGPoint(x: X, y: Y)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ScreenSize.width * 0.05, height: ScreenSize.height * 0.085))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.cac
        self.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        self.physicsBody?.collisionBitMask = PhysicsCategory.bullet
        self.physicsBody?.isDynamic = false
        self.scaleTo(screenWidthPercentage: 0.1)
        self.name = "Cac"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
