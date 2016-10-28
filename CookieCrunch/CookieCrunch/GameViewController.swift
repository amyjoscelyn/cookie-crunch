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
    
    var movesLeft = 0
    var score = 0
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverPanel: UIImageView!
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBAction func shuffleButtonPressed(_: AnyObject)
    {
        shuffle()
        decrementMoves()
    }
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
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
        
        level = Level(filename: "Level_0")
        scene.level = level
        scene.addTiles()
        
        scene.swipeHandler = handleSwipe
        
        // Present the scene
        skView.presentScene(scene)
        
        //FOR TESTING PURPOSES=========
//        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        //=============================
        
        gameOverPanel.isHidden = true
        shuffleButton.isHidden = true
        
        beginGame()
    }
    
    func beginGame()
    {
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        
        level.resetComboMultiplier()
        
        scene.animateBeginGame {
            self.shuffleButton.isHidden = false
        }
        shuffle()
    }
    
    func shuffle()
    {
        scene.removeAllCookieSprites()
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
    }
    
    func handleSwipe(swap: Swap)
    {
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap)
        {
            level.performSwap(swap: swap)
            scene.animate(swap, completion: handleMatches)
        }
        else
        {
            scene.animateInvalidSwap(swap)
            {
                self.view.isUserInteractionEnabled = true
            }
            
            /*
             Note: The above uses so-called trailing closure syntax, where the closure is written behind the function call. An alternative way to write it is as follows:
             scene.animate(swap, completion: {
             self.view.isUserInteractionEnabled = true
             })
             */
        }
    }
    
    func handleMatches()
    {
        let chains = level.removeMatches()
        if chains.count == 0
        {
            beginNextTurn()
            return
        }
        
        scene.animateMatchedCookies(for: chains)
        {
            for chain in chains
            {
                self.score += chain.score
            }
            self.updateLabels()
            
            let columns = self.level.fillHoles()
            self.scene.animateFallingCookies(columns: columns)
            {
                let columns = self.level.topUpCookies()
                self.scene.animateNewCookies(columns)
                {
                    self.handleMatches() //this is recursion, if you don't return somewhere there will be an infinite loop
                }
            }
        }
    }
    
    func beginNextTurn()
    {
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        view.isUserInteractionEnabled = true
        
        decrementMoves()
    }
    
    func updateLabels()
    {
        targetLabel.text = String.init(format: "%ld", level.targetScore)
        movesLabel.text = String.init(format: "%ld", movesLeft)
        scoreLabel.text = String.init(format: "%ld", score)
    }
    
    func decrementMoves()
    {
        movesLeft -= 1
        updateLabels()
        
        if score >= level.targetScore
        {
            gameOverPanel.image = UIImage(named: "LevelComplete")
            showGameOver()
        }
        else if movesLeft == 0
        {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
    
    func showGameOver()
    {
        gameOverPanel.isHidden = false
        shuffleButton.isHidden = true
        scene.isUserInteractionEnabled = false
        
        scene.animateGameOver {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver()
    {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.isHidden = true
        scene.isUserInteractionEnabled = true
        
        beginGame()
    }
}
