//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import Foundation
import PlaygroundSupport
import SpriteKit
import SceneKit

public class LiveViewController_1_1: LiveViewController, SKSceneDelegate {
    
    weak var delegate: SKSceneDelegate?
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let eggMovePointsPerSec: CGFloat = 90.0
    var velocity = CGPoint.zero
    var lastTouchLocation: CGPoint?
    let egg = SKSpriteNode(imageNamed: "caja")
    let penguinFather = SKSpriteNode(imageNamed: "caja")
    let penguinMother = SKSpriteNode(imageNamed: "caja")
    var messageFromContent = "anyMessage"
    
    var isadded = false
    let eggWithMama = SKSpriteNode(imageNamed: "caja")
    let shape = SKSpriteNode()
    
    let sceneView = SKScene()
    let skView = SKView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.size = CGSize(width: view.bounds.width, height: view.bounds.height)
        skView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(skView)
        skView.presentScene(sceneView)
        sceneView.backgroundColor = .black
        
        
        setBackground(scene: sceneView)
        setForeground(scene: sceneView)
        
        setEgg(scene: sceneView)
        setPenguinFather(scene: sceneView)
        setPenguinMother()

        sceneView.delegate = self
        
        setRectFrame()
        view.isUserInteractionEnabled = false
    }
    
    func setBackground(scene: SKScene) {
        let background = SKSpriteNode(imageNamed: "cover")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        background.size = CGSize(width: scene.size.width, height: scene.size.height)
        background.zPosition = -3
        scene.addChild(background)
    }
    
    func setForeground(scene: SKScene) {
        let foreground = SKSpriteNode(imageNamed: "app")
        foreground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        foreground.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        foreground.size = CGSize(width: scene.size.width, height: scene.size.height)
        foreground.zPosition = -1
        scene.addChild(foreground)
    }
    
    func setEgg(scene: SKScene) {
        egg.position = CGPoint(x: penguinFather.frame.maxX, y: 180)
        egg.size = CGSize(width: (egg.size.width) / 2, height: (egg.size.height) / 2)
        egg.zPosition = 2
        egg.name = "egg"
        scene.addChild(egg)
    }
    
    func setRectFrame() {
        shape.color = .clear
        shape.size = CGSize(width: (egg.size.width) * 1.5, height: (egg.size.height) * 1.5)
        shape.position = CGPoint(x: (sceneView.frame.maxX / 2) - 20, y: egg.frame.maxY - 10)
        sceneView.addChild(shape)
    }
    
    func setPenguinFather(scene: SKScene) {
        penguinFather.position = CGPoint(x: 120, y: egg.frame.maxY + 45)
        penguinFather.size = CGSize(width: (egg.size.width) * 3, height: (egg.size.height) * 3)
        penguinFather.zPosition = 1
        scene.addChild(penguinFather)
    }
    
    func setPenguinMother() {
        penguinMother.position = CGPoint(x: (sceneView.frame.maxX / 2) + 100, y: egg.frame.maxY + 25)
        penguinMother.size = CGSize(width: (egg.size.width) * 2.7, height: (egg.size.height) * 2.7)
        penguinMother.zPosition = 1
        sceneView.addChild(penguinMother)
    }
    
    
    public func update(_ currentTime: TimeInterval, for scene: SKScene) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0 }
        lastUpdateTime = currentTime
        
        if let lastTouchLocation = lastTouchLocation {
            let difference = lastTouchLocation.distance(to: egg.position)
            if difference <= eggMovePointsPerSec * CGFloat(dt) {
                egg.position = lastTouchLocation
                velocity = CGPoint.zero
            } else {
                move(sprite: egg, velocity: velocity)
            }
        }
        boundsForEggMovement()
        
        if egg.frame.intersects(self.shape.frame) {
            egg.removeFromParent()
            setEggWithMama()
        }
    }
    
    func setEggWithMama() {
        if isadded == false{
            sceneView.addChild(eggWithMama)
            eggWithMama.position = CGPoint(x: penguinMother.frame.minX + 80, y: 190)
            eggWithMama.size = CGSize(width: (eggWithMama.size.width) / 2, height: (eggWithMama.size.height) / 2)
            eggWithMama.zPosition = 3
            isadded = true
        }
    }
    
    func callMama(){
        let callMamaAtlas = SKTextureAtlas(named: "CallMamaImages")
    
        var actions: [SKTexture] = []
        actions.append(callMamaAtlas.textureNamed("pfCallMama1"))
        actions.append(callMamaAtlas.textureNamed("pfCallMama2"))
        actions.append(callMamaAtlas.textureNamed("pfCallMama3"))
        
        var actions2: [SKTexture] = []
        actions2.append(callMamaAtlas.textureNamed("pfCallMama4"))
        
        let callPt1 = SKAction.animate(with: actions, timePerFrame: 0.3, resize: false, restore: true)
        let callPt2 = SKAction.animate(with: actions2, timePerFrame: 0.6, resize: false, restore: true)
        let call = SKAction.sequence([callPt1, callPt2])
        let penguinSound = SKAction.playSoundFileNamed("callMamaSound", waitForCompletion: false)
        penguinFather.run(penguinSound)
        penguinFather.run(call)
    }
    
    func makeMamaWalk() {
        let mamaSteps = SKTextureAtlas(named: "MamaWalk")
        
        var leftStep: [SKTexture] = []
        leftStep.append(mamaSteps.textureNamed("pMStep1"))
        
        var rightStep: [SKTexture] = []
        rightStep.append(mamaSteps.textureNamed("pMStep2"))
        
        let stepOne = SKAction.animate(with: leftStep, timePerFrame: 0.2, resize: false, restore: true)
        let stepTwo = SKAction.animate(with: rightStep, timePerFrame: 0.2, resize: false, restore: true)
        let walk = SKAction.sequence([stepOne, stepTwo])
        let repeatWalk = SKAction.repeat(walk, count: 10)
        let newPosition = CGPoint(x: (sceneView.frame.maxX / 2) - 120, y: egg.frame.maxY + 45)
        let moveTo = SKAction.move(to: newPosition, duration: 4)
        let groupAction = SKAction.group([repeatWalk, moveTo])
        penguinMother.run(groupAction)
    }
    
    func rotateEgg() {
        let rotationAngle = GLKMathDegreesToRadians(-4)
        let rotate = SKAction.rotate(byAngle: CGFloat(rotationAngle), duration: 2)
        egg.run(rotate)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        
        if velocity.x >= 0 {
            rotateEgg()
        } else { return }
    }
    
    
    func moveEggToward(location: CGPoint) {
        let offset = CGPoint(x: location.x - egg.position.x, y: location.y - egg.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * eggMovePointsPerSec, y: direction.y * eggMovePointsPerSec)
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        moveEggToward(location: touchLocation)
        
    }
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: sceneView)
        sceneTouched(touchLocation: touchLocation)
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: sceneView)
        sceneTouched(touchLocation: touchLocation)
    }
    
    func boundsForEggMovement() {
        let bottomLeft = CGPoint(x: 0, y: 100)
        let topRight = CGPoint(x: sceneView.frame.maxX, y: 200)
        if egg.position.x <= bottomLeft.x {
            egg.position.x = bottomLeft.x
            velocity.x = 0
        }
        if egg.position.x >= topRight.x {
            egg.position.x = topRight.x
            velocity.x = 0
        }
        if egg.position.y <= bottomLeft.y {
            egg.position.y = bottomLeft.y
            velocity.y = 0
        }
        if egg.position.y >= topRight.y {
            egg.position.y = topRight.y
            velocity.y = 0
        }
    }
    
     override public func receive(_ message: PlaygroundValue) {
//        Uncomment the following to be able to receive messages from the Contents.swift playground page. You will need to define the type of your incoming object and then perform any actions with it.
//
        guard case .string(let messageData) = message else { return }
        
        switch messageData {
        case FunctionType.dad.rawValue:
            print("erro")
        case FunctionType.mom.rawValue:
            callMama()
            run(after: 2) {
                self.makeMamaWalk()
            }
            run(after: 4) {
                self.view.isUserInteractionEnabled = true
            }
        case FunctionType.other.rawValue:
            print("erro")
        default:
            print("erro")
        }
        
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
        
    }
}

extension FloatingPoint {
    var degreesToRadians: Self {
        return self * .pi / 180
    }
    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}

public enum FunctionType: String {
    case dad = "callDaddy"
    case mom = "callMama"
    case other = "doOtherStuff"
}
