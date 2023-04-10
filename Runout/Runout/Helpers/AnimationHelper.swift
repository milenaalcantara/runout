//
//  AnimationHelper.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 03/04/23.
//

import Foundation
import SpriteKit

class AnimationHelper {
    static func loadTextures(from atlas: SKTextureAtlas, with name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
}
