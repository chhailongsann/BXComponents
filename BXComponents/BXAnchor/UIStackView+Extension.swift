//
//  UIStackView+Extension.swift
//  BXAnchor
//
//  Created by Sann Chhailong on 10/6/25.
//


import UIKit

extension UIStackView {
  
  @discardableResult
  public func spacing(_ value: CGFloat) -> UIStackView {
    self.spacing = value
    return self
  }
  @discardableResult
  public func alignment(_ value: UIStackView.Alignment) -> UIStackView {
    self.alignment = value
    return self
  }
  
  @discardableResult
  public func distribution(_ value: UIStackView.Distribution) -> UIStackView {
    self.distribution = value
    return self
  }
  
  @discardableResult
  public func padAll(_ padding: CGFloat) -> UIStackView {
    isLayoutMarginsRelativeArrangement = true
    layoutMargins.right = padding
    layoutMargins.left = padding
    layoutMargins.bottom = padding
    layoutMargins.top = padding
    return self
  }
  
  @discardableResult
  public func padding(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) -> UIStackView {
    isLayoutMarginsRelativeArrangement = true
    if let horizontal = horizontal {
      layoutMargins.right = horizontal
      layoutMargins.left = horizontal
    }
    
    if let vertical = vertical {
      layoutMargins.bottom = vertical
      layoutMargins.top = vertical
    }
    return self
  }
  
  @discardableResult
  public func padding(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> UIStackView {
    isLayoutMarginsRelativeArrangement = true
    if let top = top {
      layoutMargins.top = top
    }
    
    if let right = right {
      layoutMargins.right = right
    }
    if let left = left {
      layoutMargins.left = left
    }
    if let bottom = bottom {
      layoutMargins.bottom = bottom
    }
    return self
  }
}
