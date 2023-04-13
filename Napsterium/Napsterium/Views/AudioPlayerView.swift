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
  @ObservedObject var audioPlayerViewModel: AudioPlayerViewModel
  
  init(audioPlayerViewModel: AudioPlayerViewModel) {
    self.audioPlayerViewModel = audioPlayerViewModel
  }
  
  var body: some View {
    VStack(spacing: 2) {
      // MARK: Image, title, play button, forward button
      HStack(spacing: 15) {
        if let selectedSong = audioPlayerViewModel.currentSong {
          ThumbnailView(thumbnail: selectedSong.thumbnailURL)
            .aspectRatio(contentMode: .fill)
            .frame(width : 50, height : 50)
            .cornerRadius(5)
        } else {
          ThumbnailView(thumbnail: audioPlayerViewModel.currentSong.thumbnailURL)
            .aspectRatio(contentMode: .fill)
            .frame(width : 50, height: 50)
            .cornerRadius(5)
        }
        
        if let selectedSong = audioPlayerViewModel.currentSong {
          Text(selectedSong.title)
            .lineLimit(1)
            .font(.callout)
        } else {
          Text(audioPlayerViewModel.currentSong.title)
            .lineLimit(1)
            .font(.callout)
        }
        
        Spacer(minLength: 0)
        
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
        
        Button {
          // TODO: replay current song
        } label: {
          Image(systemName: "repeat")
            .font(.title2)
            .foregroundColor(.primary)
        }
        
      }
      .padding(.horizontal)
      
      // MARK: Progress bar of the playing song
      ProgressView(value: value, total: Float(audioPlayerViewModel.currentSong.duration))
        .progressViewStyle(LinearProgressViewStyle())
        .tint(.white)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .onAppear {
          Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if audioPlayerViewModel.isPlaying {
              self.value += 1
            }
          }
        }
        .onReceive(audioPlayerViewModel.$currentSong) { _ in
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
}

struct AudioPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    AudioPlayerView(audioPlayerViewModel: AudioPlayerViewModel())
  }
}
