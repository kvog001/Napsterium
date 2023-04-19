//
//  AudioPlayerDelegate.swift
//  Napsterium
//
//  Created by Kamber Vogli on 08.04.23.
//

import AVKit

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
  var songFinishedPlaying: (() -> Void)?

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    songFinishedPlaying?()
  }
}
