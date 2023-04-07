//
//  MiniPlayer.swift
//  Napsterium
//
//  Created by Kamber Vogli on 06.04.23.
//

import SwiftUI
import AVKit

struct MiniPlayer: View {
  var animation: Namespace.ID
  @Binding var expand: Bool
  var height = UIScreen.main.bounds.height / 3
  var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
  @State var isPlaying = false
  var audioPlayer: AVAudioPlayer?
  
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
        Image("paradise")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: expand ? height : 55, height: expand ? height : 55)
          .cornerRadius(5)
        
        if !expand {
          Text("Lady Gaga")
            .font(.title2)
            .fontWeight(.bold)
            .matchedGeometryEffect(id: "Label", in: animation)
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
    guard let url = Bundle.main.url(forResource: "filename", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = audioPlayer else {
                print("Audio player not initialized")
                return
            }
            
            player.play()
            isPlaying = true
        } catch let error {
            print(error.localizedDescription)
        }
  }
  
  func pauseAudio() {
    
  }
}
