//
//  GameViewController.swift
//  PlaneShooter
//
//  Created by FloodSurge on 6/9/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    var restartButton:UIButton!
    var pauseButton:UIButton!
    var continueButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = view.frame.size
            
            skView.presentScene(scene)
            
            // add button
            initButton()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameOver", name: "gameOverNotification", object: nil)
            
        }
    }
    
    func initButton(){
        let buttonImage = UIImage(named:"BurstAircraftPause")
        
        pauseButton = UIButton()
        pauseButton.frame = CGRectMake(10, 25, buttonImage.size.width, buttonImage.size.height)
        pauseButton.setBackgroundImage(buttonImage, forState: .Normal)
        pauseButton.addTarget(self, action: "pause", forControlEvents: .TouchUpInside)
        view.addSubview(pauseButton)
        
        restartButton = UIButton()
        restartButton.bounds = CGRectMake(0, 0, 200, 30)
        restartButton.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2 + 30)
        restartButton.hidden = true
        restartButton.setTitle("restart", forState: .Normal)
        restartButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        restartButton.layer.borderWidth = 2.0
        restartButton.layer.cornerRadius = 15.0
        restartButton.layer.borderColor = UIColor.grayColor().CGColor
        restartButton.addTarget(self, action: "restart:", forControlEvents: .TouchUpInside)
        view.addSubview(restartButton)
        
        continueButton = UIButton()
        continueButton.bounds = CGRectMake(0, 0, 200, 30)
        continueButton.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2 - 30)
        continueButton.hidden = true
        continueButton.setTitle("continue", forState: .Normal)
        continueButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        continueButton.layer.borderWidth = 2.0
        continueButton.layer.cornerRadius = 15.0
        continueButton.layer.borderColor = UIColor.grayColor().CGColor
        continueButton.addTarget(self, action: "continueGame:", forControlEvents: .TouchUpInside)
        view.addSubview(continueButton)


    }

    func gameOver(){
        let backgroundView = UIView(frame:view.bounds)
        restartButton.center = backgroundView.center
        restartButton.hidden = false
        backgroundView.addSubview(restartButton)
        backgroundView.center = view.center
        view.addSubview(backgroundView)
    }
    
    func pause(){
        (view as SKView).paused = true
        restartButton.hidden = false
        continueButton.hidden = false
        
    }
    
    func restart(button:UIButton){
        restartButton.hidden = true
        continueButton.hidden = true
        self.becomeFirstResponder()
        (view as SKView).paused = false
        NSNotificationCenter.defaultCenter().postNotificationName("restartNotification", object: nil)
        
    }
    
    func continueGame(button:UIButton){
        continueButton.hidden = true
        restartButton.hidden = true
        (view as SKView).paused = false
    }
   
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Portrait.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
  
    
    
}
