//
//  SongPlayer.swift
//  Napsterium
//
//  Created by Kamber Vogli on 06.04.23.
//

import SwiftUI
import AVKit

struct AudioPlayerView: View {
  @State var value : Float = 0
  @State var isPlaying = false
  @State var audioPlayer: AVAudioPlayer?
  @ObservedObject var songSelection: SongSelection
  
  var song = SongRepository.sampleSongs.first
  let audioPlayerDelegate = AudioPlayerDelegate()
  
  var body: some View {
    VStack(spacing: 2) {
      // MARK: Image, title, play button, forward button
      HStack(spacing: 15) {
        if let selectedSong = songSelection.selectedSong {
          ThumbnailView(thumbnail: selectedSong.thumbnailURL)
            .aspectRatio(contentMode: .fill)
            .frame(width : 50, height : 50)
            .cornerRadius(5)
        } else {
          Image("paradise")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width : 50, height: 50)
            .cornerRadius(5)
        }
        
        if let selectedSong = songSelection.selectedSong {
          Text(selectedSong.title)
            .font(.callout)
        } else {
          Text("Lady Gaga")
            .font(.title2)
            .fontWeight(.bold)
        }
        
        Spacer(minLength: 0)
        
        Button {
          isPlaying = !isPlaying
          if isPlaying {
            playAudio()
          } else {
            pauseAudio()
          }
        } label: {
          Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            .font(.title2)
            .foregroundColor(.primary)
        }
        .onReceive(songSelection.$selectedSong) { song in
          guard let song = song else { return }
          updateAudioPlayer(with: song)
        }
        
        Button {
          // TODO: next song
        } label: {
          Image(systemName: "forward.fill")
            .font(.title2)
            .foregroundColor(.primary)
        }
        
      }
      .padding(.horizontal)
      
      // MARK: Progress bar of the playing song
      ProgressView(value: value, total: 240) //TODO: assign total from selectedSong.duration
        .progressViewStyle(LinearProgressViewStyle())
        .tint(.white)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .onAppear {
          Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if isPlaying {
              self.value += 1
            }
          }
        }
        .onReceive(songSelection.$selectedSong) { _ in
          self.value = 0
        }
    }
    .frame(maxHeight: 80)
    .background(
      VStack(spacing: 0) {
        RoundedRectangle(cornerRadius: 8)
          .foregroundColor(.gray)
          .padding(5)
      }
    )
    .ignoresSafeArea()
    .offset(y: -48)
  }
  
  func playAudio() {
    guard let player = audioPlayer else { return }
    player.play()
  }
  
  func pauseAudio() {
    guard let player = audioPlayer else { return }
    player.pause()
  }
  
  private func updateAudioPlayer(with song: Song) {
    do {
      if isPlaying {
        audioPlayer?.pause()
        isPlaying = false
      }
      audioPlayer = try AVAudioPlayer(data: song.mp3Data)
      audioPlayer?.play()
      isPlaying = true
      audioPlayer?.delegate = audioPlayerDelegate
      audioPlayerDelegate.songFinishedPlaying = {
        isPlaying = false
      }
    } catch {
      print("Error playing audio: \(error.localizedDescription)")
    }
  }
}

struct AudioPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    AudioPlayerView(songSelection: SongSelection())
  }
}
