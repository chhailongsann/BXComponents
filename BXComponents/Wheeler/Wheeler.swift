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
  
  private var scrollView: UIScrollView!
  
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
    scrollView = UIScrollView()
    scrollView.layout(in: self) {
      $0.fill()
    }
    
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    switch axis {
    case .horizontal:
      scrollView.bouncesVertically = false
    case .vertical:
      scrollView.bouncesHorizontally = false
    }
    
    // Delegate
    self.scrollView.delegate = self
    
  }
  
  private let numberOfWheels: Int = 120
  private let padding: CGFloat = 12
  private let width: CGFloat = 3
  private let height: CGFloat = 30
  
  private func setupWheels() {
    for i in 0..<numberOfWheels {
      let dot = UIView(frame: .init(x: CGFloat(i) * (padding+width), y: 0, width: width, height: height))
      let color: UIColor = .random
      dot.backgroundColor = color
      dot.tag = i
      scrollView.addSubview(dot)
    }
    scrollView.contentSize = .init(width: width * CGFloat(numberOfWheels) + padding * CGFloat(numberOfWheels - 1), height: height)
    let containerWidth = bounds.width
    scrollView.contentInset.left = containerWidth/2
    scrollView.contentInset.right = containerWidth/2
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let inset = bounds.width / 2
    scrollView.contentInset.left = inset
    scrollView.contentInset.right = inset
  }
  
}


extension Wheeler: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let subviews = scrollView.subviews
    scrollView.subviews.forEach { subview in
      let location = subview.convert(subview.bounds, to: scrollView)
      print(location.origin)
    }
  }
}
