//
//  GameViewController.swift
//  SideScrollerGameKhandeshi
//
//  Created by Avnish Khandeshi on 5/9/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    //var gameTimer = 1000
    var timer = Timer()
    
    var play : GameScene!
    
    @IBOutlet weak var jumpButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Connecting the storyboard (with the button) to the GameScene (with the ball)
                play = sceneNode
                
                // Copy gameplay related content over to the scene
             //   sceneNode.entities = scene.entities
               // sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
        startTimer()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func jumpButtonAction(_ sender: UIButton) {
        
        play.jumpBall()
        
    }
    
    
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        play.gameTimer -= 1
        timerLabel.text = "Score: \(play.gameTimer)"
    }
    
}
