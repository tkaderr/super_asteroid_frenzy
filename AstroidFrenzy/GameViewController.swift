//
//  GameViewController.swift
//
//  Created by Tahim Kader on 5/31/17.
//  Copyright © 2017 Tahim Kader. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var audio = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let audiofile = Bundle.main.path(forResource: "130_B_RunningMan_SP_01", ofType: "wav")
        let audioNSURL = NSURL(fileURLWithPath: audiofile!)
        
        do {
            audio = try AVAudioPlayer(contentsOf: audioNSURL as URL)
            audio.numberOfLoops = -1
            audio.volume = 2
            audio.play()
        }
        catch {
            return print("No Audio Found")
        }
        
        if let view = self.view as! SKView? {
            
            let scene = MainMenuScene(size:CGSize(width:1536, height:2048))
            
            scene.scaleMode = .aspectFill
            
            
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
