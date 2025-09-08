//
//  UIView+Layout.swift
//  BXAnchor
//
//  Created by Sann Chhailong on 10/6/25.
//

import UIKit

public typealias ParentChildView = (UIView, UIView)

public struct AnchoredConstraints {
  public var top, leading, bottom, trailing, centerX, centerY, width, height: NSLayoutConstraint?
}

@available(iOS 11.0, tvOS 11.0, *)
public enum Anchor {
  case top(_ top: NSLayoutYAxisAnchor, constant: CGFloat = 0)
  case leading(_ leading: NSLayoutXAxisAnchor, constant: CGFloat = 0)
  case bottom(_ bottom: NSLayoutYAxisAnchor, constant: CGFloat = 0)
  case trailing(_ trailing: NSLayoutXAxisAnchor, constant: CGFloat = 0)
  case centerX(_ centerX: NSLayoutXAxisAnchor, constant: CGFloat = 0)
  case centerY(_ centerY: NSLayoutYAxisAnchor, constant: CGFloat = 0)
  case height(_ constant: CGFloat)
  case width(_ constant: CGFloat)
}

@available(iOS 11.0, tvOS 11.0, *)
extension UIView {
  
  
  @discardableResult
  private func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> Self {
    
    
    var anchoredConstraints = AnchoredConstraints()
    
    if let top = top {
      anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
    }
    
    if let leading = leading {
      anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
    }
    
    if let bottom = bottom {
      anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
    }
    
    if let trailing = trailing {
      anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
    }
    
    if size.width != 0 {
      anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
    }
    
    if size.height != 0 {
      anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
    }
    
    [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
    
    return self
  }
  
  // MARK: Layout view
  @discardableResult
  public func layout(in superview: UIView, completion: (UIView) -> Void) -> Self {
    superview.addSubview(self)
    translatesAutoresizingMaskIntoConstraints = false
    completion(self)
    return self
  }
  
  @discardableResult
  public func anchor(_ anchors: Anchor...) -> Self {
    
    var anchoredConstraints = AnchoredConstraints()
    anchors.forEach { anchor in
      switch anchor {
      case .top(let anchor, let constant):
        anchoredConstraints.top = topAnchor.constraint(equalTo: anchor, constant: constant)
      case .leading(let anchor, let constant):
        anchoredConstraints.leading = leadingAnchor.constraint(equalTo: anchor, constant: constant)
      case .bottom(let anchor, let constant):
        anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: anchor, constant: -constant)
      case .trailing(let anchor, let constant):
        anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: anchor, constant: -constant)
      case .centerX(let anchor, let constant):
        anchoredConstraints.centerX = centerXAnchor.constraint(equalTo: anchor, constant: constant)
      case .centerY(let anchor, let constant):
        anchoredConstraints.centerY = centerYAnchor.constraint(equalTo: anchor, constant: constant)
      case .height(let constant):
        if constant >= 0 {
          anchoredConstraints.height = heightAnchor.constraint(equalToConstant: constant)
        }
      case .width(let constant):
        if constant >= 0 {
          anchoredConstraints.width = widthAnchor.constraint(equalToConstant: constant)
        }
      }
    }
    [anchoredConstraints.top,
     anchoredConstraints.leading,
     anchoredConstraints.bottom,
     anchoredConstraints.trailing,
     anchoredConstraints.centerX,
     anchoredConstraints.centerY,
     anchoredConstraints.width,
     anchoredConstraints.height].forEach {
      $0?.isActive = true
    }
    return self
  }
  
  
  // MARK: Alignment
  @discardableResult
  public func fill(padding: UIEdgeInsets = .zero, ignoreSafeArea: Bool = false) -> Self {
        
    if ignoreSafeArea {
      if let superviewTopAnchor = superview?.topAnchor,
            let superviewBottomAnchor = superview?.bottomAnchor,
            let superviewLeadingAnchor = superview?.leadingAnchor,
            let superviewTrailingAnchor = superview?.trailingAnchor {
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
      }
    } else {
      if let superviewTopAnchor = superview?.safeAreaLayoutGuide.topAnchor,
            let superviewBottomAnchor = superview?.safeAreaLayoutGuide.bottomAnchor,
            let superviewLeadingAnchor = superview?.safeAreaLayoutGuide.leadingAnchor,
            let superviewTrailingAnchor = superview?.safeAreaLayoutGuide.trailingAnchor {
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
      }
    }
    return self
  }
  
  @discardableResult
  public func top(_ constant: CGFloat = 0, ignoreSafeArea: Bool = false) -> Self {
    if ignoreSafeArea {
      if let superviewAnchor = superview?.topAnchor {
        topAnchor.constraint(equalTo: superviewAnchor, constant: constant).isActive = true
      }
    } else {
      if let superviewAnchor = superview?.safeAreaLayoutGuide.topAnchor {
        topAnchor.constraint(equalTo: superviewAnchor, constant: constant).isActive = true
      }
    }
    return self
  }
  
  
  @discardableResult
  public func leading(_ constant: CGFloat = 0, ignoreSafeArea: Bool = false) -> Self {
    if ignoreSafeArea {
      if let superviewAnchor = superview?.leadingAnchor {
        leadingAnchor.constraint(equalTo: superviewAnchor, constant: constant).isActive = true
      }
    } else {
      if let superviewAnchor = superview?.safeAreaLayoutGuide.leadingAnchor {
        leadingAnchor.constraint(equalTo: superviewAnchor, constant: constant).isActive = true
      }
    }
    return self
  }
  
  @discardableResult
  public func bottom(_ constant: CGFloat = 0, ignoreSafeArea: Bool = false) -> Self {
    if ignoreSafeArea {
      if let superviewAnchor = superview?.bottomAnchor {
        bottomAnchor.constraint(equalTo: superviewAnchor, constant: -constant).isActive = true
      }
    } else {
      if let superviewAnchor = superview?.safeAreaLayoutGuide.bottomAnchor {
        bottomAnchor.constraint(equalTo: superviewAnchor, constant: -constant).isActive = true
      }
    }
    return self
  }
  
  @discardableResult
  public func trailing(_ constant: CGFloat = 0, ignoreSafeArea: Bool = false) -> Self {
    if ignoreSafeArea {
      if let superviewAnchor = superview?.trailingAnchor {
        trailingAnchor.constraint(equalTo: superviewAnchor, constant: -constant).isActive = true
      }
    } else {
      if let superviewAnchor = superview?.safeAreaLayoutGuide.trailingAnchor {
        trailingAnchor.constraint(equalTo: superviewAnchor, constant: -constant).isActive = true
      }
    }
    return self
  }
  
  
  /// Cener to superview
  @discardableResult
  public func center() -> Self {
    if let superviewCenterXAnchor = superview?.centerXAnchor {
      centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
    }
    if let superviewCenterYAnchor = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
    }
    return self
  }
  
  @discardableResult
  public func centerX(to anchor: NSLayoutXAxisAnchor? = nil) -> Self {
    if let anchor = anchor {
      centerXAnchor.constraint(equalTo: anchor).isActive = true
    } else if let anchor = superview?.centerXAnchor {
      centerXAnchor.constraint(equalTo: anchor).isActive = true
    }
    return self
  }
  @discardableResult
  public func centerY(to anchor: NSLayoutYAxisAnchor? = nil) -> Self {
    if let anchor = anchor {
      centerYAnchor.constraint(equalTo: anchor).isActive = true
    } else if let anchor = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: anchor).isActive = true
    }
    return self
  }
  
  // MARK: Constraints (for animation)

  func constraintWidth(_ constant: CGFloat) -> NSLayoutConstraint {
    let widthConstraint = widthAnchor.constraint(equalToConstant: constant)
    widthConstraint.isActive = true
    return widthConstraint
  }

  func constraintHeight(_ constant: CGFloat) -> NSLayoutConstraint {
    let heightConstraint = heightAnchor.constraint(equalToConstant: constant)
    heightConstraint.isActive = true
    return heightConstraint
  }

  func constraintTop(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
    let topConstraint = topAnchor.constraint(equalTo: anchor, constant: constant)
    topConstraint.isActive = true
    return topConstraint
  }
  
  func constraintBottom(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
    let bottomConstraint = bottomAnchor.constraint(equalTo: anchor, constant: -constant)
    bottomConstraint.isActive = true
    return bottomConstraint
  }
  
  func constraintLeading(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
    let leadingConstraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
    leadingConstraint.isActive = true
    return leadingConstraint
  }
  
  func constraintTrailing(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
    let trailingConstraint = trailingAnchor.constraint(equalTo: anchor, constant: -constant)
    trailingConstraint.isActive = true
    return trailingConstraint
  }
  
  
  // MARK: SIZE
  @discardableResult
  func width(_ constant: CGFloat) -> Self{
    widthAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }
  
  @discardableResult
  func height(_ constant: CGFloat) -> Self {
    heightAnchor.constraint(equalToConstant: constant).isActive = true
    return self
  }

  @discardableResult
  func maxWidth(_ constant: CGFloat) -> Self {
    widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    return self
  }
  
  @discardableResult
  func maxHeight(_ constant: CGFloat) -> Self {
    heightAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    return self
  }
  
  
  @discardableResult
  func minWidth(_ constant: CGFloat) -> Self{
    widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    return self
  }
  
  @discardableResult
  func minHeight(_ constant: CGFloat) -> Self {
    heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    return self
  }
  
  
  // MARK: Animations
  func shake(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .heavy){
    let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
    generator.prepare()
    generator.impactOccurred()
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 3
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
    self.layer.add(animation, forKey: "position")
    
  }
  
  func bouncing(isUp: Bool){
    
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.4
    animation.repeatCount = 2
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: isUp ? self.center.y - 4 : self.center.y + 4))
    self.layer.add(animation, forKey: "position")
    
  }
  
  func jiggle( _ value: Bool, angle: CGFloat = CGFloat.pi / 120) {
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.duration = 0.1
    animation.repeatCount = .infinity
    animation.autoreverses = true
    animation.fromValue = angle
    animation.toValue = -angle
    if value {
      self.layer.add(animation, forKey: "transform.rotation.z")
    } else {
      self.layer.removeAnimation(forKey: "transform.rotation.z")
    }
  }
  
  
  // MARK: ???
  public func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
    layer.shadowOpacity = opacity
    layer.shadowRadius = radius
    layer.shadowOffset = offset
    layer.shadowColor = color.cgColor
  }
  
}
