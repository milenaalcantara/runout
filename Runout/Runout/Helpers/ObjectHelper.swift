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
            case GameConstants.StringConstants.finishLineName, GameConstants.StringConstants.enemyName, GameConstants.StringConstants.obstacleName:
                PhysicsHelper.addPhysicsBody(to: sprite, with: name)
            default:
                let component = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
                if let rows = Int(component[0]), let columns = Int(component[1]) {
                    calculateGridWith(rows: rows, columns: columns, parent: sprite)
                }
        }
    }
    
    static func calculateGridWith(rows: Int, columns: Int, parent: SKSpriteNode) {
        parent.color = .clear
        
        for column in 0..<columns {
            for row in 0..<rows {
                let position = CGPoint(x: column, y: row)
                addCoin(to: parent, at: position, columns: columns)
            }
        }
    }
    
    // MARK: Coins
    
    static func addCoin(to parent: SKSpriteNode, at position: CGPoint, columns: Int) {
        let coin = SKSpriteNode(imageNamed: GameConstants.StringConstants.coinImageName)
        coin.size = CGSize(
            width: parent.size.width / CGFloat(columns),
            height: parent.size.width / CGFloat(columns))
        coin.name = GameConstants.StringConstants.coinName
         
        coin.position = CGPoint(
            x: position.x * coin.size.width + coin.size.width / 2,
            y: position.y * coin.size.height + coin.size.height / 2)
        
        let coinFrames = AnimationHelper.loadTextures(
            from: SKTextureAtlas(named: GameConstants.StringConstants.coinRotateAtlas),
            with: GameConstants.StringConstants.coinPrefixKey)
        
        coin.run(SKAction.repeatForever(SKAction.animate(
            with: coinFrames,
            timePerFrame: 0.1
        )))

        PhysicsHelper.addPhysicsBody(to: coin, with: GameConstants.StringConstants.coinName)
        
        parent.addChild(coin)
        
    }
}
