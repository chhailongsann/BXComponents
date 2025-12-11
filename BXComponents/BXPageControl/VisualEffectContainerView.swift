//
//  VisualEffectContainerView.swift
//  BXComponents
//
//  Created by Chhailong Sann on 8/12/25.
//
import UIKit
import BXAnchor

class VisualEffectContainerView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    let effect: UIVisualEffect
    if #available(iOS 26.0, *) {
      effect = UIGlassEffect(style: .regular)
    } else {
      effect = UIBlurEffect(style: .regular)
    }

    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    clipsToBounds = true
    layer.cornerRadius = frame.height / 2

    visualEffectView.layout(in: self) {
      $0.fill()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
