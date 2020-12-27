//
//  MenuScene.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 05/12/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import SpriteKit

class MenuScene: SKScene
{
    let titleLabel = SKLabelNode(text: "CHICKEN POX")
    let playLabel = SKLabelNode(text: "Tap to play!")
    var lastScoreLabel = SKLabelNode(text: "Last score: ")
    var highscoreLabel = SKLabelNode(text: "Highscore: ")
    var font: String = "AvenirNext-Heavy"
    
    override func didMove(to view: SKView)
    {
        backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
        
        addLogo()
        
        lastScoreLabel.text = "Last Score: " + "\(UserDefaults.standard.integer(forKey: "LastScore"))"
        highscoreLabel.text = "Highscore: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))"
        
        createLabel(label: titleLabel, size: 47.0, color: UIColor.red, pos: CGPoint(x: frame.midX, y: frame.maxY - titleLabel.frame.size.height * 4))
        createLabel(label: lastScoreLabel, size: 30.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.minY + lastScoreLabel.frame.size.height * 4))
        createLabel(label: highscoreLabel, size: 30.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.minY + highscoreLabel.frame.size.height * 2))
    }
    
    func addLogo()
    {
        let logo = SKSpriteNode(imageNamed: "zombie")
        logo.size = CGSize(width: frame.width/2, height: frame.width/2)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + 80)        
        addChild(logo)
    }
    
    func createLabel(label: SKLabelNode, size: CGFloat, color: UIColor, pos: CGPoint)
    {
        label.fontName = font
        label.fontSize = size
        label.fontColor = color
        label.position = pos
        addChild(label)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        lastScoreLabel.text = "Last Score: " + "\(UserDefaults.standard.integer(forKey: "LastScore"))"
        highscoreLabel.text = "Highscore: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))"
    }
}
