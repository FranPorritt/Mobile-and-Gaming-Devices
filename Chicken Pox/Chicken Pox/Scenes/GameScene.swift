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
    var powerTimer: Timer?
    var coolDownTimer: Timer?
    var scoreTimer: Timer?
    var spawnPowerUpTimer: Timer?
    var invincibleTimer: Timer?
    
    var enemySpawnRate: Double = 1.75
    var difficultyRate: Double = 0.1
    var coolDownRate: Double = 0.15
        
    let player = SKSpriteNode(imageNamed: "player")
    var chickenSize: CGFloat!
    let playerTex = SKTexture(imageNamed: "player")
    var playtex: SKAction!
    let hitTex = SKTexture(imageNamed: "playerHit")
    var hit: SKAction!
    var friendTex = SKTexture(imageNamed: "friend")
    var friend: SKAction!
    var shieldTex = SKTexture(imageNamed: "playerShield")
    var shield: SKAction!
    
    var projectileSize: CGFloat!
    var impulse: CGVector!
    var coolDown: Bool = false
    
    var playerLives: Int = 3
    let livesLabel = SKLabelNode(text: "Lives: 3")
    
    var score: Int = 0
    let scoreLabel = SKLabelNode(text: "Score: 0")
    var enemyPoints: Int = 10
    
    var font: String = "AvenirNext-Heavy"
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var touchedNode: SKNode!
    var touching: Bool = false
    
    var powerUses: Int = 3
    var powerLabel = SKLabelNode(text: "Power Moves: 3")
    
    var timerArray = [Timer]()
    
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
        
        if !view!.isPaused // If game isn't paused
        {
            gameTimer = Timer.scheduledTimer(timeInterval: enemySpawnRate, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
        
            if enemySpawnRate >= 0.4
            {
                if enemySpawnRate <= 0.6
                {
                    enemySpawnRate -= difficultyRate / 2 // Slows down slightly so loads don't suddenly start spawning
                }
                else
                {
                    enemySpawnRate -= difficultyRate // Decreases time between each enemy spawn
                }
            }
        }
    }
    
    func layoutScene()
    {
        chickenSize = frame.size.width/5 - 10
        projectileSize = frame.size.width/10
        backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
        
        createBoundaries() // Destroys projectiles and enemies once off screen
        
        createLabel(label: livesLabel, size: 17.0, color: UIColor.white, pos: CGPoint(x: frame.minX + 70, y: frame.maxY - 70))
        createLabel(label: scoreLabel, size: 17.0, color: UIColor.white, pos: CGPoint(x: frame.maxX - 70, y: frame.maxY - 70))
        createLabel(label: powerLabel, size: 17.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.maxY - 70))
        
        createButtons()
        createPlayer()
        
        increaseDifficulty()
        createTimers()
    }
    
    func createTimers()
    {
        timerArray.removeAll()
        
        if enemySpawnRate >= 0.4 // Not needed once ideal spawn rate is reached
        {
            difficultyTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(increaseDifficulty), userInfo: nil, repeats: true)
            difficultyTimer?.tolerance = difficultyTimer!.timeInterval * 0.1 // Sets tolerance to 10%
        }
               
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addTimeScore), userInfo: nil, repeats: true)
        scoreTimer?.tolerance = scoreTimer!.timeInterval * 0.1
               
        spawnPowerUpTimer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(spawnInvincibilty), userInfo: nil, repeats: true)
        spawnPowerUpTimer?.tolerance = spawnPowerUpTimer!.timeInterval * 0.1
        
        timerArray.append(difficultyTimer!)
        timerArray.append(scoreTimer!)
        timerArray.append(spawnPowerUpTimer!)
    }
    
    @objc func addTimeScore()
    {
        if !view!.isPaused // If game isn't paused
        {
            updateScoreLabel(addScore: 10)
        }
    }
    
    func controlTimers(state: Bool)
    {
        switch state
        {
        case true:
            for timer in timerArray
            {
                timer.invalidate()
            }
            timerArray.removeAll()
            break
            
        case false:
            createTimers()
            break
            
        }
    }
    
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
        leftButton.position = CGPoint(x: frame.midX - frame.width/4, y: frame.minY + leftButton.size.height * 1.25)
        
        rightButton =  SKSpriteNode(imageNamed: "button")
        rightButton.size = CGSize(width: frame.width/2.5, height: frame.width/5)
        rightButton.position = CGPoint(x: frame.midX + frame.width/4, y: frame.minY + rightButton.size.height * 1.25)
        
        addChild(leftButton)
        addChild(rightButton)
    }
    
    func createPlayer()
    {
        playtex = SKAction.setTexture(playerTex)
        hit = SKAction.setTexture(hitTex)
        shield = SKAction.setTexture(shieldTex)
        player.run(playtex)
        
        player.size = CGSize(width: chickenSize, height: chickenSize)
        player.position = CGPoint(x: frame.midX, y: frame.minY + chickenSize * 3)
        
        // Basic physics to recognise collisions with enemy -- no tilt control
        player.physicsBody = SKPhysicsBody(circleOfRadius: chickenSize/2)
        player.physicsBody?.categoryBitMask = PhysicsCategories.playerCategory
        player.physicsBody?.contactTestBitMask = PhysicsCategories.boundaryCategory
        player.physicsBody?.isDynamic = false // Doesn't move -- temp until tilt implemented
        player.physicsBody?.allowsRotation = false
        //player.physicsBody?.linearDamping = 0.5
        
        addChild(player)
    }

    @objc func spawnEnemy()
    {
        if !view!.isPaused // Won't spawn any while game is paused (timers don't pause)
        {
            friend = SKAction.setTexture(friendTex)
        
            let enemy = SKSpriteNode(imageNamed: "zombie")
            enemy.name = "enemy"
            enemy.size = CGSize(width: chickenSize, height: chickenSize)
        
            let randomPos = CGFloat.random(in: frame.minX + enemy.size.width/2 ... frame.maxX - enemy.size.width/2)
            enemy.position = CGPoint(x: randomPos, y: frame.maxY + chickenSize) // spawns just off screen
        
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: chickenSize/2)
            enemy.physicsBody?.categoryBitMask = PhysicsCategories.enemyCategory
            enemy.physicsBody?.contactTestBitMask = PhysicsCategories.playerCategory | PhysicsCategories.boundaryCategory | PhysicsCategories.projectileCategory
            enemy.physicsBody?.collisionBitMask = PhysicsCategories.none
        
            addChild(enemy)
        }
    }
    
    func spawnProjectile()
    {
        let projectile = SKSpriteNode(imageNamed: "cure")
        projectile.size = CGSize(width: projectileSize/3, height: projectileSize)
        projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectileSize/3)
        projectile.physicsBody?.categoryBitMask = PhysicsCategories.projectileCategory
        projectile.physicsBody?.contactTestBitMask = PhysicsCategories.enemyCategory | PhysicsCategories.boundaryCategory
        projectile.physicsBody?.collisionBitMask = PhysicsCategories.none
        projectile.physicsBody?.affectedByGravity = false // goes up screen rather than down
        
        addChild(projectile)
        
        impulse = CGVector(dx: 0, dy: 30)
        projectile.physicsBody?.applyImpulse(impulse)
    }
    
    @objc func spawnInvincibilty() // Power up
    {
        let invincible = SKSpriteNode(imageNamed: "shield")
        invincible.size = CGSize(width: chickenSize, height: chickenSize)
        
        let randomPos = CGFloat.random(in: frame.minX + invincible.size.width/2 ... frame.maxX - invincible.size.width/2)
        invincible.position = CGPoint(x: randomPos, y: frame.maxY + chickenSize) // spawns just off screen
        
        invincible.physicsBody = SKPhysicsBody(circleOfRadius: chickenSize)
        invincible.physicsBody?.categoryBitMask = PhysicsCategories.invincibleCategory
        invincible.physicsBody?.contactTestBitMask = PhysicsCategories.playerCategory
        invincible.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(invincible)
    }
    
    func enemyCollision() // Removes player life and swaps textures
    {
        player.run(hit)
        
        hitTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(hitEffect), userInfo: nil, repeats: false)
        
        playerLives -= 1
        updateLivesLabel()
        
        if playerLives == 0
        {
            gameOver()
        }
    }
    
    @objc func hitEffect()
    {
        player.run(playtex)
        hitTimer?.invalidate()
    }
    
    func enemyCured() // hit by cure projectile
    {
        updateScoreLabel(addScore: enemyPoints)
    }
    
    func move(direction: String)
    {
        switch(direction)
        {
        case "left":
            if player.position.x >= frame.minX + chickenSize // Edge of screen
            {
                let moveLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.2)
                player.run(moveLeft)
            }
        break
        
        case "right":
            if player.position.x <= frame.maxX - chickenSize
            {
            let moveRight = SKAction.moveBy(x: 10, y: 0, duration: 0.2)
                player.run(moveRight)
            }
        break
        
        default:
        break
        }
    }
    
    func fire()
    {
        if !coolDown
        {
            if !view!.isPaused // Stops projectiles spawning after game is resumed
            {
                spawnProjectile()
                coolDown = true
                coolDownTimer = Timer.scheduledTimer(timeInterval: coolDownRate, target: self, selector: #selector(resetCoolDown), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func resetCoolDown()
    {
        coolDown = false
        coolDownTimer?.invalidate()
    }
    
    func powerMove()
    {
        backgroundColor = UIColor(red: 120/255, green: 50/255, blue: 210/255, alpha: 0.7)
        powerUses -= 1
        updatePowerLabel()
        
        var points: Int = 0
        for child in self.children
        {
            if child.name == "enemy" // Scatters enemies across screen and cures them
            {
                child.physicsBody?.categoryBitMask = PhysicsCategories.friendCategory
                child.run(friend)
                let impulse = CGVector(dx: CGFloat.random(in: -60 ... 60), dy: CGFloat.random(in: -60 ... 60))
                child.physicsBody?.applyImpulse(impulse)
                
                points += enemyPoints * 2   // bonus points
            }
        }
        
        if enemySpawnRate + 0.5 <= 1.3 // Less than initial rate
        {
            enemySpawnRate += 0.5 // Slows down enemy spawning so player isn't immediately overrun again
        }
        
        updateScoreLabel(addScore: points)
        powerTimer = Timer.scheduledTimer(timeInterval: 0.27, target: self, selector: #selector(resetBackground), userInfo: nil, repeats: false)
    }
    
    @objc func resetBackground()
    {
        backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
        powerTimer?.invalidate()
    }
    
    func invincible() // Stops collisions being detected
    {
        player.physicsBody?.categoryBitMask = PhysicsCategories.none
        player.run(shield)
        invincibleTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stopInvincible), userInfo: nil, repeats: false)
    }
    
    @objc func stopInvincible()
    {
        player.physicsBody?.categoryBitMask = PhysicsCategories.playerCategory
        player.run(playtex)
        invincibleTimer?.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touching = true
        for touch in touches
        {
            let location = touch.location(in:self)
            touchedNode = atPoint(location)
        
            if touchedNode != leftButton && touchedNode != rightButton // Checks if movement buttons are being pressed
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
        if touching // Registers long presses and moves player for as long as it is held down
        {
            if touchedNode == leftButton
            {
                move(direction: "left")
            }
            else if touchedNode == rightButton
            {
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
    
    func updatePowerLabel()
    {
        powerLabel.text = "Power Moves: \(powerUses)"
    }
    
    func gameOver()
    {
        UserDefaults.standard.set(score, forKey: "LastScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore")
        {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        for timer in timerArray
        {
            timer.invalidate()
        }
        gameTimer?.invalidate()
        
        let deadLabel = SKLabelNode(text: "YOU DIED!")
        createLabel(label: deadLabel, size: 65, color: UIColor.red, pos: CGPoint(x: frame.midX, y: frame.midY))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2))
        {
            NotificationCenter.default.post(name: NSNotification.Name("GameOver"), object: nil)
        }
        
        view?.isPaused = true
    }
}

extension GameScene: SKPhysicsContactDelegate
{
    func didBegin(_ contact: SKPhysicsContact)
    {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.enemyCategory | PhysicsCategories.playerCategory  // ENEMY COLLISION
        {
            enemyCollision()
        }
        else if contactMask == PhysicsCategories.enemyCategory | PhysicsCategories.projectileCategory // PROJECTILE HIT ENEMY
        {
            contact.bodyB.node?.removeFromParent()
            
            contact.bodyA.node?.run(friend) // Changes texture
            contact.bodyA.node?.physicsBody?.categoryBitMask = PhysicsCategories.friendCategory // Won't damage player
            
            var impulse = CGVector(dx: 60, dy: 0)
            if (contact.bodyA.node?.position.x)! < frame.midX // On left of screen
            {
                impulse.dx = -60
            }
            contact.bodyA.node?.physicsBody?.applyImpulse(impulse)
                      
            enemyCured() // add points
        }
        else if contactMask == PhysicsCategories.boundaryCategory | PhysicsCategories.projectileCategory // PROJECTILE OFF SCREEN
        {
            contact.bodyB.node?.removeFromParent()
        }
        else if contactMask == PhysicsCategories.boundaryCategory | PhysicsCategories.enemyCategory // ENEMY OFF SCREEN
        {
            contact.bodyB.node?.removeFromParent()
        }
        else if contactMask == PhysicsCategories.boundaryCategory | PhysicsCategories.friendCategory // FRIEND OFF SCREEN
        {
            contact.bodyB.node?.removeFromParent()
        }
        else if contactMask == PhysicsCategories.boundaryCategory | PhysicsCategories.invincibleCategory // POWER UP OFF SCREEN
        {
            contact.bodyB.node?.removeFromParent()
        }
        else if contactMask == PhysicsCategories.playerCategory | PhysicsCategories.invincibleCategory // POWER UP COLLECTED
        {
            invincible()
            contact.bodyB.node?.removeFromParent()
        }
    }
}
