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
  let audioPlayerDelegate = AudioPlayerDelegate()
  var song = SongRepository.sampleSongs.first
  @State var value : Float = 0
  
  var body: some View {
    VStack(spacing: 5) {
      Capsule()
        .fill(Color.gray)
        .frame(width: expand ? 60 : 0, height: expand ? 4 : 0)
        .opacity(expand ? 1 : 0)
        .padding(.top, expand ? safeArea?.top : 0)
        .padding(.vertical, expand ? 30 : 0)
      
      // MARK: Image, title, play button, forward button
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
              .font(.callout)
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
      
      // MARK: Progress bar of the playing song
      ProgressView(value: value, total: 240) //TODO: assign total from selectedSong.duration
        .progressViewStyle(LinearProgressViewStyle())
        .tint(.white)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .onAppear {
          // 2
          Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if isPlaying {
              self.value += 1
            }
          }
        }
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
      audioPlayer?.delegate = audioPlayerDelegate
      audioPlayerDelegate.songFinishedPlaying = {
        isPlaying = false
      }
    } catch {
      print("Error playing audio: \(error.localizedDescription)")
    }
  }
}
