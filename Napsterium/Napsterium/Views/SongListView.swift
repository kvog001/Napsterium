//
//  SongListView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 21.02.23.
//

import SwiftUI

struct SongListView: View {
  
  let bgColor = Color(hue: 0.0, saturation: 0.0, brightness: 0.071)
  
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
              .frame(width: height,
                     height: height)
              .offset(y: offsetY)
              .opacity(opacity)
              .shadow(color: Color.black.opacity(0.5), radius: 30)
          }
        }
        .frame(height: 200) // size of album
        
        Section {
          ForEach(SongRepository.sampleSongs) { song in
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.0001))
              SongRowView(song: song)
            }
            .padding(EdgeInsets(top: 10, leading: 7, bottom: 0, trailing: 7))
            .onTapGesture {
              print("\(song.title) was pressed")
            }
            .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) {
              print("onLongPress detected - todo")
            }

          }
        } header: {
          Text("All songs")
            .font(.title)
        }
      }
      .coordinateSpace(name: "scrollView")
      .background(bgColor.ignoresSafeArea())
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
