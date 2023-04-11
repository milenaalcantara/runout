//
//  GameViewController.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 03/04/23.
//

import UIKit
import SpriteKit
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            startBackgroundMusic()
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
        
        func startBackgroundMusic() {
            let path = Bundle.main.path(forResource: "backgroundSound", ofType: "wav")
            let url = URL(fileURLWithPath: path!)
            backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.play()
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
