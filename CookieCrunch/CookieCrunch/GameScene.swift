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
    let tilesLayer = SKNode()
    
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
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
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        cookiesLayer.position = layerPosition
        gameLayer.addChild(cookiesLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
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
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int)
    {
        if point.x >= 0
            && point.x < CGFloat(NumColumns) * TileWidth
            && point.y >= 0
            && point.y < CGFloat(NumRows) * TileHeight
        {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        }
        else
        {
            return (false, 0, 0) // invalid location
        }
    }
    
    func addTiles()
    {
        for row in 0..<NumRows
        {
            for column in 0..<NumColumns
            {
                if level.tileAt(column: column, row: row) != nil
                {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize.init(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return }
        let location = touch.location(in: cookiesLayer)
        
        let (success, column, row) = convertPoint(point: location)
        if success
        {
            if let cookie = level.cookieAt(column: column, row: row)
            {
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard swipeFromColumn != nil else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: cookiesLayer)
        
        let (success, column, row) = convertPoint(point: location)
        if success
        {
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! //swipe left
            {
                horzDelta = -1
            }
            else if column > swipeFromColumn! //swipe right
            {
                horzDelta = 1
            }
            else if row < swipeFromRow! //swipe down
            {
                vertDelta = -1
            }
            else if row > swipeFromRow! //swipe up
            {
                vertDelta = 1
            }
            
            if horzDelta != 0 || vertDelta != 0
            {
                trySwap(horizontal: horzDelta, vertical: vertDelta)
                
                swipeFromColumn = nil
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touchesEnded(touches, with: event)
    }
    
    func trySwap(horizontal horzDelta: Int, vertical vertDelta: Int)
    {
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        
        guard toColumn >= 0 && toColumn < NumColumns else { return }
        guard toRow >= 0 && toRow < NumRows else { return }
        
        if let toCookie = level.cookieAt(column: toColumn, row: toRow),
           let fromCookie = level.cookieAt(column: swipeFromColumn!, row: swipeFromRow!)
        {
            print("*** swapping \(fromCookie) with \(toCookie)")
        }
    }
}
