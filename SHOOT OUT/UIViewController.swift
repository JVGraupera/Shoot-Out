//
//  UIViewController.swift
//  SHOOT OUT
//
//  Created by james graupera on 7/7/19.
//  Copyright © 2019 James' Games. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController {
    var shareNumber = 0
    public lazy var skView: SKView = {
        let view = SKView()
        //        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMultipleTouchEnabled = true
        return view
    }()
    
    lazy var backGroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "The_Gunfight", withExtension: "mp3") else { return nil }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
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
        backGroundMusic?.play()
        skView.frame = CGRect(x: 0.0, y: 0.0, width: ScreenSize.width, height: ScreenSize.height)
        if(UserDefaults().integer(forKey: "Share") == 0){
            let scene = StartupScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
        else{
            let scene = Reset(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
        skView.ignoresSiblingOrder = false
    }
    
    //func playStopBackgroundMusic(){
        
    //}
}
