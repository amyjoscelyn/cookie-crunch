//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Amy Joscelyn on 10/20/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    //mostly boilerplate code that creates the Sprite Kit scene and presents it in the SKView
    
    var scene: GameScene!
    var level: Level!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
//        level = Level()
        level = Level(filename: "Level_1")
        scene.level = level
        
        // Present the scene
        skView.presentScene(scene)
        
        //FOR TESTING PURPOSES=========
//        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        //=============================
        
        beginGame()
    }
    
    func beginGame()
    {
        shuffle()
    }
    
    func shuffle()
    {
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
    }
}
