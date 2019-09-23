//
//  WalkingAnimation.swift
//  SHOOT OUT
//
//  Created by james graupera on 9/21/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit
class WalkingAnimation: NSObject {
    
    var rickArray: NSArray = [SKTexture(imageNamed: "rightMid"), SKTexture(imageNamed: "rightLeg2.0"), SKTexture(imageNamed: "rightMid"), SKTexture(imageNamed: "noLeg"), SKTexture(imageNamed: "leftMid"), SKTexture(imageNamed: "leftLeg2.0"), SKTexture(imageNamed: "leftMid"),  SKTexture(imageNamed: "noLeg")]
    var kricArray: NSArray = [SKTexture(imageNamed: "kcirHalfRight"), SKTexture(imageNamed: "kcirRightFull"), SKTexture(imageNamed: "kcirHalfRight"), SKTexture(imageNamed: "kcirNoLegs"), SKTexture(imageNamed: "kcirHalfLeg"), SKTexture(imageNamed: "kcirLeftFull"), SKTexture(imageNamed: "kcirHalfLeg"),  SKTexture(imageNamed: "kcirNoLegs")]
    var jeanArray: NSArray = [SKTexture(imageNamed: "jeanRightMid"), SKTexture(imageNamed: "jeanRightLeg2.0"), SKTexture(imageNamed: "jeanRightMid"), SKTexture(imageNamed: "jeanNoLeg"), SKTexture(imageNamed: "jeanLeftMid"), SKTexture(imageNamed: "jeanLeftLeg2.0"), SKTexture(imageNamed: "jeanLeftMid"),  SKTexture(imageNamed: "jeanNoLeg")]
    var goldArray: NSArray = [SKTexture(imageNamed: "goldRightMid"), SKTexture(imageNamed: "goldRightLeg2.0"), SKTexture(imageNamed: "goldRightMid"), SKTexture(imageNamed: "jeanNoLeg"), SKTexture(imageNamed: "goldLeftMid"), SKTexture(imageNamed: "goldLeftLeg2.0"), SKTexture(imageNamed: "goldLeftMid"),  SKTexture(imageNamed: "jeanNoLeg")]
    var horseArray: NSArray = [SKTexture(imageNamed: "horseNoLegs"), SKTexture(imageNamed: "horseHalf"), SKTexture(imageNamed: "horseFull")]
}
