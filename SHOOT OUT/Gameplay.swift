//
//  Gameplay.swift
//  SHOOT OUT
//
//  Created by james graupera on 7/7/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import SpriteKit
struct PhysicsCategory {
    static let bad: UInt32 = 0x1 << 0
    static let bullet : UInt32 = 0x1 << 1
    static let hero : UInt32 = 0x1 << 2
}
class Gameplay: SKScene, SKPhysicsContactDelegate {
    var BadTimer = Timer()
    var ScoreLabel: SKLabelNode!
    var Ammo: SKLabelNode!
    let velocityMultiplier: CGFloat = 0.07
    var gameTimer: Timer?
    enum NodesZPosition: CGFloat {
        case background, hero, joystick
    }
    func didBegin( _ contact: SKPhysicsContact)
    {
        let firstBody = contact.bodyA.node as! SKSpriteNode
        let secondBody = contact.bodyB.node as! SKSpriteNode
        
        if (firstBody.name == "bullet") && (secondBody.name == "bad") {
            collisionBullet(bad: secondBody, bullet: firstBody)
            score += 1
        }
        else if  (firstBody.name == "bad") && (secondBody.name == "bullet"){
            collisionBullet(bad: firstBody, bullet: secondBody)
            score += 1
        }
    }
    func collisionBullet(bad: SKSpriteNode, bullet: SKSpriteNode){
        bad.removeFromParent()
        bullet.removeFromParent()
        
    }
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode(color: UIColor(displayP3Red: 194/255, green: 178/255, blue: 128/255, alpha: 1.0), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        sprite.position = CGPoint.zero
        sprite.zPosition = NodesZPosition.background.rawValue
        sprite.scaleTo(screenWidthPercentage: 1.0)
        return sprite
    }()
    @objc func spawnBad(num: Int) {
        let bad = SKSpriteNode(imageNamed: "Rick2.0")
        let randX = Double.random(in: (-200.0...200.0))
        let randY = Double.random(in: (-400.0...400.0))
        bad.position = CGPoint(x: randX, y: randY)
        bad.scaleTo(screenWidthPercentage: 0.1)
        bad.physicsBody = SKPhysicsBody(circleOfRadius: bad.size.width / 2)
        bad.physicsBody?.affectedByGravity = false
        bad.physicsBody?.categoryBitMask = PhysicsCategory.bad
        bad.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        bad.physicsBody?.collisionBitMask = PhysicsCategory.bullet
        bad.name = "bad"
        addChild(bad)
    }
    
    @objc lazy var hero: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "Bad2.0")
        sprite.position = CGPoint.zero
        sprite.zPosition = NodesZPosition.hero.rawValue
        sprite.scaleTo(screenWidthPercentage: 0.1)
        return sprite
    }()
    
      lazy var analogJoystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: #imageLiteral(resourceName: "jSubstrate"), stick: #imageLiteral(resourceName: "jStick")))
        js.position = CGPoint(x: ScreenSize.width * -0.5 + js.radius + 50, y: ScreenSize.height * -0.5 + js.radius + 750)
        js.zPosition = NodesZPosition.joystick.rawValue
        return js
      }()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        setupNodes()
        setupJoystick()
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.backgroundColor = UIColor.init(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        button.frame = CGRect(x: 20, y: 800, width: 60, height: 60)
        button.transform = CGAffineTransform(rotationAngle: 1.57)
        button.setTitle("Shoot", for: .normal)
        button.addTarget(self, action: #selector(shoot), for: .touchUpInside)
        
        view.addSubview(button)
        BadTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(spawnBad), userInfo: nil, repeats: true)
        ScoreBoard(view: view)
        AmmoCounter(view: view)
        ReloadButton(view: view)
        
    }
    
    func setupNodes() {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        addChild(hero)
    }
    
    func setupJoystick() {
            addChild(analogJoystick)
        
            analogJoystick.trackingHandler = { [unowned self] data in
              self.hero.position = CGPoint(x: self.hero.position.x + (data.velocity.x * self.velocityMultiplier),
                                           y: self.hero.position.y + (data.velocity.y * self.velocityMultiplier))
              self.hero.zRotation = data.angular
            }
    }
    func rotate(vector:CGVector, angle:CGFloat) -> CGVector {
        let rotatedX = vector.dx * cos(angle) - vector.dy * sin(angle)
        let rotatedY = vector.dx * sin(angle) + vector.dy * cos(angle)
        return CGVector(dx: rotatedX, dy: rotatedY)
    }
    let rotationOffset = CGFloat(Double.pi/2)
     @objc func shoot() {
        if ammo > 0{
            let gunx = self.position.x + 17
            let guny = self.position.y + 17
            let converted = hero.convert(CGPoint(x: gunx, y: guny), to: self)
            
            // Determine the direction of the bullet based on the character's rotation
            let vector = rotate(vector: CGVector(dx: 0.25, dy: 0), angle:hero.zRotation+rotationOffset)
            
            // Create a bullet with a physics body
            let bullet = SKSpriteNode(color: UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size:CGSize(width: 4,height: 4))
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 2)
            bullet.physicsBody?.affectedByGravity = false
            bullet.position = CGPoint(x: converted.x, y: converted.y)
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            bullet.physicsBody?.collisionBitMask = PhysicsCategory.bad
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.bad
            bullet.name = "bullet"
            ammo -= 1
            addChild(bullet)
            bullet.physicsBody?.applyImpulse(vector)
            let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
                bullet.removeFromParent()
            })
        }
        else {
            Ammo.text = "Reload!!"
        }
        
    }
    var score = 0 {
        didSet {
            ScoreLabel.text = "\(score)"
        }
    }
    func ScoreBoard(view: SKView) {
        ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        ScoreLabel.text = "0"
        ScoreLabel.position = CGPoint(x: 180, y: 0)
        ScoreLabel.zRotation = -1.5
        addChild(ScoreLabel)
    }
    var ammo = 6 {
        didSet {
            Ammo.text = "Ammo: \(ammo)"
        }
    }
    func AmmoCounter(view: SKView)
    {
        Ammo = SKLabelNode(fontNamed: "Chalkduster")
        Ammo.text = "Ammo: 6"
        Ammo.fontSize = 15
        Ammo.position = CGPoint(x:180, y: 300)
        Ammo.zRotation = -1.57
        addChild(Ammo)
    }
    func ReloadButton(view: SKView)
    {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.backgroundColor = UIColor.init(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        button.frame = CGRect(x: 20, y: 700, width: 60, height: 60)
        button.transform = CGAffineTransform(rotationAngle: 1.57)
        button.setTitle("Reload", for: .normal)
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        
        view.addSubview(button)
    }
    @objc func reload() {
        ammo = 6
    }

}
