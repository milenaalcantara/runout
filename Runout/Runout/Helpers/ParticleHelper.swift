//
//  ParticleHelper.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 12/04/23.
//

import Foundation
import SpriteKit

class ParticleHelper {
    static func addParticleEffect(name: String, particlepPositionRange: CGVector, position: CGPoint) -> SKEmitterNode? {
        if let emitter = SKEmitterNode(fileNamed: name) {
            emitter.particlePositionRange = particlepPositionRange
            emitter.position = position
            emitter.name = name
            return emitter
        }
        return nil
    }
    
    static func removeParticleEffect(name: String, from node: SKNode) {
        let emitters = node[name]
        
        for emitter in emitters {
            emitter.removeFromParent()
        }
    }
}
