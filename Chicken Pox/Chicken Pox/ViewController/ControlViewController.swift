//
//  ControlViewController.swift
//  Chicken Pox
//
//  Created by PORRITT, FRAN (Student) on 19/12/2020.
//  Copyright © 2020 PORRITT, FRAN (Student). All rights reserved.
//

import UIKit
import SpriteKit

class ControlViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        if let view = self.view as! SKView?
        {
            let scene = ControlScene(size: view.bounds.size)
        
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @IBAction func menu()
    {
        self.dismiss(animated: true, completion: nil) // deletes view controller to improve frames
    }
}
