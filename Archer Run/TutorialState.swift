//
//  TutorialState.swift
//  Archer Rush
//
//  Created by Carlos Diez on 7/21/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialState: GKState {
    
    unowned let scene: GameScene
    
    var separator: SKSpriteNode!
    var tapLabel: SKLabelNode!
    var dragLabel: SKLabelNode!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let tapSideWidth = (scene.size.width / 2) / 2
        let dragSideWidth = scene.size.width - tapSideWidth
        
        let gray = UIColor.grayColor()
        let alphaGray = gray.colorWithAlphaComponent(0.3)
        
        separator = SKSpriteNode(color: alphaGray, size: CGSize(width: 1.5, height: scene.size.height))
        separator.position.x = tapSideWidth
        separator.position.y = scene.size.height / 2
        separator.zPosition = 20
        scene.addChild(separator)
        
        tapLabel = SKLabelNode(fontNamed: "Arial")
        dragLabel = SKLabelNode(fontNamed: "Arial")
        
        tapLabel.text = "Tap to Jump"
        dragLabel.text = "Drag to shoot"
        
        tapLabel.position.x = tapSideWidth / 2
        tapLabel.position.y = scene.size.height / 2
        
        dragLabel.position.x = (dragSideWidth / 2) + tapSideWidth
        dragLabel.position.y = scene.size.height / 2
        
        let fadeAction = SKAction.fadeAlphaBy(0.3, duration: 0.5)
        let fadeAnimation = SKAction.repeatActionForever(fadeAction)
        
        tapLabel.runAction(fadeAnimation)
        dragLabel.runAction(fadeAnimation)
        
        scene.addChild(tapLabel)
        scene.addChild(dragLabel)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
       return true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
        if scene.didTutShoot && scene.didTutJump {
            separator.removeFromParent()
            tapLabel.removeFromParent()
            dragLabel.removeFromParent()
            
            scene.gameState.enterState(PlayingState)
        }
        
        let floorSpeed: CGFloat = 4
        
        let secondsFloat = CGFloat(seconds)
        
        let scrollSpeed = (floorSpeed * 60) * secondsFloat
        let treesFrontSpeed = (2 * 60) * secondsFloat
        let treesBackSpeed = 60 * secondsFloat
        let mountainsSpeed = 30 * secondsFloat
        let enemyScrollSpeed = ((floorSpeed + 2) * 60) * secondsFloat
        
        //Scroll rest of starting world
        scrollStartingWorldLayer(scene.startingScrollLayer, speed: scrollSpeed)
        scrollStartingWorldElement(scene.startTreesFront, speed: treesFrontSpeed)
        scrollStartingWorldElement(scene.startTreesBack, speed: treesBackSpeed)
        scrollStartingWorldElement(scene.startMountains, speed: mountainsSpeed)
        
        //Infinite Scroll
        scrollSprite(scene.levelHolder1, speed: scrollSpeed)
        scrollSprite(scene.levelHolder2, speed: scrollSpeed)
        scrollSprite(scene.mountains1, speed: mountainsSpeed)
        scrollSprite(scene.mountains2, speed: mountainsSpeed)
        scrollSprite(scene.treesBack1, speed: treesBackSpeed)
        scrollSprite(scene.treesBack2, speed: treesBackSpeed)
        scrollSprite(scene.treesFront1, speed: treesFrontSpeed)
        scrollSprite(scene.treesFront2, speed: treesFrontSpeed)
        
        scene.obstacleScrollLayer.position.x -= scrollSpeed
        scene.enemyScrollLayer.position.x -= enemyScrollSpeed
    }
    
    func scrollStartingWorldElement(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -scene.frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollStartingWorldLayer(sprite: SKNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if scene.startingScrollLayer.position.x <= -scene.frame.size.width {
            sprite.removeFromParent()
        }
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= -(sprite.size.width / 2) {
            sprite.position.x += sprite.size.width * 2
        }
        
        if sprite.name == "levelHolder1" || sprite.name == "levelHolder2" {
            if sprite.position.x <= sprite.size.width + sprite.size.width/2 {
                scene.currentLevelHolder = sprite.name!
            }
        }
    }
}