//
//  ObjectHelper.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 04/04/23.
//

import SpriteKit

class ObjectHelper {
    static func handleChild(sprite: SKSpriteNode, with name: String) {
        switch name {
            case GameConstants.StringConstants.finishLineName, GameConstants.StringConstants.enemyName:
                PhysicsHelper.addPhysicsBody(to: sprite, with: name)
            default:
                break
        }
    }
}
