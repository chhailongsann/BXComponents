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
    case dots
    case snakes
    case instagram
  }

  private var currentPageIndicatorView: UIView?
//  private var currentPageIndicatorViewLeadingConstraint: NSLayoutConstraint?
//  private var currentPageIndicatorViewTrailingConstraint: NSLayoutConstraint?

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
  var alignment: Alignment = .center

  public func setNumberOfPages(_ numberOfPages: Int) {
    assert(numberOfPages > 0, "Number of pages must be greater than zero")

    self.numberOfPages = numberOfPages
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    (0..<numberOfPages).forEach { i in
      let dot = UIView()
      dot.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      dot.tag = i
      dot.height(size)
      dot.width(size)

      dot.clipsToBounds = true
      dot.layer.cornerRadius = size / 2

      var scale: CGFloat = 1
      let offset = abs(i - currentPage)
      if offset > 1 {
        scale = 1 - (CGFloat(offset * 10) / 100)
      }
      if scale < 0.4 {
        scale = 0.4
      }

      dot.transform = CGAffineTransform(scaleX: scale, y: scale)

      stackView.addArrangedSubview(dot)
    }
  }
  
  public func setCurrentPage(_ currentPage: Int, withAnimation: Bool = true) {
    assert(currentPage >= 0 && currentPage < numberOfPages, "Current page index must be between 0 and \(numberOfPages - 1)")
    Haptic.selection.generate()
    self.currentPage = currentPage

    stackView.arrangedSubviews.forEach { dot in
      let i = dot.tag
      var scale: CGFloat = 1
      var alpha: CGFloat = 1
      let offset = abs(i - currentPage)
      if offset >= 1 {
        scale = 1 - (CGFloat(offset * 20) / 100)
        alpha = 1 - (CGFloat(offset * 15) / 100)
      }
      if scale < 0.4 {
        scale = 0.4
      }
//      if alpha < 0.4 {
//        alpha = 0.4
//      }
      dot.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
      dot.width(size)
      UIView.animate(withDuration: 0.25) {
        dot.transform = CGAffineTransform(scaleX: scale, y: scale)
      }
//      dot.transform = CGAffineTransform(scaleX: scale, y: scale)

    }
    

    if withAnimation {
//      self.currentPageIndicatorViewTrailingConstraint?.constant = CGFloat(currentPage) * (size + spacing) + spacing + size + size
//      self.currentPageIndicatorViewLeadingConstraint?.constant = CGFloat(currentPage) * (self.size + self.spacing)

      UIView.animate(withDuration: 0.25) {
        self.layoutIfNeeded()
      }

//      self.currentPageIndicatorViewLeadingConstraint?.constant = CGFloat(currentPage) * (self.size + self.spacing)
//      UIView.animate(
//        withDuration: 0.65,
//          delay: 0,
//          options: [.curveEaseInOut, .allowUserInteraction],
//          animations: {
//            self.layoutIfNeeded()
//          },
//          completion: { finished in
//          }
//      )
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

  public func bind(_ collectionView: UICollectionView) {
    if let layout = collectionView.collectionViewLayout as? SnapToCenterCollectionViewLayout {
      layout.centerFirstItem = true
    }
    collectionView.reloadData()
    collectionView.layoutIfNeeded()

    let numberOfSections = collectionView.numberOfSections
    var allItems: Int = 0
    for section in 0..<numberOfSections {
      let numberOfItems = collectionView.numberOfItems(inSection: section)
      allItems += numberOfItems
    }
    setNumberOfPages(allItems)
  }
  
  private func setupViews() {

    isUserInteractionEnabled = true
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

    stackView.layout(in: self) {
      $0.top(padding)
        .bottom(padding)
        .centerX()
    }
    visualEffectView.layout(in: self) {
      $0.top(constraint: stackView.topAnchor, -padding)
        .leading(constraint: stackView.leadingAnchor, -padding)
        .bottom(constraint: stackView.bottomAnchor, padding)
        .trailing(constraint: stackView.trailingAnchor, padding)
    }
    sendSubviewToBack(visualEffectView)
    visualEffectView.clipsToBounds = true
    visualEffectView.layer.cornerRadius = self.padding + (self.size / 2)

//    currentPageIndicatorView = UIView()
//    currentPageIndicatorView?.backgroundColor = currentPageIndicatorTintColor
//    currentPageIndicatorView?.clipsToBounds = true
//    currentPageIndicatorView?.layer.cornerRadius = size / 2
//    currentPageIndicatorView?.layout(in: self) {
//      $0.width(size * 2 + spacing)
//        .height(size)
//        .centerY()
//    }
//    self.currentPageIndicatorViewLeadingConstraint = currentPageIndicatorView?.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
//    self.currentPageIndicatorViewLeadingConstraint?.isActive = true
//    
//    self.currentPageIndicatorViewTrailingConstraint = currentPageIndicatorView?.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: size * 2 + spacing)
//    self.currentPageIndicatorViewTrailingConstraint?.isActive = true
  }
}
