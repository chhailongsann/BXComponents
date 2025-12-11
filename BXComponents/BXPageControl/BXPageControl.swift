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

  enum Style {
    case dot
    case snake
    case caterpillar
  }

  private var leadingConstraint: NSLayoutConstraint?
  private var trailingConstraint: NSLayoutConstraint?
  private var centerConstraint: NSLayoutConstraint?
  private var indicatorWidthConstraints: [Int: NSLayoutConstraint] = [:]

  private lazy var containerVisualEffectView = VisualEffectContainerView().config {
    $0.backgroundColor = .clear
    $0.layer.cornerRadius = padding + (size / 2)
  }


  private lazy var currentIndicatorView = IndicatorView().config {
    $0.layer.cornerRadius = size / 2
    $0.backgroundColor = currentPageIndicatorTintColor
  }
  private var currentIndicatorLeadingConstraint: NSLayoutConstraint?

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = spacing
    stackView.axis = .horizontal
    stackView.layoutMargins = .zero
    return stackView
  }()

  var currentPageIndicatorTintColor: UIColor = .black {
    didSet {
      let dots = stackView.arrangedSubviews
      dots.forEach {
        $0.backgroundColor = $0.tag == self.currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      }
      currentIndicatorView.backgroundColor = currentPageIndicatorTintColor
    }
  }

  var pageIndicatorTintColor: UIColor = .gray.withAlphaComponent(0.4) {
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
  fileprivate var size: CGFloat = 6
  fileprivate var currentPageWidth: CGFloat {
    get {
      switch style {
          case .dot: return size
        default: return size * 2 + spacing
      }
    }
  }
  fileprivate var padding: CGFloat = 8
  fileprivate var currentPage: Int = 0



  private var numberOfPages: Int = 1


  public func setNumberOfPages(_ numberOfPages: Int) {
    assert(numberOfPages > 0, "Number of pages must be greater than zero")

    self.numberOfPages = numberOfPages
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    (0..<numberOfPages).forEach { i in
      let circle = IndicatorView()
      circle.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      circle.tag = i

      circle.layer.cornerRadius = size / 2
      circle.height(size)
      let widthConstraint = circle.widthAnchor.constraint(equalToConstant: i == currentPage ? currentPageWidth : size)
      widthConstraint.isActive = true
      indicatorWidthConstraints[i] = widthConstraint

      stackView.addArrangedSubview(circle)
      let scale: CGFloat = i == currentPage ? 1 : 0.8
      circle.transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    // add current indicator
    if style == .caterpillar {
      currentIndicatorView.layout(in: self) {
        $0.height(size)
          .width(currentPageWidth)
          .centerY()
      }
      currentIndicatorLeadingConstraint = currentIndicatorView.leadingAnchor.constraint(equalTo: containerVisualEffectView.leadingAnchor, constant: padding)
      currentIndicatorLeadingConstraint?.isActive = true
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
      if let widthConstraint = indicatorWidthConstraints[i] {
        widthConstraint.constant = i == currentPage ? currentPageWidth : size
      }
      let scale: CGFloat = i == currentPage ? 1 : 0.8
      UIView.animate(withDuration: 0.15) {
        circle.transform = CGAffineTransform(scaleX: scale, y: scale)
        circle.backgroundColor = i == currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor
        self.layoutIfNeeded()
      }
    }
    self.currentIndicatorLeadingConstraint?.constant = self.padding + CGFloat(currentPage) * (self.size + self.spacing)
    UIView.animate(withDuration: 0.25) {
      self.layoutIfNeeded()
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

  var alignment: BXPageControl.Alignment = .center {
    didSet {
      switch alignment {
      case .leading:
        leadingConstraint?.isActive = true
        trailingConstraint?.isActive = false
        centerConstraint?.isActive = false
      case .trailing:
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = true
        centerConstraint?.isActive = false
      case .center:
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
        centerConstraint?.isActive = true
      }
    }
  }
  var style: BXPageControl.Style = .dot {
    didSet {
      switch style {
        case .dot:
          currentIndicatorView.isHidden = true
        case .snake:
          currentIndicatorView.isHidden = true
        case .caterpillar:
          currentIndicatorView.isHidden = false
      }
    }
  }
  init(alignment: Alignment = .center, style: BXPageControl.Style) {
    self.alignment = alignment
    self.style = style
    super.init(frame: .zero)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Prepare Layout
  private func resetSubviews() {

    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    subviews.forEach { subview in
      if subview.isKind(of: IndicatorView.self) {
        subview.removeFromSuperview()
      }
    }
    (0..<numberOfPages).forEach { i in
      let circle = IndicatorView()
      circle.setIndicatorColor(i == self.currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor)
      circle.tag = i

      let widthConstraint = circle.widthAnchor.constraint(equalToConstant: i == currentPage ? currentPageWidth : size)
      widthConstraint.isActive = true
      indicatorWidthConstraints[i] = widthConstraint

      stackView.addArrangedSubview(circle)
    }
  }
  private func setupViews() {

    containerVisualEffectView.layout(in: self) {
      $0.top()
        .bottom()
    }
    leadingConstraint = containerVisualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor)
    trailingConstraint = containerVisualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor)
    centerConstraint = containerVisualEffectView.centerXAnchor.constraint(equalTo: centerXAnchor)
    switch alignment {
    case .leading:
      leadingConstraint?.isActive = true
      trailingConstraint?.isActive = false
      centerConstraint?.isActive = false
    case .trailing:
      leadingConstraint?.isActive = false
      trailingConstraint?.isActive = true
      centerConstraint?.isActive = false
    case .center:
      leadingConstraint?.isActive = false
      trailingConstraint?.isActive = false
      centerConstraint?.isActive = true
    }
    switch style {
      case .dot:
        currentIndicatorView.isHidden = true
      case .snake:
        currentIndicatorView.isHidden = true
      case .caterpillar:
        currentIndicatorView.isHidden = false
    }


    stackView.layout(in: containerVisualEffectView) {
      $0.fill(padding: .all(padding))
    }
  }
}

extension BXPageControl {
  static var `default`: BXPageControl {
    return .init(alignment: .leading, style: .dot)
  }
  static var snake: BXPageControl {
    return .init(alignment: .leading, style: .snake)
  }
  static var caterpillar: BXPageControl {
    return .init(alignment: .leading, style: .caterpillar)
  }
}
