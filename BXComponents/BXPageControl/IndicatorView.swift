//
//  IndicatorView.swift
//  BXComponents
//
//  Created by Chhailong Sann on 18/9/25.
//

import UIKit

class IndicatorView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setIndicatorColor(_ color: UIColor) {
    backgroundColor = color
  }
}

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

