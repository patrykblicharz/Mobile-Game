//
//  GameViewController.swift
//  Desert Run
//
//  Created by BLICHARZ, PATRYK on 13/11/2019.
//  Copyright © 2019 BLICHARZ, PATRYK. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    /*override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }*/ //old code for rendering the scene
   override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            //Because viewWillLayoutSubviews might be called multiple times, check if scene is already initialized
             if(skView.scene == nil){

                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .aspectFill
                scene.size = skView.bounds.size

                skView.presentScene(scene)
            }
        }
    }

   /* override var shouldAutorotate: Bool {
        return true
    }
*/
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
