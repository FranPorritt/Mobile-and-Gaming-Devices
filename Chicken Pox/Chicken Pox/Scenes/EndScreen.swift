//
//  EndScreen.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 05/12/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import SpriteKit

class EndScreen: SKScene
{
    let gameOverLabel = SKLabelNode(text: "GAME OVER")
    let playLabel = SKLabelNode(text: "Tap to play again!")
    let lastScoreLabel = SKLabelNode(text: "Score: " + "\(UserDefaults.standard.integer(forKey: "LastScore"))")
    let highscoreLabel = SKLabelNode(text: "Highscore: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))")
    var font: String = "AvenirNext-Bold"
       
    override func didMove(to view: SKView)
    {
        backgroundColor = UIColor.red
        
        createLabel(label: gameOverLabel, size: 47.0, color: UIColor.black, pos: CGPoint(x: frame.midX, y: frame.maxY - gameOverLabel.frame.size.height * 4))
        createLabel(label: playLabel, size: 40.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.midY))
        createLabel(label: lastScoreLabel, size: 30.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.midY - lastScoreLabel.frame.size.height * 3))
        createLabel(label: highscoreLabel, size: 30.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.minY + highscoreLabel.frame.size.height * 2))
    }
       
    func createLabel(label: SKLabelNode, size: CGFloat, color: UIColor, pos: CGPoint)
    {
        label.fontName = font
        label.fontSize = size
        label.fontColor = color
        label.position = pos
        addChild(label)
    }
       
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let gameScene = GameScene(size:view!.bounds.size)
        view!.presentScene(gameScene)
    }
}
