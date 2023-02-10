//
//  WhackSlot.swift
//  Project14
//
//  Created by nikita on 09.02.2023.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        if let comeIntoOrOut = SKEmitterNode(fileNamed: "ComeIntoOrOut") {
            comeIntoOrOut.position = CGPoint(x: charNode.position.x, y: charNode.position.y + 80)
            comeIntoOrOut.zPosition = 1
            addChild(comeIntoOrOut)
        }
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [unowned self] in
            self.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y:-80, duration:0.05))
        if let comeIntoOrOut = SKEmitterNode(fileNamed: "ComeIntoOrOut") {
            comeIntoOrOut.position = CGPoint(x: charNode.position.x, y: charNode.position.y)
            addChild(comeIntoOrOut)
        }
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y:-80, duration:0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
        if let hitParticles = SKEmitterNode(fileNamed: "HitParticles") {
            hitParticles.position = CGPoint(x: charNode.position.x, y: charNode.position.y)
            addChild(hitParticles)
        }
    }
    
}
