//
//  MenuViewController.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 19/12/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController
{
    override func viewDidLoad()
    {
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
        }
    }
    
    @IBAction func loadGame(_ sender: Any)
    {
        print("start")
        self.dismiss(animated: true, completion: nil) // deletes menu view controller to improve frames
    }
}
