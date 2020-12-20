//
//  ControlScene.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 05/12/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import SpriteKit

class ControlScene: SKScene
{
    let controlLabel = SKLabelNode(text: "CONTROLS")
    let shakeLabel = SKLabelNode(text: "Shake device to use power move")
    let movementLabel = SKLabelNode(text: "Hold buttons at bottom of screen to move left and right")
    let shootLabel = SKLabelNode(text: "Tap screen to fire - 0.25 second cooldown between shots")
    let menuLabel = SKLabelNode(text: "Tap to go back")
    var font: String = "AvenirNext-Heavy"
       
    override func didMove(to view: SKView)
    {
        backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
        
        createLabel(label: controlLabel, size: 47.0, color: UIColor.red, pos: CGPoint(x: frame.midX, y: frame.maxY - controlLabel.frame.size.height * 4))
        createLabel(label: movementLabel, size: 30.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.midY + movementLabel.frame.height * 2))
        createLabel(label: shootLabel, size: 30.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.midY - shakeLabel.frame.height * 3))
        createLabel(label: shakeLabel, size: 30.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.midY - shakeLabel.frame.size.height * 7))
    }
       
    func createLabel(label: SKLabelNode, size: CGFloat, color: UIColor, pos: CGPoint)
    {
        label.fontName = font
        label.fontSize = size
        label.fontColor = color
        label.position = pos
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 400
        addChild(label)
    }
}
