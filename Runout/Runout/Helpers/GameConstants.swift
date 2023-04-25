//
//  GameConstants.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 03/04/23.
//

import Foundation

struct GameConstants {
    // MARK: Categories
    
    struct PhysicsCategories {
        static let noCategory: UInt32 = 0
        static let allCategory: UInt32 = UInt32.max // todos ao mesmo tempo
        static let playerCategory: UInt32 = 0x1
        static let groundCategory: UInt32 = 0x1 << 1
        static let finishCategory: UInt32 = 0x1 << 2
        static let collectibleCategory: UInt32 = 0x1 << 3
        static let enemyCategory: UInt32 = 0x1 << 4
        static let frameCategory: UInt32 = 0x1 << 5
        static let ceilingCategory: UInt32 = 0x1 << 6
        static let obstacleCategory: UInt32 = 0x1 << 7
    }
    
    // MARK: ZPositions
    
    struct ZPositions {
        static let farBGZ: CGFloat = 0
        static let closeBGZ: CGFloat = 1
        static let worldZ: CGFloat = 2
        static let objectZ: CGFloat = 3
        static let playerZ: CGFloat = 4
        static let hudZ: CGFloat = 5
    }
    
    // MARK: Strings
    
    struct StringConstants {
        
        // MARK: Names
        
        static let groundTilesName = "Ground Tiles"
        static let worldBackgroundNames = ["CityBackground", "DesertBackground", "GrassBackground"]
        static let playerName = "Player"
        static let playerImageName = "Idle_0"
        static let groundNodeName = "GroundNode"
        static let finishLineName = "FinishLine"
        static let enemyName = "Enemy"
        static let obstacleName = "Obstacle"
        static let coinName = "Coin"
        static let coinImageName = "gold_0"
        
        // MARK: Atlas
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        static let idlePrefixKey = "Idle_"
        static let runPrefixKey = "Run_"
        static let jumpPrefixKey = "Jump_"
        static let diePrefixKey = "Die_"
        static let coinRotateAtlas = "Coin Rotate Atlas"
        static let coinPrefixKey = "gold_"
        
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescendAcrionKey = "BrakeDescend"
        static let coinDustEmitterKey = "CoinDustEmitter"
    }
}
