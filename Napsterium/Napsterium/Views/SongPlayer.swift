//
//  SongPlayer.swift
//  Napsterium
//
//  Created by Kamber Vogli on 06.04.23.
//

import SwiftUI
import AVKit

struct SongPlayer: View {
  var animation: Namespace.ID
  @Binding var expand: Bool
  var height = UIScreen.main.bounds.height / 3
  var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
  @State var isPlaying = false
  @ObservedObject var songSelection: SongSelection
  @State var audioPlayer: AVAudioPlayer?
  var song = SongRepository.sampleSongs.first
  
  var body: some View {
    VStack {
      Capsule()
        .fill(Color.gray)
        .frame(width: expand ? 60 : 0, height: expand ? 4 : 0)
        .opacity(expand ? 1 : 0)
        .padding(.top, expand ? safeArea?.top : 0)
        .padding(.vertical, expand ? 30 : 0)
      
      HStack(spacing: 15) {
        if expand {
          Spacer(minLength: 0)
        }
        if let selectedSong = songSelection.selectedSong {
          ThumbnailView(thumbnail: selectedSong.thumbnailURL)
            .aspectRatio(contentMode: .fill)
            .frame(width: expand ? height : 55, height: expand ? height : 55)
            .cornerRadius(5)
        } else {
          Image("paradise")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: expand ? height : 55, height: expand ? height : 55)
            .cornerRadius(5)
        }
        
        if !expand {
          if let selectedSong = songSelection.selectedSong {
            Text(selectedSong.title)
              .font(.title2)
              .fontWeight(.bold)
              .matchedGeometryEffect(id: "Label", in: animation)
          } else {
            Text("Lady Gaga")
              .font(.title2)
              .fontWeight(.bold)
              .matchedGeometryEffect(id: "Label", in: animation)
          }
        }
        
        Spacer(minLength: 0)
        
        if !expand {
          Button {
            isPlaying = !isPlaying
            if isPlaying {
              playAudio()
            } else {
              pauseAudio()
            }
          } label: {
            if isPlaying {
              Image(systemName: "pause.fill")
                .font(.title2)
                .foregroundColor(.primary)
            } else {
              Image(systemName: "play.fill")
                .font(.title2)
                .foregroundColor(.primary)
            }
          }
          .onReceive(songSelection.$selectedSong) { song in
            guard let song = song else { return }
            updateAudioPlayer(with: song)
          }
          
          Button {
            
          } label: {
            Image(systemName: "forward.fill")
              .font(.title2)
              .foregroundColor(.primary)
          }
        }
      }
      .padding(.horizontal)
      
      VStack {
        HStack {
          if expand {
            Text("Lady Gaga")
              .font(.title2)
              .foregroundColor(.primary)
              .fontWeight(.bold)
              .matchedGeometryEffect(id: "Label", in: animation)
          }
          
          Spacer(minLength: 0)
          
          Button {
            
          } label: {
            Image(systemName: "ellipsis.circle")
              .font(.title2)
              .foregroundColor(.primary)
          }
        }
        .padding()
        
        Spacer(minLength: 0)
      }
      // stretch effect
      .frame(width: expand ? nil : 0, height: expand ? nil : 0)
      .opacity(expand ? 1 : 0)
    }
    .frame(maxHeight: expand ? .infinity : 80)
    .background(
      VStack(spacing: 0) {
        BlurView()
        Divider()
      }
        .onTapGesture {
          withAnimation(.spring()) {
            expand.toggle()
          }
        }
    )
    .ignoresSafeArea()
    .offset(y: expand ? 0 : -48)
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
      audioPlayer = try AVAudioPlayer(data: song.mp3Data)
    } catch {
      print("Error playing audio: \(error.localizedDescription)")
    }
  }
}
