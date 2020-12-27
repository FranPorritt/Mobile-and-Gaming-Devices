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
    let shakeLabel = SKLabelNode(text: "Shake device to use power move and kill all the zombies on screen")
    let movementLabel = SKLabelNode(text: "Hold buttons at bottom of screen to move left and right")
    let shootLabel = SKLabelNode(text: "Tap screen to fire - cooldown between shots")
    let hardLabel = SKLabelNode(text: "Hard Mode: Increased enemy spawning and longer cool downs between shots")
    var font: String = "AvenirNext-Heavy"
       
    override func didMove(to view: SKView)
    {
        backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
        
        createLabel(label: controlLabel, size: 47.0, color: UIColor.red, pos: CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.2))
        createLabel(label: movementLabel, size: 25.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.35))
        createLabel(label: shootLabel, size: 25.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.45))
        createLabel(label: shakeLabel, size: 25.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.6))
        createLabel(label: hardLabel, size: 25.0, color: UIColor.white, pos: CGPoint(x: frame.midX, y: frame.minY + frame.maxY - frame.height * 0.75))
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
