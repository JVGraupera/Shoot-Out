//
//  Bullet.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/18/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    init(name: String) {
        super.init(texture: nil, color: UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: CGSize(width: ScreenSize.width * 0.01, height: ScreenSize.width * 0.01))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ScreenSize.width * 0.01, height: ScreenSize.width * 0.01))
        self.zPosition = 1
        self.physicsBody?.mass = 0.1
        self.physicsBody?.affectedByGravity = false
        if name == "badBullet"{
            self.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            self.physicsBody?.collisionBitMask = PhysicsCategory.hero
            self.physicsBody?.contactTestBitMask = PhysicsCategory.hero
        }
        else {
            self.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            self.physicsBody?.collisionBitMask = PhysicsCategory.bad
            self.physicsBody?.contactTestBitMask = PhysicsCategory.bad
        }
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
