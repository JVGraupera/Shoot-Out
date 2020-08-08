//
//  StartupScene.swift
//  SHOOT OUT
//
//  Created by james graupera on 9/21/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class StartupScene: SKScene {
    var playButton: SKSpriteNode!
    var sound: AVAudioPlayer?
    //Sets up background of scene
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode() 
        sprite.texture = SKTexture(imageNamed: "StartScreentest")
        sprite.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        sprite.position = CGPoint.zero
        sprite.zPosition = -1000
        sprite.scaleTo(screenWidthPercentage: 1.0)
        return sprite
    }()
    //Sets up the "Shoot Out" title
    func titleSetup() {
        let title = SKSpriteNode(imageNamed: "GameTitle")
        title.size = CGSize(width: 150, height: 100)
        title.scaleTo(screenWidthPercentage: 0.35)
        title.zRotation = 0
        title.position = CGPoint(x: ScreenSize.width * -0.075, y: ScreenSize.height * 0.15)
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
        playButton.position = CGPoint(x: ScreenSize.width * 0 , y: ScreenSize.height * -0.35)
        playButton.size = CGSize(width: 100, height: 75)
        playButton.scaleTo(screenWidthPercentage: 0.15)
        playButton.zRotation = 0
        self.addChild(playButton)

    }
    func PlaySound(name: String, type: String){
        let path = Bundle.main.path(forResource: name, ofType: type)!
        let url = URL(fileURLWithPath: path)
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.play()
        } catch {
            print("Can't find %s", name)
        }
    }
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        SoundController.shared.run("GunCocking.mp3", node: self)
        titleSetup()
        playButton(view: view)
        //PlaySound(name: "Gun Cocking", type: "mp3")
        
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
