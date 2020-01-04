import SpriteKit
import AVFoundation
struct PhysicsCategory {
    static let bad: UInt32 = 0x1 << 0
    static let bullet : UInt32 = 0x1 << 1
    static let hero : UInt32 = 0x1 << 2
    static let badBullet : UInt32 = 0x1 << 3
    static let dual : UInt32 = 0x1 << 4
    static let short : UInt32 = 0x1 << 5
    static let cac : UInt32 = 0x1 << 6
    static let power : UInt32 = 0x1 << 7
}
class Gameplay: SKScene, SKPhysicsContactDelegate {
    var hero: Player!
    var heroLegs: PlayerLegs!
    var BadTimer = Timer(), shootTimer = Timer(), walkingTimer = Timer(), immuneTimer = Timer(), deadEyeShotTimer = Timer(), deadEyeTimer = Timer(), speedTimer = Timer()
    var sound: AVAudioPlayer?
    var ScoreLabel = SKLabelNode()
    var velocityMultiplier: CGFloat = 0.07
    var gameTimer: Timer?
    var nodeToRemove = [SKNode](), textureArray = [SKTexture](), horseRunArray = [SKTexture](), rickArray = [SKTexture](), kricArray = [SKTexture](), jeanArray = [SKTexture](), goldArray = [SKTexture]()
    var walking = false, riding = false, isImmune = false, onHorse = false
    var gold = UserDefaults().integer(forKey: "gold")
    var walkArray: WalkingAnimation = WalkingAnimation()
    let minX = Double(ScreenSize.width * -0.5 + 10), maxX = Double(ScreenSize.width * 0.5 - 10), minY = Double(ScreenSize.height * -0.5 + 10), maxY = Double(ScreenSize.height * 0.5 - 10)
    
    enum NodesZPosition: CGFloat {
        case background, hero, joystick
    }
    func didBegin( _ contact: SKPhysicsContact)
    {
        let firstBody = contact.bodyA.node as! SKSpriteNode
        let secondBody =  contact.bodyB.node as! SKSpriteNode
        let firstName = firstBody.name
        let secondName = secondBody.name
        if (firstName == "bullet" || secondName == "bullet") {
            if (firstName == "bad" || secondName == "bad") {
                collisionBullet(bad: firstBody, bullet: secondBody)
                score += 1
                doesDropPower(pos: secondBody.position)
            }
            else if (firstName == "Dual" || secondName == "Dual") {
                collisionBullet(bad: firstBody, bullet: secondBody)
                score += 2
                doesDropPower(pos: secondBody.position)
            }
            else if (firstName == "short" || secondName == "short") {
                collisionBullet(bad: firstBody, bullet: secondBody)
                score += 3
                doesDropPower(pos: secondBody.position)
            }
            else if (firstName == "Cac" || secondName == "Cac" || firstName == "wall" || secondName == "wall") {
                if secondBody.name == "bullet" {
                    nodeToRemove.append(secondBody)
                }
                else {
                    nodeToRemove.append(firstBody)
                }
            }
        }
        else if (firstName == "badBullet" || secondName == "badBullet") {
            if (firstName == "hero" || secondName == "hero") {
                collisionBullet(bad: firstBody, bullet: secondBody)
            }
            else if (firstName == "Cac" || secondName == "Cac" || firstName == "wall" || secondName == "wall") {
                if secondBody.name == "badBullet" {
                    nodeToRemove.append(secondBody)
                }
                else {
                    nodeToRemove.append(firstBody)
                }
            }
            
        }
        else if (firstName == "immune" || secondName == "immune" || firstName == "speed" || secondName == "speed" || firstName == "deadEye" || secondName == "deadEye") {
            if (firstName == "hero" || secondName == "hero") {
                if firstName == "immune" || secondName == "immune" {
                    immune()
                    if firstName == "immune" {
                        nodeToRemove.append(firstBody)
                    }
                    else {
                        nodeToRemove.append(secondBody)
                    }
                }
                else if firstName == "speed" || secondName == "speed" {
                    giddyUp()
                    if firstName == "speed" {
                        nodeToRemove.append(firstBody)
                    }
                    else {
                        nodeToRemove.append(secondBody)
                    }
                }
                else if firstName == "deadEye" || secondName == "deadEye" {
                    activateDeadEye()
                    if firstName == "deadEye" {
                        nodeToRemove.append(firstBody)
                    }
                    else {
                        nodeToRemove.append(secondBody)
                    }
                }
            }
            
        }
    }
    //Starts the players deadeye state
    func activateDeadEye() {
        deadEyeTimer.invalidate()
        deadEyeShotTimer.invalidate()
        hero.color = UIColor.red
        heroLegs.color = UIColor.red
        heroLegs.colorBlendFactor = 0.4
        hero.colorBlendFactor = 0.4
        deadEyeShotTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(deadEye), userInfo: nil, repeats: true)
        deadEyeTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(endDeadEye), userInfo: nil, repeats: false)
    }
    //Ends the players deadeye state
    @objc func endDeadEye() {
        heroLegs.colorBlendFactor = 0
        hero.colorBlendFactor = 0
        deadEyeShotTimer.invalidate()
        deadEyeTimer.invalidate()
    }
    //Aims the player at all enemies on screen and fires
    @objc func deadEye() {
        for child in self.children {
            if child.name == "bad" || child.name == "Dual" || child.name == "short" {
                let dx = child.position.x - hero.position.x
                let dy = child.position.y - hero.position.y
                let angle = atan2(dy, dx)
                hero.zRotation = angle - CGFloat(Double.pi / 2)
                shoot()
            }
        }
    }
    //makes the player immune to bullets
    func immune()
    {
        immuneTimer.invalidate()
        isImmune = true
        hero.color = UIColor.blue
        heroLegs.color = UIColor.blue
        heroLegs.colorBlendFactor = 0.4
        hero.colorBlendFactor = 0.4
        immuneTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(EndImmune), userInfo: nil, repeats: false)
        
    }
    //ends the player's immunity to bullets
    @objc func EndImmune() {
        isImmune = false
        hero.colorBlendFactor = 0
        heroLegs.colorBlendFactor = 0
    }
    //mounts the player on a horse
    func giddyUp() {
        speedTimer.invalidate()
        velocityMultiplier = 0.11
        heroLegs.scaleTo(screenWidthPercentage: 0.2)
        onHorse = true
        speedTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dismount), userInfo: nil, repeats: false)
    }
    //dismounts plyer from a horse
    @objc func dismount() {
        onHorse = false
        velocityMultiplier = 0.07
        if UserDefaults().integer(forKey: "rick") == 2 {
            heroLegs.scaleTo(screenWidthPercentage: 0.135)
        }
        else if UserDefaults().integer(forKey: "kric") == 2 {
            equipOnSkin(name: "Kric2.0", bodyScale: 0.14, legScale: 0.175, legArray: kricArray)
            heroLegs.scaleTo(screenWidthPercentage: 0.175)
        }
        else {
            heroLegs.scaleTo(screenWidthPercentage: 0.145)
        }
    }
    //removes the children of the nodes to remove list
    override func didFinishUpdate()
    {
        nodeToRemove.forEach(){$0.removeFromParent()}
        nodeToRemove = [SKSpriteNode]()
    }
    //After a bullet collision occurs this func is called to update the game state
    func collisionBullet(bad: SKSpriteNode, bullet: SKSpriteNode){
        if (bad.name == "badBullet" || bullet.name == "badBullet") && isImmune{
            if bad.name == "badBullet"{
                nodeToRemove.append(bad)
            }
            else {
                nodeToRemove.append(bullet)
            }
        }
        else {
            nodeToRemove.append(bad)
            nodeToRemove.append(bullet)
        }
        
        if (bad.name == "hero" || bullet.name == "hero") && !isImmune {
            endGame()
            if score > UserDefaults().integer(forKey: "HighScore") && UserDefaults().integer(forKey: "difficulty") == 1 {
                saveHighScore()
            }
            else if score > UserDefaults().integer(forKey: "HighScoreEasy") {
                UserDefaults().set(score, forKey: "HighScoreEasy")
            }
            let scene = Reset(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene)
        }
        
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
        label.isHidden = true
        addChild(label)
    }
    //Spawns an wall that the player can not move through
    func spawnWall(pos: CGPoint, size: CGSize) {
        let sprite = SKSpriteNode(color: UIColor.blue, size: CGSize.init(width: 5, height: 5))
        sprite.position = pos
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        sprite.name = "wall"
        sprite.physicsBody?.mass = 500
        addChild(sprite)
    }
    //saves the latest hard mode highscore
    func saveHighScore() {
        UserDefaults().set(score, forKey: "HighScore")
    }
    lazy var background: SKSpriteNode = {
        var sprite = SKSpriteNode(color: UIColor(displayP3Red: 200/255, green: 170/255, blue: 120/255, alpha: 1.0), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        sprite.texture = SKTexture(imageNamed: "sand2")
        sprite.position = CGPoint.zero
        sprite.zPosition = -1000
        sprite.scaleTo(screenWidthPercentage: 1.0)
        sprite.name = "background"
        return sprite
    }()
    
    var score = 0{
        didSet {
            ScoreLabel.text = "\(score)"
        }
    }
    //Sets up the score board
    func ScoreBoard() {
        ScoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        ScoreLabel.zPosition = 40
        ScoreLabel.fontColor = UIColor.black
        ScoreLabel.text = "0"
        ScoreLabel.fontSize = (UIDevice.current.userInterfaceIdiom == .pad) ? 30: 25
        ScoreLabel.color = UIColor.black
        ScoreLabel.position = CGPoint(x: ScreenSize.width * 0.4, y: 0)
        ScoreLabel.zRotation = -1.57
        ScoreLabel.name = "gameLabel"
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
    //Ends the game
    func endGame() {
        shootTimer.invalidate()
        BadTimer.invalidate()
        immuneTimer.invalidate()
        speedTimer.invalidate()
        EndImmune()
        endDeadEye()
        dismount()
        gold += score
        updateGold()
        UserDefaults().set(score, forKey: "Score")
        for child in self.children {
            if child.name != "wall" && child.name != "button" && child.name != "background" && child.name != "gameLabel" && child.name != "joy" {
                nodeToRemove.append(child)
            }
        }
    }
    //Updates the gold index and label
    func updateGold() {
        UserDefaults().set(gold, forKey: "gold")
    }
    //Rolls to see if a dead enemy spawns a power up
    func doesDropPower(pos: CGPoint) {
        let chance = Int.random(in: 0...99)
        if chance <= 14 {
            spawnPower(pos: pos)
        }
    }
    //Spawns Powerup at a point
    func spawnPower(pos: CGPoint) {
        let power = Power(pos: pos)
        addChild(power)
    }
    func PlaySound(name: String, type: String){
        let path = Bundle.main.path(forResource: name, ofType: type)!
        let url = URL(fileURLWithPath: path)
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.play()
        } catch {
            print("Can't find ", name)
        }
    }
    // Spawns basic enemy
    @objc func spawnBad() {
        var randX = Double.random(in: (minX...maxX))
        var randY = Double.random(in: (minY...maxY))
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY > Double(ScreenSize.height * -0.5) && randY < Double(ScreenSize.height * -0.3)) {
            randX += 100
            randY = 0
        }
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY < Double(ScreenSize.height * 0.5) && randY > Double(ScreenSize.height * 0.3)) {
            randX += 100
            randY = 0
        }
        let bad = Bad(X: randX, Y: randY)
        var shot = 1.3
        if UserDefaults().integer(forKey: "difficulty") == 0 {
            shot = 1.75
        }
        let track = buildAction(hero: hero, bad: bad)
        let shoot = SKAction.run {
            self.badShoot(sprite: bad)
        }
        let delay = SKAction.wait(forDuration: 0.1)
        let seq = SKAction.sequence([track, delay])
        let shootDelay = SKAction.wait(forDuration: shot)
        let seqShoot = SKAction.sequence([shootDelay, shoot])
        addChild(bad)
        bad.run(SKAction.repeatForever(seqShoot))
        bad.run(SKAction.repeatForever(seq))
    }
    //Spawns enemy that moves
    @objc func spawnShort() {
        var randX = Double.random(in: (minX...maxX))
        var randY = Double.random(in: (minY...maxY))
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY > Double(ScreenSize.height * -0.5) && randY < Double(ScreenSize.height * -0.3)) {
            randX += 100
            randY = 0
        }
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY < Double(ScreenSize.height * 0.5) && randY > Double(ScreenSize.height * 0.3)) {
            randX += 100
            randY = 0
        }
        let short = Short(X: randX, Y: randY)
        let track = buildAction(hero: hero, bad: short)
        let shoot = SKAction.run {
            self.badShoot(sprite: short)
        }
        let delay = SKAction.wait(forDuration: 0.1)
        let seq = SKAction.sequence([track, delay])
        let mve = SKAction.move(to: hero.position, duration: 2.5)
        let shootDelay = SKAction.wait(forDuration: 0.7)
        let mover = SKAction.sequence([shootDelay, mve])
        let seqShoot = SKAction.sequence([shootDelay, shoot])
        addChild(short)
        short.run(SKAction.repeatForever(mover))
        short.run(SKAction.repeatForever(seqShoot))
        short.run(SKAction.repeatForever(seq))
    }
    //Spawns enemy with two guns
    func spawnDual() {
        var randX = Double.random(in: (minX...maxX))
        var randY = Double.random(in: (minY...maxY))
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY > Double(ScreenSize.height * -0.5) && randY < Double(ScreenSize.height * -0.3)) {
            randX += 100
            randY = 0
        }
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY < Double(ScreenSize.height * 0.5) && randY > Double(ScreenSize.height * 0.3)) {
            randX += 100
            randY = 0
        }
        var shot = 0.75
        if UserDefaults().integer(forKey: "difficulty") == 0 {
            shot = 1.25
        }
        let bad = Dual(X: randX, Y: randY)
        let track = buildAction(hero: hero, bad: bad)
        let shoot = SKAction.run {
            self.badShoot(sprite: bad)
        }
        let shootTwo = SKAction.run {
            self.dualShoot(sprite: bad)
        }
        let delay = SKAction.wait(forDuration: 0.1)
        let seq = SKAction.sequence([track, delay])
        
        let shootDelay = SKAction.wait(forDuration: shot)
        let seqShoot = SKAction.sequence([shootDelay, shootTwo, shootDelay, shoot])
        
        addChild(bad)
        bad.run(SKAction.repeatForever(seqShoot))
        bad.run(SKAction.repeatForever(seq))
    }
    //Spawns an enemy based on the current score
    @objc func spawnEnemy()
    {
        let number = Int.random(in: 0 ... score + 1)
        if number <= 6 {
            spawnBad()
        }
        if number > 6 && number < 17 {
            spawnDual()
        }
        if number >= 17 {
            if UserDefaults().integer(forKey: "difficulty") == 0 {
                spawnDual()
            }
            else {
                spawnShort()
            }
        }
        
    }
    //Spawns a cactus at a semi-random spot on the screen
    func SpawnCac() {
        var randX = Double.random(in: (minX...maxX))
        var randY = Double.random(in: (minY...maxY))
        //stops cacti from spawning in the center
        if randY > Double(ScreenSize.height * -0.05) && randY < 0 {
            randY -= 200
        }
        if randY < Double(ScreenSize.height * 0.05) && randY > 0 {
            randY += 200
        }

        //stops cacti from spawning under Joysticks
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY > Double(ScreenSize.height * -0.5) && randY < Double(ScreenSize.height * -0.3)) {
            randX += 150
        }
        if (randX > Double(ScreenSize.width * -0.5) && randX < Double(ScreenSize.width * -0.2)) && (randY < Double(ScreenSize.height * 0.5) && randY > Double(ScreenSize.height * 0.3)) {
            randX += 150
        }
        let cac = Cactus(X: randX, Y: randY)
        addChild(cac)
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ScoreBoard()
        SoundController.shared.run("GunCocking.mp3", node: self)
        rickArray = walkArray.rickArray as! [SKTexture]
        kricArray = walkArray.kricArray as! [SKTexture]
        jeanArray = walkArray.jeanArray as! [SKTexture]
        goldArray = walkArray.goldArray as! [SKTexture]
        horseRunArray = walkArray.horseArray as! [SKTexture]
        addChild(background)
        spawnWall(pos: CGPoint(x: 0, y: ScreenSize.height * -0.5 - 20), size: CGSize(width: ScreenSize.width, height: 5))
        spawnWall(pos: CGPoint(x: 0, y: ScreenSize.height * 0.5 + 20), size: CGSize(width: ScreenSize.width, height: 5))
        spawnWall(pos: CGPoint(x: ScreenSize.width * 0.5 + 20, y: 0), size: CGSize(width: 5, height: ScreenSize.height))
        spawnWall(pos: CGPoint(x: ScreenSize.width * -0.5 - 20, y: 0), size: CGSize(width: 5, height: ScreenSize.height))
        setupJoystick()
        setupJoystickZ()
        textureArray = rickArray
        setupNodes()
    }
    //Sets up new game
    @objc func setupNodes() {
        hero = Player()
        heroLegs = PlayerLegs()
        addChild(hero)
        addChild(heroLegs)
        if UserDefaults().integer(forKey: "difficulty") == 1 {
            shootTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
            BadTimer = Timer.scheduledTimer(timeInterval: 4.2, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
        }
        else {
            shootTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
            BadTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
        }
        for _ in 1...4 {
            SpawnCac()
        }
        UserDefaults().set(0, forKey: "Score")
        putOnSkin()
    }
    //Changes the players skin
    func equipOnSkin(name: String, bodyScale: CGFloat, legScale: CGFloat, legArray: [SKTexture]) {
        hero.texture = SKTexture(imageNamed: name)
        hero.scaleTo(screenWidthPercentage: bodyScale)
        heroLegs.scaleTo(screenWidthPercentage: legScale)
        textureArray = legArray
    }
    //Puts on the players selected skin
    func putOnSkin() {
        if UserDefaults().integer(forKey: "rick") == 2{
            equipOnSkin(name: "Bad4", bodyScale: 0.14, legScale: 0.135, legArray: rickArray)
        }
        else if UserDefaults().integer(forKey: "kric") == 2 {
            equipOnSkin(name: "Kric2.0", bodyScale: 0.14, legScale: 0.175, legArray: kricArray)
        }
        else if UserDefaults().integer(forKey: "blue") == 2 {
            equipOnSkin(name: "babyBlue", bodyScale: 0.14, legScale: 0.145, legArray: jeanArray)
        }
        else if  UserDefaults().integer(forKey: "plaid") == 2 {
            equipOnSkin(name: "plaid3.0", bodyScale: 0.14, legScale: 0.145, legArray: jeanArray)
        }
        else if UserDefaults().integer(forKey: "goldSkin") == 2 {
            equipOnSkin(name: "solidGold", bodyScale: 0.145, legScale: 0.145, legArray: goldArray)
        }
        
    }
    lazy var analogJoystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: ScreenSize.height * 0.14, colors: nil, images: (substrate: UIImage.init(named: "Joy"), stick: UIImage.init(named: "Feet2.0")))
        js.position = CGPoint(x: ScreenSize.width * -0.325, y: ScreenSize.height * 0.375)
        js.zPosition = NodesZPosition.joystick.rawValue
        js.name = "joy"
        return js
    }()
    lazy var analogJoystickTwo: AnalogJoystick = {
        let js = AnalogJoystick(diameter: ScreenSize.height * 0.14, colors: nil, images: (substrate: UIImage.init(named: "Joy"), stick: UIImage.init(named: "Crosshair")))
        js.position = CGPoint(x: ScreenSize.width * -0.325, y: ScreenSize.height * -0.375)
        js.zPosition = NodesZPosition.joystick.rawValue
        js.name = "joy"
        return js
    }()
    //Sets up the movement joystick
    func setupJoystick() {
        addChild(analogJoystick)
        
        analogJoystick.trackingHandler = { [unowned self] data in
            self.hero.position = CGPoint(x: self.hero.position.x + (data.velocity.x * self.velocityMultiplier),
                                         y: self.hero.position.y + (data.velocity.y * self.velocityMultiplier))
            self.heroLegs.position = self.hero.position
            self.heroLegs.zRotation = data.angular
            if !self.onHorse {
                self.walk()
            }
            else {
                self.rideHorse()
            }
        }
    }
    //Sets up the aiming joystick
    func setupJoystickZ() {
        addChild(analogJoystickTwo)
        analogJoystickTwo.trackingHandler = { [unowned self] data in
            self.hero.zRotation = data.angular
            
        }
    }
    //Changes the state of walking
    func walk(){
        if !walking {
            walking = true
            self.heroLegs.run(SKAction.animate(with: self.textureArray, timePerFrame: 0.2))
            walkingTimer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector: #selector(endWalking), userInfo: nil, repeats: false)
        }
    }
    //Ends the walking state
    @objc func endWalking() {
        walking = false
    }
    //Changes the state of riding
    func rideHorse() {
        if !riding {
            riding = true
            self.heroLegs.run(SKAction.animate(with: self.horseRunArray, timePerFrame: 0.2))
            walkingTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(endRiding), userInfo: nil, repeats: false)
        }
    }
    //Ends the state of riding
    @objc func endRiding() {
        riding = false
    }
    func rotate(vector:CGVector, angle:CGFloat) -> CGVector {
        let rotatedX = vector.dx * cos(angle) - vector.dy * sin(angle)
        let rotatedY = vector.dx * sin(angle) + vector.dy * cos(angle)
        return CGVector(dx: rotatedX, dy: rotatedY)
    }
    let rotationOffset = CGFloat(Double.pi/2)
    //Fires the players weapon
    @objc func shoot() {
        // TODO: why this magic #? should be calculation of the sprite size
        let gunx = self.position.x + hero.size.width * 0.3
        let guny = self.position.y + hero.size.height * 0.3
        let converted = hero.convert(CGPoint(x: gunx, y: guny), to: self)
        
        // Determine the direction of the bullet based on the character's rotation
        let vector = rotate(vector: CGVector(dx: 35, dy: 0), angle:hero.zRotation+rotationOffset)
        
        // Create a bullet with a physics body
        let bullet = Bullet(name: "bullet")
        if UserDefaults().integer(forKey: "goldSkin") == 2 {
            bullet.color = UIColor.yellow
        }
        SoundController.shared.GunSound(self)
        //run(SKAction.playSoundFileNamed("GunShot.caf", waitForCompletion: true))
        //self.run(gunShot)
        bullet.position = CGPoint(x: converted.x, y: converted.y)
        addChild(bullet)
        bullet.physicsBody?.applyImpulse(vector)
        
    }
    // Shoot func for the enemies
    func badShoot(sprite : SKSpriteNode) {
        let bulletSpead = (UserDefaults().integer(forKey: "difficulty") == 0) ? 23 : 35;
        let gunx = sprite.position.x + sprite.size.width * 0.3
        let guny = sprite.position.y
        let converted = sprite.convert(CGPoint(x: gunx, y: guny), to: sprite)
        
        // Determine the direction of the bullet based on the character's rotation
        let vector = rotate(vector: CGVector(dx: bulletSpead, dy: 0), angle:sprite.zRotation+rotationOffset)
        
        // Create a bullet with a physics body
        let bullet = Bullet(name: "badBullet")
        SoundController.shared.GunSound(self)
        bullet.position = CGPoint(x: converted.x, y: converted.y)
        addChild(bullet)
        //PlaySound(name: "GunShot", type: "mp3")
        bullet.physicsBody?.applyImpulse(vector)
    }
    //Shoots two gunned enemy's other gun
    func dualShoot(sprite : SKNode) {
        let bulletSpead = (UserDefaults().integer(forKey: "difficulty") == 0) ? 23 : 35;
        let gunx = sprite.position.x - 15
        let guny = sprite.position.y - 15
        let converted = sprite.convert(CGPoint(x: gunx, y: guny), to: sprite)
        
        // Determine the direction of the bullet based on the character's rotation
        let vector = rotate(vector: CGVector(dx: bulletSpead, dy: 0), angle:sprite.zRotation+rotationOffset)
        SoundController.shared.GunSound(self)
        // Create a bullet with a physics body
        let bullet = Bullet(name: "badBullet")
        bullet.position = CGPoint(x: converted.x, y: converted.y)
        addChild(bullet)
        bullet.physicsBody?.applyImpulse(vector)
    }
}
