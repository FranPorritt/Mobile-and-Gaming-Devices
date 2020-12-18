//
//  GameScene.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 14/11/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import CoreMotion
import SpriteKit

class GameScene: SKScene
{
    var topBoundary: SKSpriteNode!
    var bottomBoundary: SKSpriteNode!
    
    var gameTimer: Timer?
    var difficultyTimer: Timer?
    var hitTimer: Timer?
    var enemySpawnRate: Double = 1.75
    
    let player = SKSpriteNode(imageNamed: "player")
    var chickenSize: CGFloat!
    let playerTex = SKTexture(imageNamed: "player")
    var playtex: SKAction!
    let hitTex = SKTexture(imageNamed: "playerHit")
    var hit: SKAction!
    
    var projectileSize: CGFloat!
    var impulse: CGVector!
    
    var playerLives: Int = 3
    let livesLabel = SKLabelNode(text: "Lives: 3")
    
    var score: Int = 0
    let scoreLabel = SKLabelNode(text: "Score: 0")
    var enemyPoints: Int = 10
    
    var font: String = "AvenirNext-Heavy"
    
    var motion: CMMotionManager!
    var gyroTimer: Timer?
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    
    var touchedNode: SKNode!
    var touching: Bool = false
    
    var canMoveLeft: Bool = true
    var canMoveRight: Bool = true
    
    override func didMove(to view: SKView)
    {
        setupPhysics()
        layoutScene()
        //motion = CMMotionManager()
        //startGyro()
    }
    
    func setupPhysics()
    {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
    }
    
    func createBoundaries()
    {
        topBoundary = SKSpriteNode()
        topBoundary.size = CGSize(width: frame.width, height: 10)
        topBoundary.position = CGPoint(x: frame.midX, y: frame.maxY + (chickenSize * 2))
        topBoundary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: topBoundary.size.width, height: topBoundary.size.height))
        topBoundary.physicsBody?.categoryBitMask = PhysicsCategories.boundaryCategory
        topBoundary.physicsBody?.isDynamic = false
        addChild(topBoundary)
        
        bottomBoundary = SKSpriteNode()
        bottomBoundary.size = CGSize(width: frame.width, height: 10)
        bottomBoundary.position = CGPoint(x: frame.midX, y: frame.minY - chickenSize)
        bottomBoundary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bottomBoundary.size.width, height: bottomBoundary.size.height))
        bottomBoundary.physicsBody?.categoryBitMask = PhysicsCategories.boundaryCategory
        bottomBoundary.physicsBody?.isDynamic = false
        addChild(bottomBoundary)
    }
    
    @objc func increaseDifficulty() // Increases enemy spawn rate every x seconds
    {
        gameTimer?.invalidate() // Stops timer and restarts each time the spawn rate is increased
        gameTimer = Timer.scheduledTimer(timeInterval: enemySpawnRate, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true) //REMEMBER TO INVALIDATE WHEN DONE WITH IT
        
        enemySpawnRate -= 0.25
    }
    
    func layoutScene()
    {
        chickenSize = frame.size.width/5 - 10
        projectileSize = frame.size.width/10
        backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
        
        createBoundaries() // Destroys projectiles and enemies once off screen
        
        createLabel(label: livesLabel, size: 20.0, color: UIColor.white, pos: CGPoint(x: frame.minX + 70, y: frame.maxY - 50))
        createLabel(label: scoreLabel, size: 20.0, color: UIColor.white, pos: CGPoint(x: frame.maxX - 70, y: frame.maxY - 50))
        
        createButtons()
        createPlayer()
        
        increaseDifficulty()
        difficultyTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(increaseDifficulty), userInfo: nil, repeats: true)
    }
    
    // Started working on movement control based on user tilting the device - couldn't test due to mac access so it has not been finished.
    /*func startGyro()
    {
        if motion.isGyroAvailable
        {
            self.motion.gyroUpdateInterval = 1.0/60.0
            self.motion.startGyroUpdates()
               
            self.gyroTimer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (timer) in
                   
                if let data = self.motion.gyroData{
                       let y = data.rotationRate.y
                        self.playerMovement(gyroValue: y)
                }
            })
               
            RunLoop.current.add(self.gyroTimer!, forMode: RunLoop.Mode.default)
        }
    }*/
    
    func createLabel(label: SKLabelNode, size: CGFloat, color: UIColor, pos: CGPoint)
    {
        label.fontName = font
        label.fontSize = size
        label.fontColor = color
        label.position = pos
        addChild(label)
    }
    
    func createButtons()
    {
        leftButton =  SKSpriteNode(imageNamed: "button")
        leftButton.size = CGSize(width: frame.width/2.5, height: frame.width/5)
        leftButton.position = CGPoint(x: frame.midX - frame.width/4, y: frame.minY + leftButton.size.height)
        
        rightButton =  SKSpriteNode(imageNamed: "button")
        rightButton.size = CGSize(width: frame.width/2.5, height: frame.width/5)
        rightButton.position = CGPoint(x: frame.midX + frame.width/4, y: frame.minY + rightButton.size.height)
        
        addChild(leftButton)
        addChild(rightButton)
    }
    
    func createPlayer()
    {
        playtex = SKAction.setTexture(playerTex)
        hit = SKAction.setTexture(hitTex)
        player.run(playtex)
        
        player.size = CGSize(width: chickenSize, height: chickenSize)
        player.position = CGPoint(x: frame.midX, y: frame.minY + chickenSize * 3)
        
        // Basic physics to recognise collisions with enemy -- no tilt control
        player.physicsBody = SKPhysicsBody(circleOfRadius: chickenSize/2)
        player.physicsBody?.categoryBitMask = PhysicsCategories.playerCategory
        player.physicsBody?.contactTestBitMask = PhysicsCategories.boundaryCategory
        player.physicsBody?.isDynamic = false // Doesn't move -- temp until tilt implemented
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        addChild(player)
    }
    
    func move(direction: String)
    {
        switch(direction)
        {
        case "left":
            if player.position.x >= frame.minX + chickenSize * 1.5
            {
            let moveLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.2)
            player.run(moveLeft)
            }
        break
        
        case "right":
            if player.position.x <= frame.maxX - chickenSize * 1.5
            {
            let moveRight = SKAction.moveBy(x: 10, y: 0, duration: 0.2)
            player.run(moveRight)
            }
        break
        
        default:
        break
        }
    }
    
    @objc func spawnEnemy()
    {
        let enemy = SKSpriteNode(imageNamed: "zombie")
        enemy.size = CGSize(width: chickenSize, height: chickenSize)
        
        let randomPos = CGFloat.random(in: frame.minX + enemy.size.width/2 ... frame.maxX - enemy.size.width/2)
        enemy.position = CGPoint(x: randomPos, y: frame.maxY + chickenSize) // spawns just off screen
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: chickenSize/2)
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.enemyCategory
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.playerCategory | PhysicsCategories.boundaryCategory | PhysicsCategories.projectileCategory
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(enemy)
    }
    
    func spawnProjectile() // Should limit how many can be fired in a time frame?
    {
        let projectile = SKSpriteNode(imageNamed: "cure")
        projectile.size = CGSize(width: projectileSize/3, height: projectileSize)
        projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectileSize/2)
        projectile.physicsBody?.categoryBitMask = PhysicsCategories.projectileCategory
        projectile.physicsBody?.contactTestBitMask = PhysicsCategories.enemyCategory | PhysicsCategories.boundaryCategory
        projectile.physicsBody?.affectedByGravity = false // goes up screen rather than down
        
        addChild(projectile)
        
        impulse = CGVector(dx: 0, dy: 60)
        projectile.physicsBody?.applyImpulse(impulse)
    }
    
    func enemyCollision()
    {
        player.run(hit)
        
        hitTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(hitEffect), userInfo: nil, repeats: false)
        
        playerLives -= 1
        updateLivesLabel()
        print ("ENEMY HIT PLAYER" + String(playerLives))
        
        if playerLives == 0
        {
            gameOver()
        }
    }
    
    @objc func hitEffect()
    {
        player.run(playtex)
    }
    
    func enemyCured() // hit by cure projectile
    {
        print ("ENEMY CURED")
        updateScoreLabel(addScore: enemyPoints)
        // points
        // effects?
    }
    
    func fire()
    {
        spawnProjectile()
        // control ammo || cool down
        // need to despawn when off screen
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touching = true
        for touch in touches
        {
            let location = touch.location(in:self)
            touchedNode = atPoint(location)
        
            if touchedNode != leftButton && touchedNode != rightButton
            {
                fire()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touching = false
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if touching
        {
            if touchedNode == leftButton
            {
                print("LEFT BUTTON TOUCH")
                move(direction: "left")
            }
            else if touchedNode == rightButton
            {
                print("RIGHT BUTTON TOUCH")
                move(direction: "right")
            }
        }
    }
    
    func updateLivesLabel()
    {
        livesLabel.text = "Lives: \(playerLives)"
    }
    
    func updateScoreLabel(addScore: Int)
    {
        score += addScore
        scoreLabel.text = "Score: \(score)"
    }
    
    func gameOver()
    {
        UserDefaults.standard.set(score, forKey: "LastScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore")
        {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let endScreen = EndScreen(size: view!.bounds.size)
        view!.presentScene(endScreen)
    }
}

extension GameScene: SKPhysicsContactDelegate
{
    func didBegin(_ contact: SKPhysicsContact)
    {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.enemyCategory | PhysicsCategories.playerCategory
        {
            enemyCollision()
        }
        else if contactMask == PhysicsCategories.enemyCategory | PhysicsCategories.projectileCategory
        {
            // Destroys both projectile and enemy
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            enemyCured() // add points
        }
        else if contactMask == PhysicsCategories.boundaryCategory | PhysicsCategories.projectileCategory
        {
            print ("PROJECTILE OFF SCREEN")
            contact.bodyB.node?.removeFromParent()
        }
        else if contactMask == PhysicsCategories.boundaryCategory | PhysicsCategories.enemyCategory
        {
            print ("ENEMY OFF SCREEN")
            contact.bodyB.node?.removeFromParent()
        }
    }
}
