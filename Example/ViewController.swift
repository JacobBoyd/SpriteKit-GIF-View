//
//  ViewController.swift
//  Example
//
//  Created by Jacob Boyd on 6/11/19.
//  Copyright © 2019 Jacob Boyd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var spriteGIFView: SpriteKitGIFView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        if let gifPath = Bundle.main.path(forResource: "deathstrokeDance", ofType: "gif") {
            let gifURL = URL(fileURLWithPath: gifPath)
            spriteGIFView.displayGIF(gifURL)
        }
    }


}

