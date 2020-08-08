//
//  Reset.swift
//  SHOOT OUT
//
//  Created by james graupera on 12/24/19.
//  Copyright © 2019 James' Games. All rights reserved.
//
import UIKit
import SpriteKit
import SceneKit

class Reset: SKScene{
    var ScoreLabel = SKLabelNode(), highScoreLabel = SKLabelNode(), easyhighScoreLabel = SKLabelNode(), goldLabel = SKLabelNode()
    var Game: Gameplay = Gameplay()
    var VC: UIViewController = UIViewController()
    var score: Int!
    var viewCon: ViewController = ViewController()
    //The Background
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode()
        sprite.texture = SKTexture(imageNamed: "StartScreen")
        sprite.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        sprite.position = CGPoint(x: ScreenSize.width * 0, y: ScreenSize.height * 0)
        sprite.zPosition = -1000
        sprite.scaleTo(screenWidthPercentage: 1.0)
        return sprite
    }()
    //The reset button
    lazy var resetButton: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "Reset")
        sprite.position = CGPoint(x: ScreenSize.width * -0.2, y: ScreenSize.height * 0)
        sprite.zRotation = -1.57
        sprite.zPosition = 2
        sprite.name = "button"
        sprite.scaleTo(screenWidthPercentage: 0.2)
        return sprite
    }()
    //The change difficulty button
    lazy var changeDifficulty: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "Change")
        sprite.position = CGPoint(x: ScreenSize.width * -0.4, y: ScreenSize.height * 0)
        sprite.zRotation = -1.57
        sprite.zPosition = 2
        sprite.name = "button"
        sprite.scaleTo(screenWidthPercentage: 0.25)
        return sprite
    }()
    lazy var ShareButton: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "share")
        sprite.position = CGPoint(x: ScreenSize.width * -0.4, y: ScreenSize.height * -0.4)
        sprite.zRotation = -1.57
        sprite.zPosition = 2
        sprite.name = "button"
        sprite.scaleTo(screenWidthPercentage: 0.15)
        return sprite
    }()
    func ScoreBoard() {
        ScoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        ScoreLabel.zPosition = 40
        ScoreLabel.fontColor = UIColor.black
        ScoreLabel.text = "\(UserDefaults().integer(forKey: "Score"))"
        ScoreLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 55: 45
        ScoreLabel.color = UIColor.black
        ScoreLabel.position = CGPoint(x: ScreenSize.width * 0, y: 0)
        ScoreLabel.zRotation = -1.57
        ScoreLabel.name = "gameLabel"
        addChild(ScoreLabel)
    }
    //Spawns a lable at a given point
    func spawnLabel(text: String, pos: CGPoint, label : SKLabelNode) {
        label.fontName = "AmericanTypewriter"
        label.position = pos
        label.text = text
        label.zRotation = CGFloat(-Double.pi / 2)
        label.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 20
        label.fontColor = UIColor.black
        label.name = "gameLabel"
        addChild(label)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if changeDifficulty.contains(location) {
                let scene = PickDiff(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
            else if resetButton.contains(location) {
                let scene = Gameplay(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
            else if ShareButton.contains(location) {
                alert()
            }
        }
    }
    func makeSnapshot() -> UIImage? {
        UserDefaults().set(1, forKey: "Share")
        UIGraphicsBeginImageContextWithOptions(viewCon.view.bounds.size, false, 30)
        //UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        viewCon.view.drawHierarchy(in: viewCon.view.bounds, afterScreenUpdates: true)


        let image = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()
        UserDefaults().set(0, forKey: "Share")
        return image
    }
    func shareToInstaStories() {
    if let storiesUrl = URL(string: "instagram-stories://share") {
        if UIApplication.shared.canOpenURL(storiesUrl) {
            let image = makeSnapshot()!.imageRotated(on: -90)
            guard let imageData = image.pngData() else { return }
            guard let backImage = UIImage(named: "shareback")?.pngData() else {
                return
            }
            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.stickerImage": imageData,
                "com.instagram.sharedSticker.backgroundImage": backImage,
                "com.instagram.sharedSticker.backgroundTopColor": "#FC6949",
                "com.instagram.sharedSticker.backgroundBottomColor": "#F3AD48",
                "com.instagram.sharedSticker.contentURL": "https://apps.apple.com/us/app/shoot-out/id1474867401?ls=1"
            ]
            let pasteboardOptions = [
                UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(1)
            ]
            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
        } else {
            print("User doesn't have instagram on their device.")
            let label = SKLabelNode(fontNamed: "AmericanTypewriter")
            label.position = CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0)
            label.text = "Error: You must be logged-in to Instagram to share"
            label.zRotation = -1.57
            label.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 35: 20
            label.name = "storeLabel"
            addChild(label)
        }
    }
    }
    func alert() {
      let alertController = UIAlertController(title: "Want to share?", message: "Do you have your parents' permission to share on Instagram?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action)  in self.shareToInstaStories()}))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action)  in }))
      var rootViewController = UIApplication.shared.keyWindow?.rootViewController
      if let navigationController = rootViewController as? UINavigationController {
          rootViewController = navigationController.viewControllers.first
      }
      if let tabBarController = rootViewController as? UITabBarController {
          rootViewController = tabBarController.selectedViewController
      }
      //...
      rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ScoreBoard()
        addChild(ShareButton)
        addChild(background)
        addChild(changeDifficulty)
        addChild(resetButton)
        spawnLabel(text: "Hard Mode High Score: \(UserDefaults().integer(forKey: "HighScore"))", pos: CGPoint(x: ScreenSize.width * 0.25, y: 0), label: highScoreLabel)
        spawnLabel(text: "Easy Mode High Score: \(UserDefaults().integer(forKey: "HighScoreEasy"))", pos: CGPoint(x: ScreenSize.width * 0.25 + 30, y: 0), label: easyhighScoreLabel)
        spawnLabel(text: "Gold: \(UserDefaults().integer(forKey: "gold"))", pos: CGPoint(x: ScreenSize.width * 0.4, y: ScreenSize.height * 0.35), label: goldLabel)
    }
    
}
