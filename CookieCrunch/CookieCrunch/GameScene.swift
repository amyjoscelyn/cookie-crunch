//
//  GameScene.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/20/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5) //because this is the anchor point, the background will always be centered on the screen for all iPhone screen sizes!
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = size
        addChild(background)
    }
}
