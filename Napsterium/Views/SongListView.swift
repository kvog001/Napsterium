//
//  SongListView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct SongListView: View {
  @ObservedObject var songRepository: SongRepository
  @ObservedObject var audioPlayerViewModel: AudioPlayerViewModel
  @Environment(\.scenePhase) private var scenePhase
  
  let bgColor = Color(hue: 0.0, saturation: 0.0, brightness: 0.071)
  //  let saveAction: ()->Void
  
  func getOffsetY(reader: GeometryProxy) -> CGFloat {
    let offsetY: CGFloat = -reader.frame(in: .named("scrollView")).minY
    if offsetY < 0 {
      return offsetY / 1.3
    }
    return offsetY
  }
  
  var body: some View {
    ScrollView(showsIndicators: true) {
      GeometryReader { reader in
        let offsetY = getOffsetY(reader: reader)
        let height: CGFloat = (reader.size.height - offsetY) + offsetY / 3
        let minHeight: CGFloat = 120
        let opacity = (height - minHeight) / (reader.size.height - minHeight)
        ZStack {
          LinearGradient(
            gradient: Gradient(colors: [Color.yellow, Color.black]),
            startPoint: .top, endPoint: .bottom
          )
            .scaleEffect(10)
          Image("paradise")
            .resizable()
            .frame(width: max(0, height), // TODO: fix UI, when scrolling up to the top, you can see the end of the gradient below
                   height: max(0, height))
            .offset(y: offsetY)
            .opacity(opacity)
            .shadow(color: Color.black.opacity(0.5), radius: 30)
        }
      }
      .frame(height: 200) // size of album picture
      
      Section {
        ForEach(songRepository.sortedSongsByDate) { song in
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.black.opacity(0.0001))
            SongRowView(song: song, songRepository: songRepository)
          }
          .padding(EdgeInsets(top: 10, leading: 7, bottom: 0, trailing: 7))
          .onTapGesture {
            if song.isDataLoaded {
              audioPlayerViewModel.updateAudioPlayer(with: song)
            } else {
              print("The song is being downloaded!")
              //TODO: show an Alert
            }
          }
          .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) {
            print("onLongPress detected - todo")
          }
          
        }
      } header: {
        Text("Your playlist")
          .foregroundColor(.white)
          .kerning(1.5)
          .font(.title)
          .fontWeight(.semibold)
      }
      //        .onChange(of: scenePhase) { newPhase in
      //          if newPhase == .inactive {
      //            saveAction()
      //          }
      //        }
      Spacer()
        .frame(height: 80)
    }
    .coordinateSpace(name: "scrollView")
    .background(bgColor.ignoresSafeArea())
  }
}

struct SongListView_Previews: PreviewProvider {
  static var previews: some View {
    SongListView(songRepository: SongRepository(), audioPlayerViewModel: AudioPlayerViewModel(songRepository: SongRepository()))
  }
}
