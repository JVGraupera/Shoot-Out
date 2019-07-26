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
        
//        let button = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
//        button.backgroundColor = .green
//        button.setTitle("Test Button", for: .normal)
//        button.addTarget(self, action: #selector(fire), for: .touchUpInside)
//        
//        self.view.addSubview(button)
    }
    @objc func fire(){
        Gameplay().shoot()
        print("James")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupViews() {
        view.addSubview(skView)
        
        skView.frame = CGRect(x: 0.0, y: 0.0, width: ScreenSize.width, height: ScreenSize.height)
        
        let scene = Gameplay(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
//           skView.showsFPS = true
//           skView.showsNodeCount = true
//            skView.showsPhysics = true
    }
    
}
