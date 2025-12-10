//
//  IndicatorView.swift
//  BXComponents
//
//  Created by Chhailong Sann on 18/9/25.
//

import UIKit

class IndicatorView: UIVisualEffectView {
  init() {
    let effect: UIVisualEffect
    if #available(iOS 26.0, *) {
      effect = UIGlassEffect(style: .regular)
    } else {
      effect = UIBlurEffect(style: .systemChromeMaterial)
    }
    super.init(effect: effect)
    autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
