//
//  ViewController.swift
//  BXComponents
//
//  Created by Chhailong on 7/9/25.
//

import UIKit

class ViewController: UIViewController {
  
  var isJiggling: Bool = false
  
  let redCapsule = Capsule(fillColor: .systemRed)
  var widthConstraint, heightConstraint: NSLayoutConstraint?
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    let button = UIButton(type: .close)
    let close = UIAction { [unowned self] _ in
      isJiggling.toggle()
      widthConstraint?.constant = isJiggling ? 100:300
      heightConstraint?.constant = isJiggling ? 300:100

      UIView.animate(withDuration: 0.31, delay: 0, options: .overrideInheritedCurve) {
        self.view.layoutSubviews()
        self.redCapsule.setNeedsDisplay()
      }
    }
    button.addAction(close, for: .touchUpInside)
    
    button.layout(in: view) {
      $0.top(12)
        .centerX()
    }
    redCapsule.layout(in: view) {
      $0.center()
      $0.backgroundColor = .red
    }
    widthConstraint = redCapsule.constraintWidth(300)
    heightConstraint = redCapsule.constraintHeight(100)

    view.bringSubviewToFront(button)
  }
  // MARK: ACTIONS
  
}

