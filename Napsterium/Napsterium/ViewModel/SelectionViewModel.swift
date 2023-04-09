//
//  SelectionViewModel.swift
//  Napsterium
//
//  Created by Kamber Vogli on 09.04.23.
//

import Foundation

class SelectionViewModel: ObservableObject {
  @Published var selection: Set<String> = []
  
  func selectOrDeselect(videoId: String) {
    if selection.contains(videoId) {
      selection.remove(videoId)
    } else {
      selection.insert(videoId)
    }
  }
}
