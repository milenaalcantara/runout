//
//  SKNode+Ext.swift
//  Runout
//
//  Created by Milena Lima de Alcântara on 03/04/23.
//

import SpriteKit

extension SKNode {
//    static func unarchiveFromFile(_ file: String) -> Self? {
//        guard let url = Bundle.main.url(forResource: file, withExtension: nil), let data = try? Data(contentsOf: url) else {
//            return nil
//        }
//
//        do {
//            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
//            unarchiver.requiresSecureCoding = false
//            unarchiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//
//            let scene = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey)
//            unarchiver.finishDecoding()
//
//            return scene as? Self
//        } catch {
//            return nil
//        }
//    }
    
    static func unarchiveFromFile(_ file: String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let url = URL(filePath: path) // fileURLWidthPath

            do {
                let sceneData = try Data(contentsOf: url, options: .mappedIfSafe)
                let archiver = try NSKeyedUnarchiver(forReadingFrom: sceneData) // forReadingWith
                archiver.requiresSecureCoding = false

                /// Para o primeiro argumento do setClass ser válido é necessário definir a função como class para que ela seja um NSObj
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")

                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey)
                archiver.finishDecoding()
                
                return scene as? SKNode
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    func scale(to screenSize: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (screenSize.width * multiplier) / self.frame.size.width : (screenSize.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
    
    func turnGravity(on value: Bool) {
        physicsBody?.affectedByGravity = value
    }
    
    func createUserData(entry: Any, forKey key: String) {
        if userData == nil {
            let userDataDictionary = NSMutableDictionary()
            userData = userDataDictionary
        }
        
        userData!.setValue(entry, forKey: key)
    }
}
