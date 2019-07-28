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
    static let badBullet : UInt32 = 0x1 << 3
}
class Gameplay: SKScene, SKPhysicsContactDelegate {
    var BadTimer = Timer()
    var shootTimer = Timer()
    var ScoreLabel: SKLabelNode!
    var Ammo: SKLabelNode!
    let velocityMultiplier: CGFloat = 0.07
    var gameTimer: Timer?
    var highScoreLabel = SKLabelNode()
    var highScore = UserDefaults().integer(forKey: "HighScore")
    
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
        if  (firstBody.name == "hero") && (secondBody.name == "badBullet") {
            collisionBullet(bad: firstBody, bullet: secondBody)
        }
        else if (firstBody.name == "badBullet") && (secondBody.name == "hero") {
            collisionBullet(bad: firstBody, bullet: secondBody)
        }
        if (firstBody.name == "bullet") && (secondBody.name == "Dual") {
            collisionBullet(bad: secondBody, bullet: firstBody)
            score += 2
        }
        else if  (firstBody.name == "Dual") && (secondBody.name == "bullet"){
            collisionBullet(bad: firstBody, bullet: secondBody)
            score += 2
        }
        
    }
    func collisionBullet(bad: SKSpriteNode, bullet: SKSpriteNode){
        bad.removeFromParent()
        bullet.removeFromParent()
        
        if (bad.name == "hero") || (bullet.name == "hero") {
            self.resetButton.isHidden = false
            highScoreLabel.isHidden = false
            endGame()
            //Reset()
            if score > UserDefaults().integer(forKey: "HighScore") {
                saveHighScore()
            }
        }
        
    }
    func saveHighScore() {
        UserDefaults().set(score, forKey: "HighScore")
        highScoreLabel.text = "High Score: \(UserDefaults().integer(forKey: "HighScore"))"
    }
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode(color: UIColor(displayP3Red: 200/255, green: 170/255, blue: 120/255, alpha: 1.0), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        sprite.position = CGPoint.zero
        sprite.zPosition = NodesZPosition.background.rawValue
        sprite.scaleTo(screenWidthPercentage: 1.0)
        return sprite
    }()
    lazy var resetButton: UIButton = {
        var button = UIButton(frame: CGRect(x: ScreenSize.width * 0.4, y: ScreenSize.height * 0.5, width: 100, height: 100))
        button.setTitle("Play", for: .normal)
        button.setImage(UIImage(named: "Reset"), for: .normal)
        button.transform = button.transform.rotated(by: 1.57)
        button.addTarget(self, action: #selector(Reset), for: .touchUpInside)
        //button.addTarget(self, action: #selector(mainButton), for: .touchUpInside)
        return button
    }()
    func endGame() {
        shootTimer.invalidate()
        BadTimer.invalidate()
        for child in self.children {
            if child.name == "bad" || child.name == "Cac" || child.name == "bullet" || child.name == " badBullet" || child.name == "Dual" {
                child.removeFromParent()
            }
        }
    }
    // Spawns enemy
    @objc func spawnBad() {
        let bad = SKSpriteNode(imageNamed: "Rick2.0")
        let minX = Double(ScreenSize.width * -0.5)
        let maxX = Double(ScreenSize.width * 0.5)
        let minY = Double(ScreenSize.height * -0.5)
        let maxY = Double(ScreenSize.height * 0.5)
        let randX = Double.random(in: (minX...maxX))
        let randY = Double.random(in: (minY...maxY))
        bad.position = CGPoint(x: randX, y: randY)
        bad.scaleTo(screenWidthPercentage: 0.1)
        bad.physicsBody = SKPhysicsBody(circleOfRadius: bad.size.width / 2)
        bad.physicsBody?.affectedByGravity = false
        bad.physicsBody?.categoryBitMask = PhysicsCategory.bad
        bad.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        bad.physicsBody?.collisionBitMask = PhysicsCategory.bullet
        bad.name = "bad"
        let track = buildAction(hero: hero, bad: bad)
        let shoot = SKAction.run {
            self.badShoot(sprite: bad)
        }
        let delay = SKAction.wait(forDuration: 0.1)
        let seq = SKAction.sequence([track, delay])
        let shootDelay = SKAction.wait(forDuration: 1.25)
        let seqShoot = SKAction.sequence([shootDelay, shoot])
        let shooter = SKAction.repeatForever(seqShoot)
        let aim = SKAction.repeatForever(seq)
        
        addChild(bad)
        bad.run(shooter)
        bad.run(aim)
    }
    func spawnDual() {
        let bad = SKSpriteNode(imageNamed: "Dual2.0")
        let minX = Double(ScreenSize.width * -0.5)
        let maxX = Double(ScreenSize.width * 0.5)
        let minY = Double(ScreenSize.height * -0.5)
        let maxY = Double(ScreenSize.height * 0.5)
        let randX = Double.random(in: (minX...maxX))
        let randY = Double.random(in: (minY...maxY))
        bad.position = CGPoint(x: randX, y: randY)
        bad.scaleTo(screenWidthPercentage: 0.13)
        bad.physicsBody = SKPhysicsBody(circleOfRadius: bad.size.width / 2)
        bad.physicsBody?.affectedByGravity = false
        bad.physicsBody?.categoryBitMask = PhysicsCategory.bad
        bad.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        bad.physicsBody?.collisionBitMask = PhysicsCategory.bullet
        bad.name = "Dual"
        let track = buildAction(hero: hero, bad: bad)
        let shoot = SKAction.run {
            self.badShoot(sprite: bad)
        }
        let shootTwo = SKAction.run {
            self.dualShoot(sprite: bad)
        }
        let delay = SKAction.wait(forDuration: 0.1)
        let seq = SKAction.sequence([track, delay])
        let shootDelay = SKAction.wait(forDuration: 0.85)
        let seqShoot = SKAction.sequence([shootDelay, shootTwo, shootDelay, shoot])
        let shooter = SKAction.repeatForever(seqShoot)
        let aim = SKAction.repeatForever(seq)
        
        addChild(bad)
        bad.run(shooter)
        bad.run(aim)
    }
    func SpawnCac() {
        let Cac = SKSpriteNode(imageNamed: "Cactus2.0")
        let minX = Double(ScreenSize.width * -0.5)
        let maxX = Double(ScreenSize.width * 0.5)
        let minY = Double(ScreenSize.height * -0.5)
        let maxY = Double(ScreenSize.height * 0.5)
        let randX = Double.random(in: (minX...maxX))
        let randY = Double.random(in: (minY...maxY))
        Cac.scaleTo(screenWidthPercentage: 0.15)
        Cac.position = CGPoint(x: randX, y: randY)
        Cac.name = "Cac"
        Cac.zRotation = -1.57
        addChild(Cac)
    }
    
    @objc lazy var hero: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "Bad2.0")
        sprite.position = CGPoint.zero
        sprite.zPosition = NodesZPosition.hero.rawValue
        sprite.scaleTo(screenWidthPercentage: 0.1)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.hero
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.badBullet
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.badBullet
        sprite.name = "hero"
        return sprite
    }()
    
      lazy var analogJoystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: UIImage.init(named: "Joy"), stick: UIImage.init(named: "Feet2.0")))
        js.position = CGPoint(x: ScreenSize.width * -0.3, y: ScreenSize.height * 0.38)
        js.zPosition = NodesZPosition.joystick.rawValue
        return js
      }()
    lazy var analogJoystickTwo: AnalogJoystick = {
        let js = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: UIImage.init(named: "Joy"), stick: UIImage.init(named: "Crosshair")))
        js.position = CGPoint(x: ScreenSize.width * -0.5 + 90, y: ScreenSize.height * -0.5 + 80)
        js.zPosition = NodesZPosition.joystick.rawValue
        return js
    }()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playButton(view: view)
        ScoreBoard(view: view)
        addChild(background)
        view.addSubview(resetButton)
        resetButton.isHidden = true
        highScoreLabel.position = CGPoint(x: ScreenSize.width * 0, y: ScreenSize.height * 0.2)
        highScoreLabel.fontName = "Chalkduster"
        highScoreLabel.fontSize = 20
        highScoreLabel.zRotation = CGFloat(-Double.pi / 2)
        highScoreLabel.text = "High Score: \(UserDefaults().integer(forKey: "HighScore"))"
        self.addChild(highScoreLabel)
        highScoreLabel.isHidden = true
        
    }
    func clearButton(view : SKView) {
        for locView in view.subviews {
            locView.removeFromSuperview()
        }
    }

    
   @objc func setupNodes() {
        addChild(hero)
        shootTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
        BadTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
        //addChild(crossHair)
        for _ in 1...4 {
            SpawnCac()
        }
        setupJoystick()
        setupJoystickZ()
    }
    // Reset the play area
   @objc func Reset() {
        score = 0
        hero.position = CGPoint(x: 0, y: 0)
        analogJoystickTwo.removeFromParent()
        analogJoystick.removeFromParent()
        self.resetButton.isHidden = true
        highScoreLabel.isHidden = true
        setupNodes()
        
    }
    func playButton(view : SKView) {
         let gameButton = UIButton()
        let image = UIImage(named: "Draw!png")
        gameButton.setTitle("P", for: .normal)
        gameButton.frame = CGRect(x: ScreenSize.width * 0.4, y: ScreenSize.height * 0.4, width: 150, height: 100)
        gameButton.setImage(image, for: .normal)
        gameButton.transform = gameButton.transform.rotated(by: 1.57)
        gameButton.addTarget(self, action: #selector(setupNodes), for: .touchUpInside)
        gameButton.addTarget(self, action: #selector(mainButton), for: .touchUpInside)
        view.addSubview(gameButton)
    }
    @IBAction func mainButton(sender: UIButton) {
        sender.removeFromSuperview()
    }
    func setupJoystick() {
            addChild(analogJoystick)
        
            analogJoystick.trackingHandler = { [unowned self] data in
              self.hero.position = CGPoint(x: self.hero.position.x + (data.velocity.x * self.velocityMultiplier),
                                           y: self.hero.position.y + (data.velocity.y * self.velocityMultiplier))
            }
    }
    func setupJoystickZ() {
        addChild(analogJoystickTwo)
        analogJoystickTwo.trackingHandler = { [unowned self] data in
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
            addChild(bullet)
            bullet.physicsBody?.applyImpulse(vector)
            let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
                bullet.removeFromParent()
            })
    }
    var score = 0 {
        didSet {
            ScoreLabel.text = "\(score)"
        }
    }
    
    func ScoreBoard(view: SKView) {
        ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        ScoreLabel.zPosition = 40
        ScoreLabel.text = "0"
        ScoreLabel.position = CGPoint(x: ScreenSize.width * 0.4, y: 0)
        ScoreLabel.zRotation = -1.57
        addChild(ScoreLabel)
    }
    // Builds the aim action
    func buildAction(hero: SKNode, bad: SKNode) -> SKAction
    {
        return SKAction.run {
            let dx = hero.position.x - bad.position.x
            let dy = hero.position.y - bad.position.y
            let angle = atan2(dy, dx)
            bad.zRotation = angle - CGFloat(Double.pi / 2)
        }
    }
    @objc func spawnEnemy()
    {
        let randPosNumbr = arc4random() % 4
        switch randPosNumbr {
        case 0:
            spawnDual()
            break
        default:
            spawnBad()
            break
        }
    }
    // Shoot func for the enemies
    func badShoot(sprite : SKNode) {
        
            let gunx = sprite.position.x + 15
            let guny = sprite.position.y + 15
            let converted = sprite.convert(CGPoint(x: gunx, y: guny), to: sprite)
            
            // Determine the direction of the bullet based on the character's rotation
            let vector = rotate(vector: CGVector(dx: 0.25, dy: 0), angle:sprite.zRotation+rotationOffset)
            
            // Create a bullet with a physics body
            let bullet = SKSpriteNode(color: UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size:CGSize(width: 4,height: 4))
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 2)
            bullet.physicsBody?.affectedByGravity = false
            bullet.position = CGPoint(x: converted.x, y: converted.y)
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.badBullet
            bullet.physicsBody?.collisionBitMask = PhysicsCategory.hero
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.hero
            bullet.name = "badBullet"
            addChild(bullet)
            bullet.physicsBody?.applyImpulse(vector)
            let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
                bullet.removeFromParent()
            })
        
    }
    //Spawns two gunned enemy
    func dualShoot(sprite : SKNode) {
        
        let gunx = sprite.position.x - 15
        let guny = sprite.position.y - 15
        let converted = sprite.convert(CGPoint(x: gunx, y: guny), to: sprite)
        
        // Determine the direction of the bullet based on the character's rotation
        let vector = rotate(vector: CGVector(dx: 0.25, dy: 0), angle:sprite.zRotation+rotationOffset)
        
        // Create a bullet with a physics body
        let bullet = SKSpriteNode(color: UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size:CGSize(width: 4,height: 4))
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        bullet.physicsBody?.affectedByGravity = false
        bullet.position = CGPoint(x: converted.x, y: converted.y)
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.badBullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.hero
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.hero
        bullet.name = "badBullet"
        addChild(bullet)
        bullet.physicsBody?.applyImpulse(vector)
        let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
            bullet.removeFromParent()
        })
        
    }
}
