//
//  GroundNode.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 03/04/23.
//

import SpriteKit

class GroundNode: SKSpriteNode {
    var isBodyActivated: Bool = false {
        didSet {
            physicsBody = isBodyActivated ? activateBody : nil
        }
    }
    
    private var activateBody: SKPhysicsBody?
    
    init(with size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        let bodyInitialPoint = CGPoint(x: 0.0, y: size.height)
        let bodyEndPoint = CGPoint(x: size.width, y: size.height)
        
        activateBody = SKPhysicsBody(edgeFrom: bodyInitialPoint, to: bodyEndPoint)
        activateBody?.restitution = 0.0
        activateBody?.categoryBitMask = GameConstants.PhysicsCategories.groundCategory
        activateBody?.collisionBitMask = GameConstants.PhysicsCategories.playerCategory
        
        physicsBody = isBodyActivated ? activateBody : nil
        
        name = GameConstants.StringConstants.groundNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
