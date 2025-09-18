//
//  UIEdgeInsets+Ext.swift
//  BXComponents
//
//  Created by Chhailong on 11/9/25.
//
import UIKit

extension UIEdgeInsets {
  static func all(_ value: CGFloat) -> UIEdgeInsets {
    return .init(top: value, left: value, bottom: value, right: value)
  }
}
