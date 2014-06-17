//
//  GameScene.swift
//  PlaneShooter
//
//  Created by FloodSurge on 6/9/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var heroPlane:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var pauseButton:SKSpriteNode!
    
    var smallPlaneHitAction:SKAction!
    var smallPlaneBlowUpAction:SKAction!
    var mediumPlaneHitAction:SKAction!
    var mediumPlaneBlowUpAction:SKAction!
    var largePlaneHitAction:SKAction!
    var largePlaneBlowUpAction:SKAction!
    var heroPlaneBlowUpAction:SKAction!
    
    enum RoleCategory:UInt32{
        case Bullet = 1
        case HeroPlane = 2
        case EnemyPlane = 4
    }
    
    override func didMoveToView(view: SKView) {
        initBackground()
        initActions()
        initHeroPlane()
        initEnemyPlane()
        initScoreLabel()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restart", name: "restartNotification", object: nil)
    }
    
    func restart(){
        removeAllChildren()
        removeAllActions()

        initBackground()
        initScoreLabel()
        initHeroPlane()
        initEnemyPlane()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        let anyTouch : AnyObject! = touches.anyObject()
        let location = anyTouch.locationInNode(self)
        
        
        heroPlane.runAction(SKAction.moveTo(location, duration: 0.1))
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
    {
        let anyTouch : AnyObject! = touches.anyObject()
        let location = anyTouch.locationInNode(self)
        heroPlane.runAction(SKAction.moveTo(location, duration: 0))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func initBackground()
    {
        // init texture
        let backgroundTexture = SKTexture(imageNamed:"background")
        backgroundTexture.filteringMode = .Nearest
        
        // set action
        
        let moveBackgroundSprite = SKAction.moveByX(0, y:-backgroundTexture.size().height, duration: 5)
        let resetBackgroundSprite = SKAction.moveByX(0, y:backgroundTexture.size().height, duration: 0)
        let moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackgroundSprite,resetBackgroundSprite]))
        
        // init background sprite
        
        for index in 0..2 {
            let backgroundSprite = SKSpriteNode(texture:backgroundTexture)
            
            backgroundSprite.position = CGPointMake(size.width/2,size.height / 2 + CGFloat(index) * backgroundSprite.size.height)
            backgroundSprite.zPosition = 0
            backgroundSprite.runAction(moveBackgroundForever)
            addChild(backgroundSprite)
        }
        
        // play background music
        runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("game_music.mp3", waitForCompletion: true)))
        
        // set physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
  
    }
    
    func initActions()
    {
        // small hit action
        // nil
        
        
        
        // small blow up action
        var smallPlaneBlowUpTexture = SKTexture[]()
        for i in 1...4 {
            smallPlaneBlowUpTexture += SKTexture(imageNamed:"enemy1_blowup_\(i)")
        }
        smallPlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(smallPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        // medium hit action
        var mediumPlaneHitTexture = SKTexture[]()
        mediumPlaneHitTexture += SKTexture(imageNamed:"enemy3_hit_1")
        mediumPlaneHitTexture += SKTexture(imageNamed:"enemy3_fly_1")
        mediumPlaneHitAction = SKAction.animateWithTextures(mediumPlaneHitTexture, timePerFrame: 0.1)
        
        // medium blow up action
        var mediumPlaneBlowUpTexture = SKTexture[]()
        for i in 1...4 {
            mediumPlaneBlowUpTexture += SKTexture(imageNamed:"enemy3_blowup_\(i)")
        }
        mediumPlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(mediumPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        // large hit action
        var largePlaneHitTexture = SKTexture[]()
        largePlaneHitTexture += SKTexture(imageNamed:"enemy2_hit_1")
        largePlaneHitTexture += SKTexture(imageNamed:"enemy2_fly_2")
        largePlaneHitAction = SKAction.animateWithTextures(largePlaneHitTexture, timePerFrame: 0.1)
        
        // large blow up action
        var largePlaneBlowUpTexture = SKTexture[]()
        for i in 1...7 {
            largePlaneBlowUpTexture += SKTexture(imageNamed:"enemy2_blowup_\(i)")
        }
        largePlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(largePlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        // hero plane blow up action
        var heroPlaneBlowUpTexture = SKTexture[]()
        for i in 1...4 {
            heroPlaneBlowUpTexture += SKTexture(imageNamed:"hero_blowup_\(i)")
        }
        heroPlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(heroPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        
    }
    
    func initScoreLabel()
    {
        scoreLabel = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        
        scoreLabel.text = "0000"
        scoreLabel.zPosition = 2
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPointMake(50, size.height - 52)
        addChild(scoreLabel)
    }
    
    func changeScore(type:EnemyPlaneType)
    {
        var score:Int
        switch type {
        case .Large:
            score = 30000
        case .Medium:
            score = 6000
        case .Small:
            score = 1000
        }
        
        scoreLabel.runAction(SKAction.runBlock({() in
            self.scoreLabel.text = "\(self.scoreLabel.text.toInt()! + score)"}))
        
    }
    
    func initHeroPlane()
    {
        let heroPlaneTexture1 = SKTexture(imageNamed:"hero_fly_1")
        let heroPlaneTexture2 = SKTexture(imageNamed:"hero_fly_2")
        
        heroPlane = SKSpriteNode(texture:heroPlaneTexture1)
        heroPlane.setScale(0.5)
        
        heroPlane.position = CGPointMake(size.width / 2, size.height * 0.3)
        heroPlane.zPosition = 1
        let heroPlaneAction = SKAction.animateWithTextures([heroPlaneTexture1,heroPlaneTexture2], timePerFrame: 0.1)
        heroPlane.runAction(SKAction.repeatActionForever(heroPlaneAction))
        
        heroPlane.physicsBody = SKPhysicsBody(texture:heroPlaneTexture1,size:heroPlane.size)
        heroPlane.physicsBody.allowsRotation = false
        heroPlane.physicsBody.categoryBitMask = RoleCategory.HeroPlane.toRaw()
        heroPlane.physicsBody.collisionBitMask = 0
        heroPlane.physicsBody.contactTestBitMask = RoleCategory.EnemyPlane.toRaw()
        
        addChild(heroPlane)
        
        // fire bullets
        let spawn = SKAction.runBlock{() in
             self.createBullet()}
        let wait = SKAction.waitForDuration(0.2)
        heroPlane.runAction(SKAction.repeatActionForever(SKAction.sequence([spawn,wait])))
        
        
    }
    
    func createBullet()
    {
        let bulletTexture = SKTexture(imageNamed:"bullet1")
        let bullet = SKSpriteNode(texture:bulletTexture)
        bullet.setScale(0.5)
        bullet.position = CGPointMake(heroPlane.position.x, heroPlane.position.y + heroPlane.size.height/2 + bullet.size.height/2)
        bullet.zPosition = 1
        let bulletMove = SKAction.moveByX(0, y: size.height, duration: 0.5)
        let bulletRemove = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([bulletMove,bulletRemove]))
        
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        //bullet.physicsBody = SKPhysicsBody(texture:bulletTexture,size:bullet.size)
        bullet.physicsBody.allowsRotation = false
        bullet.physicsBody.categoryBitMask = RoleCategory.Bullet.toRaw()
        bullet.physicsBody.collisionBitMask = RoleCategory.EnemyPlane.toRaw()
        bullet.physicsBody.contactTestBitMask = RoleCategory.EnemyPlane.toRaw()
        
        addChild(bullet)
        
        // play bullet music
        
        runAction(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
        
    }
    
    func initEnemyPlane()
    {
        let spawn = SKAction.runBlock{() in
            self.createEnemyPlane()}
        let wait = SKAction.waitForDuration(0.4)
        runAction(SKAction.repeatActionForever(SKAction.sequence([spawn,wait])))
    }
    
    func createEnemyPlane(){
        let choose = arc4random() % 100
        var type:EnemyPlaneType
        var speed:Float
        var enemyPlane:EnemyPlane
        switch choose{
        case 0..75:
            type = .Small
            speed = Float(arc4random() % 3) + 2
            enemyPlane = EnemyPlane.createSmallPlane()
        case 75..97:
            type = .Medium
            speed = Float(arc4random() % 3) + 4
            enemyPlane = EnemyPlane.createMediumPlane()
        case _:
            type = .Large
            speed = Float(arc4random() % 3) + 6
            enemyPlane = EnemyPlane.createLargePlane()
            runAction(SKAction.playSoundFileNamed("enemy2_out.mp3", waitForCompletion: false))
        }
        
        enemyPlane.zPosition = 1
        enemyPlane.physicsBody.dynamic = false
        enemyPlane.physicsBody.allowsRotation = false
        enemyPlane.physicsBody.categoryBitMask = RoleCategory.EnemyPlane.toRaw()
        enemyPlane.physicsBody.collisionBitMask = RoleCategory.Bullet.toRaw() | RoleCategory.HeroPlane.toRaw()
        enemyPlane.physicsBody.contactTestBitMask = RoleCategory.Bullet.toRaw() | RoleCategory.HeroPlane.toRaw()
        
        let x = (arc4random() % 220) + 35
        enemyPlane.position = CGPointMake(CGFloat(x), size.height + enemyPlane.size.height/2)
        
        let moveAction = SKAction.moveToY(0, duration: NSTimeInterval(speed))
        let remove = SKAction.removeFromParent()
        enemyPlane.runAction(SKAction.sequence([moveAction,remove]))
        
        addChild(enemyPlane)
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact!)
    {
        
            let enemyPlane = contact.bodyA.categoryBitMask & RoleCategory.EnemyPlane.toRaw() == RoleCategory.EnemyPlane.toRaw() ? contact.bodyA.node as EnemyPlane : contact.bodyB.node as EnemyPlane
            
            let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            if collision == RoleCategory.EnemyPlane.toRaw() | RoleCategory.Bullet.toRaw(){
                
                // hit bullet
                let bullet = contact.bodyA.categoryBitMask & RoleCategory.Bullet.toRaw() == RoleCategory.Bullet.toRaw() ? contact.bodyA.node as SKSpriteNode : contact.bodyB.node as SKSpriteNode
                
                bullet.runAction(SKAction.removeFromParent())
                
                enemyPlaneCollision(enemyPlane)
                
                
                
            } else if collision == RoleCategory.EnemyPlane.toRaw() | RoleCategory.HeroPlane.toRaw(){
                println("hit plane")
                // hit hero plane
                let heroPlane = contact.bodyA.categoryBitMask & RoleCategory.HeroPlane.toRaw() == RoleCategory.HeroPlane.toRaw() ? contact.bodyA.node as SKSpriteNode : contact.bodyB.node as SKSpriteNode
                heroPlane.runAction(heroPlaneBlowUpAction,completion:{() in
                    self.runAction(SKAction.sequence([
                        SKAction.playSoundFileNamed("game_over.mp3", waitForCompletion: true),
                        SKAction.runBlock({() in
                            let label = SKLabelNode(fontNamed:"MarkerFelt-Thin")
                            label.text = "GameOver"
                            label.zPosition = 2
                            label.fontColor = SKColor.blackColor()
                            label.position = CGPointMake(self.size.width/2, self.size.height/2 + 20)
                            self.addChild(label)
                            })
                        ])
                    ,completion:{() in
                        self.resignFirstResponder()
                         NSNotificationCenter.defaultCenter().postNotificationName("gameOverNotification", object: nil)
                       }
                    )}
                )
            
            }
    
    }
    
    func enemyPlaneCollision(enemyPlane:EnemyPlane)
    {
        enemyPlane.hp--
        if enemyPlane.hp < 0 {
            enemyPlane.hp = 0
        }
        if enemyPlane.hp > 0 {
            switch enemyPlane.type{
            case .Small:
                enemyPlane.runAction(smallPlaneHitAction)
            case .Large:
                enemyPlane.runAction(largePlaneHitAction)
            case .Medium:
                enemyPlane.runAction(mediumPlaneHitAction)
            }

        } else {
            switch enemyPlane.type{
            case .Small:
                changeScore(.Small)
                enemyPlane.runAction(smallPlaneBlowUpAction)
                runAction(SKAction.playSoundFileNamed("enemy1_down.mp3", waitForCompletion: false))
            case .Large:
                changeScore(.Large)

                enemyPlane.runAction(largePlaneBlowUpAction)
                runAction(SKAction.playSoundFileNamed("enemy2_down.mp3", waitForCompletion: false))
            case .Medium:
                changeScore(.Medium)
                enemyPlane.runAction(mediumPlaneBlowUpAction)
                runAction(SKAction.playSoundFileNamed("enemy3_down.mp3", waitForCompletion: false))
            }
        }
    }

}
