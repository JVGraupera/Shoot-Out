//
//  PickDiff.swift
//  SHOOT OUT
//
//  Created by james graupera on 9/21/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit
class PickDiff: SKScene {
    var easyButton: SKSpriteNode!
    var hardButton: SKSpriteNode!
    var storeButton: SKSpriteNode!
    var goldLabel: SKLabelNode!
    var highScoreLabel = SKLabelNode()
    var easyhighScoreLabel = SKLabelNode()
    var moveLabel = SKLabelNode()
    var aimLabel = SKLabelNode()
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode()
        sprite.texture = SKTexture(imageNamed: "sand2")
        sprite.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        sprite.position = CGPoint.zero
        sprite.zPosition = -1000
        sprite.scaleTo(screenWidthPercentage: 1.0)
        return sprite
    }()
    func goldSetup() {
        goldLabel = SKLabelNode()
        goldLabel.position = CGPoint(x: ScreenSize.width * 0.4, y: ScreenSize.height * 0.35)
        goldLabel.fontName = "AmericanTypewriter"
        goldLabel.fontColor = UIColor.black
        goldLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 20
        goldLabel.zRotation = CGFloat(-Double.pi / 2)
        goldLabel.text = "Gold: \(UserDefaults().integer(forKey: "gold"))"
        self.addChild(goldLabel)
    }
    
    func easyButtonSetup(view : SKView) {
        easyButton = SKSpriteNode()
        easyButton.texture = SKTexture(imageNamed: "Easy")
        easyButton.position = CGPoint(x: 0, y: ScreenSize.height * 0.1)
        easyButton.size = CGSize(width: 100, height: 75)
        easyButton.scaleTo(screenWidthPercentage: 0.25)
        easyButton.zRotation = -1.57
        self.addChild(easyButton)
    }
    func easyHighScoreSetup() {
        easyhighScoreLabel.position = CGPoint(x: ScreenSize.width * 0.2, y: 0)
        easyhighScoreLabel.fontName = "AmericanTypewriter"
        easyhighScoreLabel.fontColor = UIColor.black
        easyhighScoreLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 20
        easyhighScoreLabel.zRotation = CGFloat(-Double.pi / 2)
        easyhighScoreLabel.text = "Easy Mode High Score: \(UserDefaults().integer(forKey: "HighScoreEasy"))"
        self.addChild(easyhighScoreLabel)
    }
    func hardButtonSetup(view : SKView) {
        hardButton = SKSpriteNode()
        hardButton.texture = SKTexture(imageNamed: "HardButton")
        hardButton.position = CGPoint(x: 0 , y: ScreenSize.height * -0.1)
        hardButton.size = CGSize(width: 100, height: 75)
        hardButton.scaleTo(screenWidthPercentage: 0.25)
        hardButton.zRotation = -1.57
        self.addChild(hardButton)
    }
    func highScoreSetup() {
        highScoreLabel.position = CGPoint(x: ScreenSize.width * 0.25, y: 0)
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.fontName = "AmericanTypewriter"
        highScoreLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 20
        highScoreLabel.zRotation = CGFloat(-Double.pi / 2)
        highScoreLabel.text = "Hard Mode High Score: \(UserDefaults().integer(forKey: "HighScore"))"
        self.addChild(highScoreLabel)
    }
    func storeButton(view : SKView) {
        storeButton = SKSpriteNode()
        storeButton.texture = SKTexture(imageNamed: "Store")
        storeButton.position = CGPoint(x: ScreenSize.width * -0.4 , y: 0)
        storeButton.size = CGSize(width: 100, height: 75)
        storeButton.scaleTo(screenWidthPercentage: 0.2)
        storeButton.zRotation = -1.57
        self.addChild(storeButton)
    }
    func moveTutorial() {
        moveLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        moveLabel.text = "This joystick moves you"
        moveLabel.fontColor = UIColor.black
        moveLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 15
        moveLabel.zRotation = CGFloat(-Double.pi/2)
        moveLabel.position = CGPoint(x: analogJoystick.position.x + ScreenSize.width * 0.2, y: analogJoystick.position.y - ScreenSize.height * 0.04)
        addChild(moveLabel)
        
    }
    func aimTutorial() {
        aimLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        aimLabel.text = "This joystick aims you"
        aimLabel.fontColor = UIColor.black
        aimLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 15
        aimLabel.zRotation = CGFloat(-Double.pi/2)
        aimLabel.position = CGPoint(x: analogJoystickTwo.position.x + ScreenSize.width * 0.2, y: analogJoystickTwo.position.y + ScreenSize.height * 0.04)
        addChild(aimLabel)
        
    }
    lazy var analogJoystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: ScreenSize.height * 0.14, colors: nil, images: (substrate: UIImage.init(named: "Joy"), stick: UIImage.init(named: "Feet2.0")))
        js.position = CGPoint(x: ScreenSize.width * -0.325, y: ScreenSize.height * 0.375)
        js.name = "joy"
        return js
    }()
    lazy var analogJoystickTwo: AnalogJoystick = {
        let js = AnalogJoystick(diameter: ScreenSize.height * 0.14, colors: nil, images: (substrate: UIImage.init(named: "Joy"), stick: UIImage.init(named: "Crosshair")))
        js.position = CGPoint(x: ScreenSize.width * -0.325, y: ScreenSize.height * -0.375)
        js.name = "joy"
        return js
    }()
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        addChild(analogJoystick)
        addChild(analogJoystickTwo)
        easyButtonSetup(view: view)
        hardButtonSetup(view: view)
        storeButton(view: view)
        goldSetup()
        highScoreSetup()
        easyHighScoreSetup()
        moveTutorial()
        aimTutorial()
    }
    func openStore() {
        let scene = Store(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene)
    }
    func playGame() {
        let scene = Gameplay(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if easyButton.contains(location) {
                UserDefaults().set(0, forKey: "difficulty")
                playGame()
            }
            if hardButton.contains(location){
                UserDefaults().set(1, forKey: "difficulty")
                playGame()
            }
            if storeButton.contains(location){
                openStore()
            }
        }
    }
}
