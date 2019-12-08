//
//  Player class.swift
//  Desert Run
//
//  Created by BLICHARZ, PATRYK on 13/11/2019.
//  Copyright © 2019 BLICHARZ, PATRYK. All rights reserved.
//

import SpriteKit

class PlayerClass: NSObject {
     let player = SKSpriteNode(imageNamed: "player")
    
    func createPlayer(scene: SKScene) {
        player.name = "player"
        player.position.x = scene.frame.minX + 375
        player.position.y = scene.frame.minY + 200
        player.zPosition = 1
        scene.addChild(player)
    }
}
