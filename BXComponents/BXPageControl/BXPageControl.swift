//
//  BXPageControl.swift
//  BXComponents
//
//  Created by Chhailong on 9/9/25.
//

import UIKit

class BXPageControl: UIView {

  enum Alignment {
    case leading
    case trailing
    case center
  }

//  enum Style {
//    case dots
//    case snakes
//    case instagram
//  }

  private var currentPageIndicatorView: UIView?
  private var leadingConstraint: NSLayoutConstraint?
  private var trailingConstraint: NSLayoutConstraint?
  private var centerConstaint: NSLayoutConstraint?
  private var indicatorWidthConstraint: [Int: NSLayoutConstraint] = [:]

  private var visualEffectView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return view
  }()
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = spacing
    stackView.axis = .horizontal
    stackView.layoutMargins = .zero
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
   
  var pageIndicatorTintColor: UIColor = .secondaryLabel.withAlphaComponent(0.4) {
    didSet {
      let dots = stackView.arrangedSubviews
      dots.forEach {
        $0.backgroundColor = $0.tag == self.currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      }
    }
  }
  
  var spacing: CGFloat = 6 {
    didSet {
      stackView.spacing = spacing
      setCurrentPage(self.currentPage)
    }
  }
  private var size: CGFloat = 6
  private var currentPageWidthMultiplier: CGFloat = 4
  private var padding: CGFloat = 8
  private var currentPage: Int = 0


  
  var numberOfPages: Int = 1

  
  public func setNumberOfPages(_ numberOfPages: Int) {
    assert(numberOfPages > 0, "Number of pages must be greater than zero")

    self.numberOfPages = numberOfPages
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    subviews.forEach { subview in
      if subview.isKind(of: IndicatorView.self) {
        subview.removeFromSuperview()
      }
    }
    (0..<numberOfPages).forEach { i in
      let circle = IndicatorView()
      circle.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      circle.tag = i
      
      circle.layer.cornerRadius = size / 2
      circle.height(size)
      let widthConstraint = circle.widthAnchor.constraint(equalToConstant: i == currentPage ? size * currentPageWidthMultiplier : size)
      widthConstraint.isActive = true
      indicatorWidthConstraint[i] = widthConstraint
      
      stackView.addArrangedSubview(circle)
      let scale: CGFloat = i == currentPage ? 1 : 1
      circle.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
  }
  
  public func setCurrentPage(_ currentPage: Int, withAnimation: Bool = true) {
    if currentPage < 0 || currentPage >= numberOfPages {
      return
    }
    Haptic.selection.generate()
    self.currentPage = currentPage

    stackView.arrangedSubviews.forEach { circle in
      let i = circle.tag
      if let widthConstraint = indicatorWidthConstraint[i] {
        widthConstraint.constant = i == currentPage ? size * currentPageWidthMultiplier : size
      }
      let scale: CGFloat = i == currentPage ? 1 : 1
      UIView.animate(withDuration: 0.25) {
        circle.transform = CGAffineTransform(scaleX: scale, y: scale)
        circle.backgroundColor = i == currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor
        self.layoutIfNeeded()
      }
    }
  }

  public func next() {
    if currentPage < numberOfPages - 1 {
      currentPage += 1
      setCurrentPage(currentPage)
    }
  }

  public func previous() {
    if currentPage > 0 {
      currentPage -= 1
      setCurrentPage(currentPage)
    }
  }

  var alignment: Alignment = .center {
    didSet {
      switch alignment {
      case .leading:
        leadingConstraint?.isActive = true
        trailingConstraint?.isActive = false
        centerConstaint?.isActive = false
      case .trailing:
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = true
        centerConstaint?.isActive = false
      case .center:
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
        centerConstaint?.isActive = true
      }
    }
  }
  init(alignment: Alignment) {
    self.alignment = alignment
    super.init(frame: .zero)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func setupViews() {
    visualEffectView.layout(in: self) {
      $0.top()
        .bottom()
      $0.clipsToBounds = true
      $0.layer.cornerRadius = self.padding + (self.size / 2)
    }
    stackView.layout(in: visualEffectView.contentView) {
      $0.fill(padding: .all(self.padding))
    }
    
    leadingConstraint = visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor)
    trailingConstraint = visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor)
    centerConstaint = visualEffectView.centerXAnchor.constraint(equalTo: centerXAnchor)
    switch alignment {
    case .leading:
      leadingConstraint?.isActive = true
      trailingConstraint?.isActive = false
      centerConstaint?.isActive = false
    case .trailing:
      leadingConstraint?.isActive = false
      trailingConstraint?.isActive = true
      centerConstaint?.isActive = false
    case .center:
      leadingConstraint?.isActive = false
      trailingConstraint?.isActive = false
      centerConstaint?.isActive = true
    }
  }
}

extension BXPageControl {
  static var leadingIndicator: BXPageControl {
    return .init(alignment: .leading)
  }
  static var centerIndicator: BXPageControl {
    let pageControl = BXPageControl(alignment: .center)
    pageControl.spacing = 6
    return pageControl
  }
  static var trailingIndicator: BXPageControl {
    return .init(alignment: .trailing)
  }
}
