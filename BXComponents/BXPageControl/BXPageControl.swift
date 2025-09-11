//
//  BXPageControl.swift
//  BXComponents
//
//  Created by Chhailong on 9/9/25.
//

import UIKit

class BXPageControl: UIView {
  
  enum Style {
    case dots
    case snakes
    case instagram
  }
  
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = spacing
    stackView.axis = .horizontal
    return stackView
  }()
  
  var currentPageIndicatorTintColor: UIColor = .label {
    didSet {
      let dots = stackView.arrangedSubviews
      dots.forEach {
        $0.backgroundColor = $0.tag == self.currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      }
    }
  }
   
  var pageIndicatorTintColor: UIColor = .secondaryLabel {
    didSet {
      let dots = stackView.arrangedSubviews
      dots.forEach {
        $0.backgroundColor = $0.tag == self.currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      }
    }
  }
  
  private var spacing: CGFloat = 6
  private var size: CGFloat = 8
  private var padding: CGFloat = 6
  private var currentPage: Int = 0
  
  
  var numberOfPages: Int = 1
  
  public func setNumberOfPages(_ numberOfPages: Int) {
    assert(numberOfPages > 0, "Number of pages must be greater than zero")
    self.numberOfPages = numberOfPages
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    (0..<numberOfPages).forEach { i in
        let dot = UIView()
      dot.tag = i
      dot.width( i == currentPage ? size * 3 : size)
      dot.height(size)
      dot.clipsToBounds = true
      dot.layer.cornerRadius = size / 2
      dot.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      stackView.addArrangedSubview(dot)
    }
  }
  
  public func setCurrentPage(_ currentPage: Int) {
    self.currentPage = currentPage
  }
  
  let style: Style
  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupViews() {
    backgroundColor = .label.withAlphaComponent(0.3)
    clipsToBounds = true
    layer.cornerRadius = self.padding + (self.size / 2)
    
    
    
    stackView.layout(in: self) {
      $0.fill(padding: .all(padding))
    }
  }
}
