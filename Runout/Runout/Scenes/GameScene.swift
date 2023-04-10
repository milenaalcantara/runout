//
//  GameScene.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 03/04/23.
//

import SpriteKit
import GameplayKit

enum GameState {
    case ready, ongoing, paused, finished
}

class GameScene: SKScene {
    
    var worldLayer: Layer = Layer()
    var backgroundLayer: RepeatingLayer = RepeatingLayer()
    var player: Player = Player(
        imageNamed: GameConstants.StringConstants.playerImageName
    )
    
    var mapNode: SKNode = SKNode()
    var tileMap: SKTileMapNode = SKTileMapNode()
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var gameState = GameState.ready {
        willSet {
            switch newValue {
                case .ongoing:
                    player.state = .running
                    pauseEnemies(bool: false)
                case .finished:
                    player.state = .idle
                    pauseEnemies(bool: true)
                default:
                    break
            }
        }
    }
    
    var touch = false
    var brake = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        
        physicsBody = SKPhysicsBody(
            edgeFrom: CGPoint(x: frame.minX, y: frame.minY),
            to: CGPoint(x: frame.maxX, y: frame.minY)
        )
        physicsBody?.categoryBitMask = GameConstants.PhysicsCategories.frameCategory
        physicsBody?.contactTestBitMask = GameConstants.PhysicsCategories.playerCategory
        
        createLayers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
            case .ready:
                gameState = .ongoing
            case .ongoing:
                touch = true
                if !player.airbone {
                    jump()
                } else if !brake {
                    brakeDescend()
                }
            default:
                break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        
        lastTime = currentTime

        if gameState == .ongoing {
            worldLayer.update(dt)
            backgroundLayer.update(dt)
        }
    }
    
    override func didSimulatePhysics() {
        for node in tileMap[GameConstants.StringConstants.groundNodeName] {
            if let groundNode = node as? GroundNode {
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
                let playerY = player.position.y - player.size.height / 3
                groundNode.isBodyActivated = playerY > groundY
            }
        }
    }
}

private extension GameScene {
    func createLayers() {
        addChild(worldLayer)
        worldLayer.zPosition = GameConstants.ZPositions.worldZ
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        
        addChild(backgroundLayer)
        backgroundLayer.zPosition = GameConstants.ZPositions.farBGZ
        
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(
                imageNamed: GameConstants.StringConstants.worldBackgroundNames[0]
            )
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(
                x: 0.0 + CGFloat(i) * backgroundImage.size.width,
                y: 0.0
            )
            backgroundLayer.addChild(backgroundImage)
        }
        
        backgroundLayer.layerVelocity = CGPoint(
            x: -100.0, y: 0.0)
        
        load(level: "LevelOne")
    }
    
    func load(level: String) {
        if let levelNode = SKNode.unarchiveFromFile(level) {
            mapNode = levelNode
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    func loadTileMap() {
        if let groundTiles = mapNode.childNode(withName: GameConstants.StringConstants.groundTilesName) as? SKTileMapNode { // groundTiles recebe todos os tiles que estão dentro do tile map com nome de 'Ground Tiles'
            
            tileMap = groundTiles
            tileMap.scale(
                to: frame.size,
                width: false,
                multiplier: 1.0) // seta o tamanho do tile map com o tamanho da screen disponível
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground") // configuração da física dos grounds
            
            for child in groundTiles.children {
                if let sprite = child as? SKSpriteNode, sprite.name != nil {
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
        
        addPlayer()
    }
    
    func addPlayer() {
        player.scale(to: frame.size, width: false, multiplier: 0.1) // seta o tamanho do personagem
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!) // configuração da física do personagem
        
        player.position = CGPoint(
            x: frame.midX / 6.0,
            y: frame.midY
        ) // posição inicial do personagem
        player.zPosition = GameConstants.ZPositions.playerZ
        player.loadTextures() // carrega as texturas para animação do personagem
        player.state = .idle
        addChild(player)
        addPlayerAction()
    }
    
    func addPlayerAction() {
        let upAction = SKAction.moveBy(
            x: 0.0,
            y: frame.size.height / 4,
            duration: 0.4
        ) // cria a ação de pular
        upAction.timingMode = .easeIn // configura o modo
        player.createUserData(entry: upAction, forKey: GameConstants.StringConstants.jumpUpActionKey) // cria um identificador pra essa ação do personagem e seta a acrescenta a ação para o personagem
        let move = SKAction.moveBy(x: 0.0, y: player.size.height, duration: 0.4)
        let jump = SKAction.animate(
            with: player.jumpFrames,
            timePerFrame: 0.4 / Double(player.jumpFrames.count)
        )
        let group = SKAction.group([move, jump])
        
        player.createUserData(entry: group, forKey: GameConstants.StringConstants.brakeDescendAcrionKey)
        
    }
    
    func jump() {
        player.airbone = true
        player.turnGravity(on: false)
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction) {
            if self.touch {
                self.player.run(self.player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction) {
                    self.player.turnGravity(on: true)
                }
            }
        }
    }
    
    func brakeDescend() {
        brake = true
        player.physicsBody?.velocity.dy = 0.0
        
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.brakeDescendAcrionKey) as! SKAction)
    }
    
    func handleEnemyContact() {
        die(reason: 0)
    }
    
    func pauseEnemies(bool: Bool) {
        for enemy in tileMap[GameConstants.StringConstants.enemyName] {
            enemy.isPaused = bool
        }
    }
    
    func die(reason: Int) {
        gameState = .finished // fim do jogo
        player.turnGravity(on: false) // affect by gravity
        
        var deathAnimation: SKAction
        
        switch reason {
            case 0:
                deathAnimation = SKAction.animate(
                    with: player.dieFrames,
                    timePerFrame: 0.1,
                    resize: true,
                    restore: true
                )
            case 1:
                let up = SKAction.moveTo(y: frame.midY, duration: 0.25)
                let wait = SKAction.wait(forDuration: 0.1)
                let down = SKAction.moveTo(y: -player.size.height, duration: 0.2)
                deathAnimation = SKAction.sequence([up, wait, down])
            default:
                deathAnimation = SKAction.animate(
                    with: player.dieFrames,
                    timePerFrame: 0.1,
                    resize: true,
                    restore: true
                )
        }
        
        player.run(deathAnimation) {
            self.player.removeFromParent()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
            case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
                player.airbone = false
                brake = false
            case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.finishCategory:
                gameState = .finished
            case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.enemyCategory:
                handleEnemyContact()
            case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.frameCategory:
                physicsBody = nil
                die(reason: 1)
            default:
                break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
            case GameConstants.PhysicsCategories.playerCategory | GameConstants.PhysicsCategories.groundCategory:
                player.airbone = true
            default:
                break
        }
    }
}
