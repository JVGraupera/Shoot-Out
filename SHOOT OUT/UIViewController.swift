//
//  UIViewController.swift
//  SHOOT OUT
//
//  Created by james graupera on 7/7/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    public lazy var skView: SKView = {
        let view = SKView()
        //        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMultipleTouchEnabled = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupViews() {
        view.addSubview(skView)
        
        skView.frame = CGRect(x: 0.0, y: 0.0, width: ScreenSize.width, height: ScreenSize.height)
        
        let scene = StartupScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
//           skView.showsFPS = true
//           skView.showsNodeCount = true
            //skView.showsPhysics = true
    }
    
}
