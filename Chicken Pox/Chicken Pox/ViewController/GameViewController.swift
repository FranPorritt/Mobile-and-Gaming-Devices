//
//  GameViewController.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 14/11/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var gameScene: GameScene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView?
        {
            let scene = MenuScene(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            //view.addSubview(gameScene.livesText)
        }
    }
}
