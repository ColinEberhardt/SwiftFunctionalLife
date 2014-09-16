//
//  ViewController.swift
//  SwiftFunctionalLife
//
//  Created by Colin Eberhardt on 30/08/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
  
  let world = World()
  let worldView: WorldView
  var timer: NSTimer!
  
  required init(coder aDecoder: NSCoder) {
    
    worldView = WorldView(world: world)
    
    super.init(coder: aDecoder)
    
    // a random initial state
    func randLocation () -> Int {
      return Int(arc4random()) % world.dimensions
    }
    for _ in 0...100 {
      let x = randLocation(), y = randLocation()
      world[x, y]!.state = .Alive
    }
  }
  
  func handleTap(recognizer: UITapGestureRecognizer) {
    timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "tick", userInfo: nil, repeats: true)
    //tick()
  }
  
  func tick() {
    world.iteratePreComputed()
    worldView.setNeedsDisplay()
  }
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let margin: CGFloat = 20.0
    let size = view.frame.width - margin * 2.0
    var frame = CGRectMake(margin, (view.frame.height - size) / 2.0, size, size)
    worldView.frame = frame
    worldView.layer.borderColor = UIColor.darkGrayColor().CGColor
    worldView.layer.borderWidth = 2.0
    view.addSubview(worldView)
    
    let singleFingerTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
    view.addGestureRecognizer(singleFingerTap)
  }
}




