//
//  AudioPlayerViewModel.swift
//  Napsterium
//
//  Created by Kamber Vogli on 13.04.23.
//

import AVKit
import Combine
import SwiftUI

class AudioPlayerViewModel: ObservableObject {
  @Published var replay = false
  @Published var value : Float = 0
  @Published var isPlaying = false
  @Published var currentSong: Song
  @Published var audioPlayer: AVAudioPlayer?
  @ObservedObject var songRepository: SongRepository
  
  private let audioPlayerDelegate = AudioPlayerDelegate()
  
  init(songRepository: SongRepository) {
    if let lastPlayedSongId = UserDefaults.standard.string(forKey: "lastPlayedSong"),
       let lastPlayedSong = SongManager.shared.loadSong(withId: lastPlayedSongId) {
      do {
        if let mp3Data = lastPlayedSong.mp3Data {
          audioPlayer = try AVAudioPlayer(data: mp3Data)
        }
//        audioPlayer?.prepareToPlay()
      } catch {
        print("Could not create audio player from last played song!")
      }
      currentSong = lastPlayedSong
    } else {
      currentSong = SongRepository.sampleSongs.first!
    }
    self.songRepository = songRepository
  }
  
  func replayAudio() {
    replay = !replay
  }
  
  func playAudio() {
    guard let player = audioPlayer else { return }
    player.play()
    if !isPlaying {
      isPlaying = true
    }
  }
  
  func pauseAudio() {
    guard let player = audioPlayer else { return }
    player.pause()
    if isPlaying {
      isPlaying = false
    }
  }
  
  func updateAudioPlayer(with song: Song) {
    value = 0
    currentSong = song
    if isPlaying {
      audioPlayer?.pause()
      isPlaying = false
    }
    guard let mp3Data = song.mp3Data else {
      return
    }
    do {
      audioPlayer = try AVAudioPlayer(data: mp3Data)
      audioPlayer?.play()
      isPlaying = true
      audioPlayer?.delegate = audioPlayerDelegate
      audioPlayerDelegate.songFinishedPlaying = { [weak self] in
        guard let self = self else { return } // Unwrap weak self to avoid nil reference

        self.isPlaying = false
        self.value = 0
        if self.replay {
          self.playAudio()
        } else {
          // play next song
          if let nextSong = self.songRepository.getNextSongAfter(song: self.currentSong) {
            self.updateAudioPlayer(with: nextSong)
          }
        }
      }
      
      // store song to user defaults // TODO: move this to onPhaseChange/onSceneChange
      UserDefaults.standard.set(song.id, forKey: "lastPlayedSong")
    } catch {
      print("Error playing audio: \(error.localizedDescription)")
    }
  }
}
