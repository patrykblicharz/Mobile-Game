//
//  Background class.swift
//  Desert Run
//
//  Created by BLICHARZ, PATRYK on 18/11/2019.
//  Copyright © 2019 BLICHARZ, PATRYK. All rights reserved.
//

import SpriteKit

class Background: NSObject{
    let sand = SKSpriteNode(imageNamed: "sand")
    let screen = UIScreen.main.bounds
    
    func createBackground() {
              
              sand.position = CGPoint(x: frame.midX, y: frame.midY)
              sand.size = CGSize(width: screen.width * 1.6, height: screen.height * 2)
              self.addChild(sand)
    }
}

