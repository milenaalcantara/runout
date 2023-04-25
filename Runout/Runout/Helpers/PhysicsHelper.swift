//
//  PhysicsHelper.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 03/04/23.
//

import SpriteKit

class PhysicsHelper {
    
    // MARK: Contact and Collision
    
    static func addPhysicsBody(to sprite: SKSpriteNode, with name: String) {
        switch name {
            case GameConstants.StringConstants.playerName:
                sprite.physicsBody = SKPhysicsBody(
                    rectangleOf: CGSize(
                        width: sprite.size.width / 2,
                        height: sprite.size.height))
                sprite.physicsBody?.restitution = 0.0
                sprite.physicsBody?.allowsRotation = false // não deixa o player rotacionar quando colidir com algo
                sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.playerCategory
                sprite.physicsBody?.collisionBitMask = GameConstants.PhysicsCategories.groundCategory | GameConstants.PhysicsCategories.finishCategory | GameConstants.PhysicsCategories.obstacleCategory // percebe quando houver colisão com essas categorias (um ou outro)
                sprite.physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.allCategory // detecta o contato
            case GameConstants.StringConstants.finishLineName:
                sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
                sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.finishCategory
            case GameConstants.StringConstants.obstacleName:
                sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
                sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.obstacleCategory
            case GameConstants.StringConstants.enemyName:
                sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
                sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.enemyCategory
            case GameConstants.StringConstants.coinName:
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
                sprite.physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.collectibleCategory
            default:
                sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        }
        
        if name != GameConstants.StringConstants.playerName {
            sprite.physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
            sprite.physicsBody?.isDynamic = false
        }
    }
    
    // MARK: TileMaps per name
    static func addPhysicsBody(to tileMap: SKTileMapNode, and tileInfo: String) {
        let tileSize = tileMap.tileSize
        
        for row in 0..<tileMap.numberOfRows {
            var tiles = [Int]()
            
            for col in 0..<tileMap.numberOfColumns {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isUsedTile = tileDefinition?.userData?[tileInfo] as? Bool
                
                if isUsedTile ?? false {
                    tiles.append(1)
                } else {
                    tiles.append(0)
                }
            }
            
            if tiles.contains(1) {
                var plataform = [Int]()
                for (index, tile) in tiles.enumerated() {
                    if tile == 1 && index < (tileMap.numberOfColumns-1) {
                        plataform.append(index)
                    } else if !plataform.isEmpty {
                        let axisX = CGFloat(plataform[0]) * tileSize.width
                        let axisY = CGFloat(row) * tileSize.height
                        
                        let tileNode = GroundNode(with: CGSize(
                            width: tileSize.width * CGFloat(plataform.count),
                            height: tileSize.height))
                        tileNode.position = CGPoint(x: axisX, y: axisY)
                        tileNode.anchorPoint = CGPoint.zero
                        tileMap.addChild(tileNode)
                        
                        plataform.removeAll()
                    }
                }
            }
        }
                
    }
}
