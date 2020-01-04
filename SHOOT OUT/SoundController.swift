//
//  SoundController.swift
//  SHOOT OUT
//
//  Created by james graupera on 1/2/20.
//  Copyright © 2020 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class SoundController {
    private init() {}
    static let shared = SoundController()
    func run(_ filename: String, node: SKNode){
        node.run(SKAction.playSoundFileNamed(filename, waitForCompletion: true))
    }
    func GunSound(_ node: SKNode){
        var filename: String
        let num = Int.random(in: 0 ... 2)
        
        if num == 0{
            filename = "Gun Shot.mp3"
        }
        else if num == 1 {
            filename = "Gun Shot2.mp3"
        }
        else{
            filename = "Gun Shot3.mp3"
        }
        node.run(SKAction.playSoundFileNamed(filename, waitForCompletion: true))
    }
}
