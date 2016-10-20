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
    var level: Level!
    
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    
    //layers keep the Sprite Kit node hierarchy organized
    let gameLayer = SKNode() //base layer
    let cookiesLayer = SKNode() //cookie sprites go here
    
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
        
        //the below adds empty SKNodes to the screen to act as layers – like transparent planes other nodes can be added to
        addChild(gameLayer)
        
        //center is 0.5, 0.5 – so this makes cookie[0,0] on the bottom left of the screen, where the grid should start, by moving the grid down and to the left by half the height and width
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        cookiesLayer.position = layerPosition
        gameLayer.addChild(cookiesLayer)
    }
    
    func addSprites(for cookies: Set<Cookie>)
    {
        for cookie in cookies
        {
            let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: cookie.column, row: cookie.row)
            cookiesLayer.addChild(sprite)
            cookie.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint
    {
        return CGPoint(
            x: CGFloat(column) * TileWidth + TileWidth / 2,
            y: CGFloat(row) * TileHeight + TileHeight / 2)
    }
}
