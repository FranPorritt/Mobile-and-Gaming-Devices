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
    var player: SKSpriteNode!
    var chickenSize: CGFloat!
    
    var playerLives: Int = 3
    var livesLabel: SKLabelNode!
    
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
    
    func layoutScene()
    {
        chickenSize = frame.size.width/5
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        createPlayer()
        spawnEnemy()
    }
    
    func createPlayer()
    {
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: chickenSize, height: chickenSize)
        player.position = CGPoint(x: frame.midX, y: frame.minY + player.size.height)
        
        // Basic physics to recognise collisions with enemy -- no tilt control
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.categoryBitMask = PhysicsCategories.playerCategory
        player.physicsBody?.isDynamic = false // Doesn't move -- temp until tilt implemented
        
        addChild(player)
    }
    
    func spawnEnemy()
    {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.size = CGSize(width: chickenSize, height: chickenSize)
        
        let randomPos = CGFloat.random(in: frame.minX + enemy.size.width/2 ... frame.maxX - enemy.size.width/2)
        enemy.position = CGPoint(x: randomPos, y: frame.maxY)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width/2)
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.enemyCategory
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.playerCategory
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.none
        //enemy.physicsBody?.linearDamping = 10.0 // Slows the enemy down
        
        addChild(enemy)
    }
    
    func enemyCollision()
    {
        playerLives -= 1
        updateLives()
        print ("ENEMY HIT PLAYER" + String(playerLives))
    }
    
    func updateLives()
    {
        livesLabel.text = "\(playerLives)"
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
    }
}
