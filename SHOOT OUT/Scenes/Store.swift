//
//  Store.swift
//  SHOOT OUT
//
//  Created by james graupera on 9/21/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import Foundation
import SpriteKit

class Store: SKScene {
    var gold = UserDefaults().integer(forKey: "gold")
    var goldLabel = SKLabelNode(), kricBuy = SKSpriteNode(), kricEquip = SKSpriteNode(), blueBuy = SKSpriteNode(), blueEquip = SKSpriteNode(), plaidBuy = SKSpriteNode(), plaidEquip = SKSpriteNode(), goldBuy = SKSpriteNode(), goldEquip = SKSpriteNode(), rickEquip = SKSpriteNode(), playButton = SKSpriteNode(), rickPrev = SKSpriteNode(), rickLegPrev = SKSpriteNode(), kricPrev = SKSpriteNode(), kricLegPrev = SKSpriteNode(), bluePrev = SKSpriteNode(), blueLegPrev = SKSpriteNode(), plaidPrev = SKSpriteNode(), plaidLegPrev = SKSpriteNode(), goldPrev = SKSpriteNode(), goldLegPrev = SKSpriteNode()
    var walkArray: WalkingAnimation = WalkingAnimation()
    var selected = SKLabelNode()
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode()
        sprite.texture = SKTexture(imageNamed: "StoreBack2.0")
        sprite.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        sprite.position = CGPoint(x: ScreenSize.width * 0, y: ScreenSize.height * 0)
        sprite.zPosition = -1000
        sprite.scaleTo(screenWidthPercentage: 1.0)
        return sprite
    }()
    //Creates a label at a given location
    func spawnLabel(text: String, pos: CGPoint) {
        let label = SKLabelNode(fontNamed: "AmericanTypewriter")
        label.position = pos
        label.text = text
        label.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 25: 15
        label.name = "storeLabel"
        addChild(label)
    }
    //Sets up the play button at the bottom of the screen
    func PlayButtonSetup() {
        playButton = SKSpriteNode()
        playButton.texture = SKTexture(imageNamed: "Play3.0")
        playButton.position = CGPoint(x: 0 , y: ScreenSize.height * -0.4)
        playButton.size = CGSize(width: 100, height: 75)
        playButton.scaleTo(screenWidthPercentage: 0.15)
        addChild(playButton)
    }
    //Moves to the pcik difficulty scene
    func pickDifficulty() {
        let scene = PickDiff(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene)
    }
    //Sets up a mutable in game currency counter
    func goldSetup() {
        goldLabel = SKLabelNode()
        goldLabel.position = CGPoint(x: ScreenSize.width * 0.4, y: ScreenSize.height * 0.35)
        goldLabel.fontName = "AmericanTypewriter"
        goldLabel.fontColor = UIColor.white
        goldLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 20
        goldLabel.text = "Gold: \(UserDefaults().integer(forKey: "gold"))"
        self.addChild(goldLabel)
    }
    //Updates the currency counter
    func updateGold() {
        UserDefaults().set(gold, forKey: "gold")
        goldLabel.text = "Gold : \(UserDefaults().integer(forKey: "gold"))"
    }
    //Show the correct shop button for the user
    func spawnShop(skin: String, buyButton: SKSpriteNode, equipButton: SKSpriteNode) {
        let num = UserDefaults().integer(forKey: skin)
        if num != 0 {
            buyButton.isHidden = true
        }
        if num != 2 && num != 1 {
            equipButton.isHidden = true
        }
    }
    //Spawns a button of a certian image at a given point
    func spawnButton(button: SKSpriteNode, pos: CGPoint, imageName: String) {
        button.texture = SKTexture(imageNamed: imageName)
        button.position = pos
        button.size = CGSize(width: 100, height: 75)
        button.scaleTo(screenWidthPercentage: 0.1)
        addChild(button)
    }
    //Spawns a skin shop prev
    func spawnPrev(name: String, pos: CGPoint, node: SKSpriteNode, scale: CGFloat, zPos: CGFloat) {
        node.texture = SKTexture(imageNamed: name)
        node.zPosition = zPos
        node.position = pos
        node.size = CGSize(width: 100, height: 100)
        node.scaleTo(screenWidthPercentage: scale)
        self.addChild(node)
    }
    func buySkin(name: String, price: Int, buyButton: SKSpriteNode, equipButton: SKSpriteNode) {
      if UserDefaults().integer(forKey: name) == 0 {
        if UserDefaults().integer(forKey: "gold")  >= price {
            UserDefaults().set(1, forKey: name)
            gold -= price
            updateGold()
            buyButton.isHidden = true
            equipButton.isHidden = false
        }
        else {
             let label = SKLabelNode(fontNamed: "AmericanTypewriter")
            label.position = CGPoint(x: 0, y: ScreenSize.height * -0.3)
             label.text = "Error: You don't have enough gold to buy that skin"
             label.fontColor = UIColor.red
             label.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 35: 20
             label.name = "storeLabel"
             addChild(label)
        }
      }
    }
    @objc func equipSkin(name: String){
        let names = ["rick",  "kric", "blue", "plaid", "goldSkin"]
        names.forEach(){
            if UserDefaults().integer(forKey: $0) == 2{
                UserDefaults().set(1, forKey: $0)
            }
        }
        if UserDefaults().integer(forKey: name) == 1{
            UserDefaults().set(2, forKey: name)
            updateSelected()
        }
        
    }
  
    func setupSelected() {
        selected = SKLabelNode(text: "Equipped")
        selected.fontName = "AmericanTypewriter"
        selected.fontColor = UIColor.green
        selected.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 20
        selected.isHidden = true
        selected.position = CGPoint(x: rickPrev.position.x, y: rickPrev.position.y)
        self.addChild(selected)
    }
    func updateSelected() {
        if UserDefaults().integer(forKey: "rick") == 2 {
            selected.position = CGPoint(x: rickPrev.position.x, y: rickPrev.position.y + ScreenSize.height * 0.25)
            selected.isHidden = false
        }
        if UserDefaults().integer(forKey: "kric") == 2 {
            selected.position = CGPoint(x: kricPrev.position.x, y: kricPrev.position.y + ScreenSize.height * 0.25)
            selected.isHidden = false
        }
        if UserDefaults().integer(forKey: "blue") == 2 {
            selected.position = CGPoint(x: bluePrev.position.x, y: bluePrev.position.y + ScreenSize.height * 0.25)
            selected.isHidden = false
        }
        if UserDefaults().integer(forKey: "plaid") == 2 {
            selected.position = CGPoint(x: plaidPrev.position.x, y: plaidPrev.position.y + ScreenSize.height * 0.25)
            selected.isHidden = false
        }
        if UserDefaults().integer(forKey: "goldSkin") == 2 {
            selected.position = CGPoint(x: goldPrev.position.x, y: goldPrev.position.y + ScreenSize.height * 0.25)
            selected.isHidden = false
        }
    }
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        PlayButtonSetup()
        setupSelected()
        goldSetup()
        SoundController.shared.run("GunCocking.mp3", node: self)
        addChild(background)
        spawnPrev(name: "Bad4", pos: CGPoint(x: ScreenSize.width * -0.36, y: ScreenSize.height * 0.05), node: rickPrev, scale: 0.15, zPos: 2)
        spawnPrev(name: "kcirNoLegs", pos: CGPoint(x: ScreenSize.width * -0.36, y: ScreenSize.height * 0.05), node: rickLegPrev, scale: 0.125, zPos: 1)
        spawnPrev(name: "Kric2.0", pos: CGPoint(x: ScreenSize.width * -0.175, y: ScreenSize.height * 0.05), node: kricPrev, scale: 0.15, zPos: 2)
        spawnPrev(name: "kcirNoLegs", pos: CGPoint(x: ScreenSize.width * -0.175, y: ScreenSize.height * 0.05), node: kricLegPrev, scale: 0.2, zPos: 1)
        spawnPrev(name: "babyBlue", pos: CGPoint(x: ScreenSize.width * 0, y: ScreenSize.height * 0.05), node: bluePrev, scale: 0.15, zPos: 2)
        spawnPrev(name: "jeanNoLeg", pos: CGPoint(x: ScreenSize.width * 0, y: ScreenSize.height * 0.05), node: blueLegPrev, scale: 0.15, zPos: 1)
        spawnPrev(name: "plaid3.0", pos: CGPoint(x: ScreenSize.width * 0.175, y: ScreenSize.height * 0.05), node: plaidPrev, scale: 0.15, zPos: 2)
        spawnPrev(name: "jeanNoLeg", pos: CGPoint(x: ScreenSize.width * 0.175, y: ScreenSize.height * 0.05), node: plaidLegPrev, scale: 0.15, zPos: 1)
        spawnPrev(name: "solidGold", pos: CGPoint(x: ScreenSize.width * 0.36, y: ScreenSize.height * 0.05), node: goldPrev, scale: 0.15, zPos:  2)
        spawnPrev(name: "jeanNoLeg", pos: CGPoint(x: ScreenSize.width * 0.36, y: ScreenSize.height * 0.05), node: goldLegPrev, scale: 0.15, zPos: 1)
        spawnButton(button: rickEquip, pos: CGPoint(x: rickPrev.position.x, y: rickPrev.position.y - ScreenSize.height * 0.25), imageName: "Equip")
        spawnButton(button: kricBuy, pos: CGPoint(x: kricPrev.position.x, y: kricPrev.position.y - ScreenSize.height * 0.25), imageName: "buy")
        spawnButton(button: kricEquip, pos: CGPoint(x: kricPrev.position.x, y: kricPrev.position.y - ScreenSize.height * 0.25), imageName: "Equip")
        spawnButton(button: blueBuy, pos: CGPoint(x: bluePrev.position.x, y: bluePrev.position.y - ScreenSize.height * 0.25), imageName: "buy")
        spawnButton(button: blueEquip, pos: CGPoint(x: bluePrev.position.x, y: bluePrev.position.y - ScreenSize.height * 0.25), imageName: "Equip")
        spawnButton(button: plaidBuy, pos: CGPoint(x: plaidPrev.position.x, y: plaidPrev.position.y - ScreenSize.height * 0.25), imageName: "buy")
        spawnButton(button: plaidEquip, pos: CGPoint(x: plaidPrev.position.x, y: plaidPrev.position.y - ScreenSize.height * 0.25), imageName: "Equip")
        spawnButton(button: goldBuy, pos: CGPoint(x: goldPrev.position.x, y: goldPrev.position.y - ScreenSize.height * 0.25), imageName: "buy")
        spawnButton(button: goldEquip, pos: CGPoint(x: goldPrev.position.x, y: goldPrev.position.y - ScreenSize.height * 0.25), imageName: "Equip")
        spawnShop(skin: "kric", buyButton: kricBuy, equipButton: kricEquip)
        spawnShop(skin: "goldSkin", buyButton: goldBuy, equipButton: goldEquip)
        spawnShop(skin: "blue", buyButton: blueBuy, equipButton: blueEquip)
        spawnShop(skin: "plaid", buyButton: plaidBuy, equipButton: plaidEquip)
        spawnLabel(text: "Cost: 100", pos: CGPoint(x: kricPrev.position.x, y: kricPrev.position.y - ScreenSize.height * 0.15))
        spawnLabel(text: "Cost: 100", pos: CGPoint(x: bluePrev.position.x, y: bluePrev.position.y - ScreenSize.height * 0.15))
        spawnLabel(text: "Cost: 100", pos: CGPoint(x: plaidPrev.position.x, y: plaidPrev.position.y - ScreenSize.height * 0.15))
        spawnLabel(text: "Cost: 1000", pos: CGPoint(x: goldPrev.position.x, y: goldPrev.position.y - ScreenSize.height * 0.15))
        spawnLabel(text: "Rick", pos: CGPoint(x: rickPrev.position.x, y: rickPrev.position.y + ScreenSize.height * 0.15))
        spawnLabel(text: "Kric", pos: CGPoint(x: kricPrev.position.x, y: kricPrev.position.y + ScreenSize.height * 0.15))
        spawnLabel(text: "Little Boy Blue", pos: CGPoint(x: bluePrev.position.x, y: bluePrev.position.y + ScreenSize.height * 0.15))
        spawnLabel(text: "Bad In Plaid", pos: CGPoint(x: plaidPrev.position.x, y: plaidPrev.position.y + ScreenSize.height * 0.15))
        spawnLabel(text: "Golden Boy", pos: CGPoint(x: goldPrev.position.x, y: goldPrev.position.y + ScreenSize.height * 0.15))
        spawnLabel(text: "Tap a skin to see it walk!", pos: CGPoint(x: ScreenSize.width * 0, y: ScreenSize.height * 0.4))
        updateSelected()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if playButton.contains(location) {
                pickDifficulty()
            }
            if rickEquip.contains(location) {
                equipSkin(name: "rick")
                updateSelected()
            }
            if kricBuy.contains(location) {
                buySkin(name: "kric", price: 100, buyButton: kricBuy, equipButton: kricEquip)
            }
            if kricEquip.contains(location) {
                equipSkin(name: "kric")
                updateSelected()
            }
            if blueBuy.contains(location) {
                buySkin(name: "blue", price: 100, buyButton: blueBuy, equipButton: blueEquip)
            }
            if blueEquip.contains(location) {
                equipSkin(name: "blue")
                updateSelected()
            }
            if plaidBuy.contains(location) {
                buySkin(name: "plaid", price: 100, buyButton: plaidBuy, equipButton: plaidEquip)
            }
            if plaidEquip.contains(location) {
                equipSkin(name: "plaid")
                updateSelected()
            }
            if goldBuy.contains(location) {
                buySkin(name: "goldSkin", price: 1000, buyButton: goldBuy, equipButton: goldEquip)
            }
            if goldEquip.contains(location) {
                equipSkin(name: "goldSkin")
                updateSelected()
            }
            else if rickPrev.contains(location) {
                self.rickLegPrev.run(SKAction.animate(with: walkArray.rickArray as! [SKTexture], timePerFrame: 0.2))
            }
            else if kricPrev.contains(location) {
                self.kricLegPrev.run(SKAction.animate(with: walkArray.kricArray as! [SKTexture], timePerFrame: 0.2))
            }
            else if bluePrev.contains(location) {
                self.blueLegPrev.run(SKAction.animate(with: walkArray.jeanArray as! [SKTexture], timePerFrame: 0.2))
            }
            else if plaidPrev.contains(location) {
                self.plaidLegPrev.run(SKAction.animate(with: walkArray.jeanArray as! [SKTexture], timePerFrame: 0.2))
            }
            else if goldPrev.contains(location) {
                self.goldLegPrev.run(SKAction.animate(with: walkArray.goldArray as! [SKTexture], timePerFrame: 0.2))
            }
        }
    }
}
