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

  private var currentPageIndicatorView: UIView?
  private var currentPageIndicatorViewLeadingConstraint: NSLayoutConstraint?
  private var currentPageIndicatorViewTrailingConstraint: NSLayoutConstraint?

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
  
  private var spacing: CGFloat = 6
  private var size: CGFloat = 8
  private var padding: CGFloat = 6
  private var currentPage: Int = 0
  
  
  var numberOfPages: Int = 1
  
  public func setNumberOfPages(_ numberOfPages: Int) {
    assert(numberOfPages > 0, "Number of pages must be greater than zero")

    self.numberOfPages = numberOfPages
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    // +1 view
    (0...numberOfPages).forEach { i in
        let dot = UIView()
      dot.tag = i
      dot.height(size)
      dot.minWidth(size)

      dot.clipsToBounds = true
      dot.layer.cornerRadius = size / 2
      dot.backgroundColor = pageIndicatorTintColor

      stackView.addArrangedSubview(dot)
    }
  }
  
  public func setCurrentPage(_ currentPage: Int, withAnimation: Bool = true) {
    assert(currentPage >= 0 && currentPage < numberOfPages, "Current page index must be between 0 and \(numberOfPages - 1)")
    Haptic.selection.generate()
    self.currentPage = currentPage
    self.currentPageIndicatorViewTrailingConstraint?.constant = CGFloat(currentPage) * (size + spacing) + spacing + size + size
    if withAnimation {
      UIView.animate(withDuration: 0.25) {
        self.layoutIfNeeded()
      }
      self.currentPageIndicatorViewLeadingConstraint?.constant = CGFloat(currentPage) * (size + spacing)
      UIView.animate(withDuration: 0.65) {
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

  let style: Style
  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc
  func handleTap() {
    if currentPage < numberOfPages - 1 {
      next()
    } else {
      setCurrentPage(0)
    }
  }

  
  private func setupViews() {
    clipsToBounds = true
    layer.cornerRadius = self.padding + (self.size / 2)
    isUserInteractionEnabled = true
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

    visualEffectView.layout(in: self) {
      $0.fill()
    }

    stackView.layout(in: self) {
      $0.fill(padding: .all(padding))
    }
    currentPageIndicatorView = UIView()
    currentPageIndicatorView?.backgroundColor = currentPageIndicatorTintColor
    currentPageIndicatorView?.clipsToBounds = true
    currentPageIndicatorView?.layer.cornerRadius = size / 2
    currentPageIndicatorView?.layout(in: self) {
      $0.width(size * 2 + spacing)
        .height(size)
        .centerY()
    }
    self.currentPageIndicatorViewLeadingConstraint = currentPageIndicatorView?.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
    self.currentPageIndicatorViewLeadingConstraint?.isActive = true
    
    self.currentPageIndicatorViewTrailingConstraint = currentPageIndicatorView?.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: size * 2 + spacing)
    self.currentPageIndicatorViewTrailingConstraint?.isActive = true
  }
}
