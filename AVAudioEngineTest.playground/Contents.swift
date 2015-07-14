//: Playground - noun: a place where people can play

import UIKit
import AVFoundation
import XCPlayground

let engine = AVAudioEngine()
let player = AVAudioPlayerNode()

let delay = AVAudioUnitDelay()
let reverb = AVAudioUnitReverb()

let audioFileURL:NSURL = NSBundle.mainBundle().URLForResource("Hooded", withExtension: "mp3")!
var file:AVAudioFile?

do {
  file = try AVAudioFile(forReading: audioFileURL)
  
  guard let file = file else {
    fatalError("`file` must not be nil in \(__FUNCTION__).")
  }
  
  // Attach FX nodes to engine
  engine.attachNode(player)
  engine.attachNode(delay)
  engine.attachNode(reverb)
  
  let format = file.processingFormat
  
  // Connect nodes
  engine.connect(player, to: delay, format: format)
  engine.connect(delay, to: reverb, format: format)
  engine.connect(reverb, to: engine.mainMixerNode, format: format)
  
  do {
    try engine.start()
  }catch {
    fatalError("Could not start engine. error: \(error).")
  }

  player.scheduleFile(file, atTime: nil, completionHandler: nil)
  
  // Start the player.
  player.play()

}catch{
  print(error)
}


XCPSetExecutionShouldContinueIndefinitely(true)
