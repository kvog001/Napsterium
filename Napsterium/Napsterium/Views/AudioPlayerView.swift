//
//  SongPlayer.swift
//  Napsterium
//
//  Created by Kamber Vogli on 06.04.23.
//

import AVKit
import SwiftUI

struct AudioPlayerView: View {
  @ObservedObject var audioPlayerViewModel: AudioPlayerViewModel
  
  init(audioPlayerViewModel: AudioPlayerViewModel) {
    self.audioPlayerViewModel = audioPlayerViewModel
  }
  
  var body: some View {
    VStack(spacing: 2) {
      // MARK: Song image and title
      HStack(spacing: 15) {
        ThumbnailView(thumbnail: audioPlayerViewModel.currentSong.thumbnailURL)
          .aspectRatio(contentMode: .fill)
          .frame(width : 47, height: 47)
          .cornerRadius(5)
        
        Text(audioPlayerViewModel.currentSong.title)
          .lineLimit(1)
          .font(.callout)
        
        Spacer(minLength: 0)
        
        // MARK: Play button
        Button {
          if !audioPlayerViewModel.isPlaying {
            audioPlayerViewModel.playAudio()
          } else {
            audioPlayerViewModel.pauseAudio()
          }
        } label: {
          Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
            .font(.title2)
            .foregroundColor(.primary)
        }
        
        // MARK: Repeat button
        Button {
          audioPlayerViewModel.replayAudio()
        } label: {
          Image(systemName: audioPlayerViewModel.replay ? "repeat.1" : "repeat")
            .font(.title2)
            .foregroundColor(.primary)
        }
        
      }
      .padding(.horizontal)
      
      // MARK: Progress bar of the playing song
      ProgressView(value: audioPlayerViewModel.value, total: Float(audioPlayerViewModel.currentSong.duration))
        .progressViewStyle(LinearProgressViewStyle())
        .tint(.white)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .onAppear {
          Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if audioPlayerViewModel.isPlaying {
              self.audioPlayerViewModel.value += 1
            }
          }
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
}

struct AudioPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    AudioPlayerView(audioPlayerViewModel: AudioPlayerViewModel(songRepository: SongRepository()))
  }
}
