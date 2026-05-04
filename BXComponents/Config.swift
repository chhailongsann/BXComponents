//
//  Config.swift
//  BXComponents
//
//  Created by Chhailong Sann on 14/1/26.
//
import UIKit

public protocol Config { }
extension NSObject: Config { }

extension Config where Self: NSObject {
  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().decorate {
  ///       $0.textAlignment = .center
  ///       $0.textColor = .black
  ///       $0.text = "Hi There!"
  ///     }
  public func decorate(_ closure: (Self) -> Void) -> Self {
    closure(self)
    return self
  }

  public func config(_ closure: (Self) -> Void) -> Self {
    closure(self)
    return self
  }
}
