//
//  UIView+Stacking.swift
//  BXAnchor
//
//  Created by Sann Chhailong on 10/6/25.
//


import UIKit

@available(iOS 11.0, tvOS 11.0, *)
extension UIView {
  
  fileprivate func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView?], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    let _views = views.compactMap { $0 }
    let stackView = UIStackView(arrangedSubviews: _views)
    stackView.axis = axis
    stackView.spacing = spacing
    stackView.alignment = alignment
    stackView.distribution = distribution
    addSubview(stackView)
    stackView.fill()
    return stackView
  }
  
  @discardableResult
  public func vstack(_ views: UIView?..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
  }
  @discardableResult
  public func stack(_ views: [UIView]) -> UIStackView {
    return _stack(.vertical, views: views)
  }
  
  @discardableResult
  public func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
  }
  
  @discardableResult
  public func withSize<T: UIView>(_ size: CGSize) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: size.width).isActive = true
    heightAnchor.constraint(equalToConstant: size.height).isActive = true
    return self as! T
  }
  
  @discardableResult
  public func withHeight<T: UIView>(_ height: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: height).isActive = true
    return self as! T
  }
  
  @discardableResult
  public func withMinHeight<T: UIView>(_ height: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
    return self as! T
  }
  
  @discardableResult
  public func withWidth<T: UIView>(_ width: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: width).isActive = true
    return self as! T
  }
  @discardableResult
  public func square<T: UIView>(_ width: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: width).isActive = true
    heightAnchor.constraint(equalToConstant: width).isActive = true
    return self as! T
  }
  
  @discardableResult
  public func withMinWidth<T: UIView>(_ width: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
    return self as! T
  }
  
  @discardableResult
  public func withBorder<T: UIView>(width: CGFloat, color: UIColor) -> T {
    layer.borderWidth = width
    layer.borderColor = color.cgColor
    return self as! T
  }
  
  @discardableResult
  public func visibility<T: UIView>(_ hidden: Bool) -> T {
    isHidden = hidden
    return self as! T
  }
  
}

extension CGSize {
  static public func equalEdge(_ edge: CGFloat) -> CGSize {
    return .init(width: edge, height: edge)
  }
}

extension CGSize {
  static public func square(_ wid: CGFloat) -> CGSize {
    return .init(width: wid, height: wid)
  }
}

extension UIImageView {
  convenience public init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFit) {
    self.init(image: image)
    self.contentMode = contentMode
    self.clipsToBounds = true
  }
  convenience init(cornerRadius: CGFloat = 0, image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFit, tintColor: UIColor = .black) {
    self.init(image: nil)
    self.image = image
    self.tintColor = tintColor
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
    self.contentMode = contentMode
    self.isUserInteractionEnabled = true
  }
}
