//
//  Wheeler.swift
//  BXComponents
//
//  Created by Chhailong on 4/5/26.
//

import UIKit
import BXAnchor

open class Wheeler: UIView {
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
  
  required public init?(coder: NSCoder) {
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
  
  private let numberOfWheels: Int = 20
  private let padding: CGFloat = 32
  private let width: CGFloat = 30
  private let height: CGFloat = 50
  
  private let step: CGFloat = 12        // distance between ticks
  private let totalTicks = 100_000
  
  private func setupWheels() {
    
    scrollView.decelerationRate = .fast
    scrollView.showsHorizontalScrollIndicator = false
    
    let contentWidth = CGFloat(totalTicks) * step
    scrollView.contentSize = CGSize(width: contentWidth, height: bounds.height)
    scrollView.contentInset.left = contentWidth/2
    scrollView.contentInset.right = contentWidth/2
    for i in 0..<totalTicks {
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
  
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    let inset = bounds.width / 2
//    scrollView.contentInset.left = inset
//    scrollView.contentInset.right = inset
//  }
  
}


extension Wheeler: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {

  }
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

  }
}
