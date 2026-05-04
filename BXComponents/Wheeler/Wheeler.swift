//
//  Wheeler.swift
//  BXComponents
//
//  Created by Chhailong on 4/5/26.
//

import UIKit
import BXAnchor

final class Wheeler: UIView {
  enum Axis {
    case horizontal
    case vertical
  }
  
  private var scrollview: UIScrollView!
  
  private let axis: Axis
  init(axis: Axis = .horizontal) {
    self.axis = axis
    super.init(frame: .zero)
    setupScrollView()
    setupWheels()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupScrollView() {
//    backgroundColor = .systemBackground
    scrollview = UIScrollView()
    scrollview.layout(in: self) {
      $0.fill()
    }
    
    scrollview.showsHorizontalScrollIndicator = true
//    switch axis {
//    case .horizontal:
//      scrollview.bouncesVertically = false
//    case .vertical:
//      scrollview.bouncesHorizontally = false
//    }
    
  }
  
  private func setupWheels() {
    for i in 0..<120 {
      let dot = UIView(frame: .init(x: i * 12, y: 0, width: 2, height: 30))
      let color: UIColor = .random
      dot.backgroundColor = color
      scrollview.addSubview(dot)
    }
    scrollview.contentSize = .init(width: 2*120 + 12*119, height: 30)
  }
}
