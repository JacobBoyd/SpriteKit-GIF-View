//
//  SpriteKitGIFView.swift
//  SpriteKitGIF
//
//  Created by Jacob Boyd on 4/25/19.
//  Copyright © 2019 Jacob Boyd. All rights reserved.
//

import UIKit
import SpriteKit
import ImageIO

public class SpriteKitGIFView: SKView {
    private var animationScene : SKScene!
    private var activityIndicator : UIActivityIndicatorView!
    private var node = SKSpriteNode()
    private var animationFrames: [SKTexture] = []
    
    @IBInspectable var timePerFrame: Double = 0.06
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        //put in placeholder image?
    }
    
    public func displayGIF(_ fileURL: URL?) {
        guard let unwrappedURL = fileURL as CFURL? else {
            print("SpriteKitGIFView - fileURL incorrect")
            return
        }
        
        if let imageSource = CGImageSourceCreateWithURL(unwrappedURL, nil) {
            addActivityIndicator()
            //ImageI/O used to get images("frames" of a gif)
            let count = CGImageSourceGetCount(imageSource)
            var images = [UIImage]()
            for i in 0..<count {
                //create a array of the collected frames
                images.append(UIImage(cgImage: CGImageSourceCreateImageAtIndex(imageSource, i, nil)!))
            }
            
            // Create the scene programmatically for spriteKit
            animationScene = SKScene(size: self.bounds.size)
            
            //configure spriteKit options
            animationScene!.scaleMode = .aspectFill
            self.ignoresSiblingOrder = true
            self.showsFPS = false
            self.presentScene(animationScene!)
            
            activityIndicator.startAnimating()
            
            //load in frames -- as background task
            self.setFrames(images) {
                DispatchQueue.main.async {
                    if self.activityIndicator.isAnimating {
                        self.activityIndicator.stopAnimating()
                    }
                    self.startAnimation(self.timePerFrame) //default set to 0.06, pass in TimeInterval/Double to change
                }
            }
        }
    }
    
    private func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    private func setFrames(_ images: [UIImage], completion: @escaping () -> Void) {
        let concurrentQueue = DispatchQueue(label: "com.queue.SpriteKitGIF", attributes: .concurrent)
        concurrentQueue.async {
            let animationAtlas = self.buildTextureAtlas(images)
            for j in 1...animationAtlas.textureNames.count-1 {
                self.animationFrames.append(animationAtlas.textureNamed("frame\(j)"))
            }
            let firstFrameTexture = self.animationFrames[0]
            
            //SKSpriteNode will be the actual object "playing" the animation (think of it as like a flipbook of images)
            self.node = SKSpriteNode(texture: firstFrameTexture)
            DispatchQueue.main.async {
                self.node.size = self.bounds.size
                self.node.position = CGPoint(x: self.animationScene.frame.midX, y: self.animationScene.frame.midY)
                self.animationScene.addChild(self.node)
                completion()
            }
        }
    }
    
    private func startAnimation(_ timePerFrame: TimeInterval) {
        node.run(SKAction.repeatForever(
            SKAction.animate(with: animationFrames,
                             timePerFrame: timePerFrame,
                resize: false,
                restore: true)),
                 withKey:"gifAnimation")
    }
    
    private func buildTextureAtlas(_ images: [UIImage]) -> SKTextureAtlas {
        var imageDict = [String: UIImage]()
        
        for (i, image) in images.enumerated() {
            imageDict["frame\(i)"] = image
        }
        return SKTextureAtlas(dictionary: imageDict)
    }
    
}
