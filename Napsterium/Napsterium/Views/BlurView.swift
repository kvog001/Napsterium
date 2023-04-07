//
//  BlurView.swift
//  Napsterium
//
//  Created by Kamber Vogli on 06.04.23.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    return view
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    
  }
}
