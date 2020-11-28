//
//  GameScene.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 14/11/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var topBoundary: SKShapeNode!
    var bottomBoundary: SKShapeNode!
    
    var gameTimer: Timer?
    var difficultyTimer: Timer?
    var enemySpawnRate: Double = 2
    
    var player: SKSpriteNode!
    var chickenSize: CGFloat!
    
    var projectileSize: CGFloat!
    var impulse: CGVector!
    
    var playerLives: Int = 3
    let livesLabel = SKLabelNode(text: "0")
    
    var score: Int = 0
    let scoreLabel = SKLabelNode(text: "0")
    var enemyPoints: Int = 10
    
    override func didMove(to view: SKView)
    {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics()
    {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
    }
    
    func createBoundaries()
    {
        let top: CGRect = CGRect(x: frame.minX, y: frame.maxY + 2, width: frame.width, height: 1)
        topBoundary = SKShapeNode(rect: top)
        topBoundary.physicsBody = SKPhysicsBody(edgeLoopFrom: top)
        topBoundary.physicsBody?.categoryBitMask = PhysicsCategories.boundaryCategory
        topBoundary.physicsBody?.isDynamic = false
        
        let bottom: CGRect = CGRect(x: frame.minX, y: frame.minY - 2, width: frame.width, height: 1)
        bottomBoundary = SKShapeNode(rect: bottom)
        bottomBoundary.physicsBody = SKPhysicsBody(edgeLoopFrom: bottom)
        bottomBoundary.physicsBody?.categoryBitMask = PhysicsCategories.boundaryCategory
        bottomBoundary.physicsBody?.isDynamic = false
    }
    
    @objc func increaseDifficulty() // Increases enemy spawn rate every x seconds
    {
        gameTimer?.invalidate() // Stops timer and restarts each time the spawn rate is increased
        gameTimer = Timer.scheduledTimer(timeInterval: enemySpawnRate, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true) //REMEMBER TO INVALIDATE WHEN DONE WITH IT
        
        enemySpawnRate -= 0.25
    }
    
    func layoutScene()
    {
        chickenSize = frame.size.width/5
        projectileSize = frame.size.width/7
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        createBoundaries()
        createLabels()
        createPlayer()
        
        increaseDifficulty()
        difficultyTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(increaseDifficulty), userInfo: nil, repeats: true)
    }
    
    func createLabels()
    {
        livesLabel.fontName = "AvenirNext-Bold"
        livesLabel.fontSize = 20.0
        livesLabel.fontColor = UIColor.white
        livesLabel.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        addChild(livesLabel)
        updateLivesLabel()
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 20.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        addChild(scoreLabel)
        updateScoreLabel(addScore: 0)
    }
    
    func createPlayer()
    {
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: chickenSize, height: chickenSize)
        player.position = CGPoint(x: frame.midX, y: frame.minY + chickenSize)
        
        // Basic physics to recognise collisions with enemy -- no tilt control
        player.physicsBody = SKPhysicsBody(circleOfRadius: chickenSize/2)
        player.physicsBody?.categoryBitMask = PhysicsCategories.playerCategory
        player.physicsBody?.isDynamic = false // Doesn't move -- temp until tilt implemented
        
        addChild(player)
    }
    
    @objc func spawnEnemy()
    {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.size = CGSize(width: chickenSize, height: chickenSize)
        
        let randomPos = CGFloat.random(in: frame.minX + enemy.size.width/2 ... frame.maxX - enemy.size.width/2)
        enemy.position = CGPoint(x: randomPos, y: frame.maxY + chickenSize) // spawns jsut off screen
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: chickenSize/2)
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.enemyCategory
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.playerCategory
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(enemy)
    }
    
    func spawnProjectile()
    {
        let projectile = SKSpriteNode(imageNamed: "cure")
        projectile.size = CGSize(width: projectileSize, height: projectileSize)
        projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectileSize/2)
        projectile.physicsBody?.categoryBitMask = PhysicsCategories.projectileCategory
        projectile.physicsBody?.contactTestBitMask = PhysicsCategories.enemyCategory
        projectile.physicsBody?.collisionBitMask = PhysicsCategories.none
        projectile.physicsBody?.affectedByGravity = false // goes up screen rather than down
        
        addChild(projectile)
        
        impulse = CGVector(dx: 0, dy: 60)
        projectile.physicsBody?.applyImpulse(impulse)
        
        /*var projTimer: Timer?
        projTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(despawnProjectile(proj:)), userInfo: projectile, repeats: false)*/
    }
    
    /*@objc func despawnProjectile(proj: SKSpriteNode)
    {
        proj.removeFromParent()
    }*/
    
    func enemyCollision()
    {
        playerLives -= 1
        updateLivesLabel()
        print ("ENEMY HIT PLAYER" + String(playerLives))
        
        if playerLives == 0
        {
            print ("GAME OVER")
        }
    }
    
    func enemyCured()
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
        fire()
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
        else if contactMask == PhysicsCategories.projectileCategory | PhysicsCategories.boundaryCategory
        {
            contact.bodyA.node?.removeFromParent()
        }
    }
}
