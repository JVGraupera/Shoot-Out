//
//  StartupScene.swift
//  SHOOT OUT
//
//  Created by james graupera on 9/21/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class StartupScene: SKScene {
    var playButton: SKSpriteNode!
    //Sets up background of scene
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode() 
        sprite.texture = SKTexture(imageNamed: "StartScreen")
        sprite.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        sprite.position = CGPoint.zero
        sprite.zPosition = -1000
        sprite.scaleTo(screenWidthPercentage: 1.0)
        return sprite
    }()
    //Sets up the "Shoot Out" title
    func titleSetup() {
        let title = SKSpriteNode(imageNamed: "GameTitle")
        title.size = CGSize(width: 250, height: 150)
        title.zRotation = -1.57
        title.position = CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0.05)
        addChild(title)
    }
    //Plays the game
     func play() {
        let scene = PickDiff(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene)
    }
    //Sets up the play button
    func playButton(view : SKView) {
        playButton = SKSpriteNode()
        playButton.texture = SKTexture(imageNamed: "Play3.0")
        playButton.position = CGPoint(x: ScreenSize.width * -0.4 , y: 0)
        playButton.size = CGSize(width: 100, height: 75)
        playButton.zRotation = -1.57
        self.addChild(playButton)

    }
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        titleSetup()
        playButton(view: view)
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if playButton.contains(location) {
                play()
            }
        }
}
}
