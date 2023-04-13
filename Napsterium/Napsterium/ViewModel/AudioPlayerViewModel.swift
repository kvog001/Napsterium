//
//  AudioPlayerViewModel.swift
//  Napsterium
//
//  Created by Kamber Vogli on 13.04.23.
//

import AVKit
import Combine

class AudioPlayerViewModel: ObservableObject {
  @Published var isPlaying = false
  @Published var currentSong: Song
  @Published var audioPlayer: AVAudioPlayer?
  
  private let audioPlayerDelegate = AudioPlayerDelegate()
  
  init() {
    if let lastPlayedSongData = UserDefaults.standard.data(forKey: "lastPlayedSong"),
       let lastPlayedSong = try? PropertyListDecoder().decode(Song.self, from: lastPlayedSongData) {
      do {
        audioPlayer = try AVAudioPlayer(data: lastPlayedSong.mp3Data)
//        audioPlayer?.prepareToPlay()
      } catch {
        print("Could not create audio player from last played song!")
      }
      currentSong = lastPlayedSong
    } else {
      currentSong = SongRepository.sampleSongs.first!
    }
  }
  
  func selectSong(_ song: Song) {
    updateAudioPlayer(with: song)
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
    currentSong = song
    if isPlaying {
      audioPlayer?.pause()
      isPlaying = false
    }
    do {
      audioPlayer = try AVAudioPlayer(data: song.mp3Data)
      audioPlayer?.play()
      isPlaying = true
      audioPlayer?.delegate = audioPlayerDelegate
      audioPlayerDelegate.songFinishedPlaying = {
        self.isPlaying = false
      }
      
      // store song to user defaults // TODO: move this to onPhaseChange/onSceneChange
      let encoder = PropertyListEncoder()
      if let encoded = try? encoder.encode(song) {
        UserDefaults.standard.set(encoded, forKey: "lastPlayedSong")
      }
    } catch {
      print("Error playing audio: \(error.localizedDescription)")
    }
  }
}
