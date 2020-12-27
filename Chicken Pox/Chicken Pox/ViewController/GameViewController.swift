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
    
    var currentScene: GameScene!
    var deadTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView?
        {
            let scene = GameScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(gameOver), name: NSNotification.Name(rawValue: "GameOver"), object: nil)
            currentScene = scene
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {
        if currentScene.powerUses > 0
        {
            currentScene.powerMove()
            print("POWER")
        }
    }
    
    @objc func gameOver(notification: NSNotification)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pause()
    {
        currentScene.view?.isPaused = !currentScene.view!.isPaused
        currentScene.controlTimers(state: currentScene.view!.isPaused)
    }
    
    @IBAction func switchClicked(_ sender: UISwitch)
    {
        if sender.isOn // Hard mode - Faster spawning, longer cool down
        {
            currentScene.difficultyRate = 0.2
            currentScene.coolDownRate = 0.4
        }
        else
        {
            currentScene.difficultyRate = 0.1
            currentScene.coolDownRate = 0.15
        }
    }
}
