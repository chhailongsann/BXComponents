//
//  ViewController.swift
//  BXComponents
//
//  Created by Chhailong on 7/9/25.
//

import UIKit

class ViewController: UIViewController {
  
  var isJiggling: Bool = false
  
  let blueCapsule = Capsule(fillColor: .systemBlue)
  let redCapsule = Capsule(fillColor: .systemRed)
  var blueTopConstraint: NSLayoutConstraint?
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    let button = UIButton(type: .close)
    let close = UIAction { [unowned self] _ in
      isJiggling.toggle()
      blueTopConstraint?.constant = isJiggling ? 100 : 0
      UIView.animate(withDuration: 0.31, delay: 0, options: .overrideInheritedCurve) {
        self.view.layoutSubviews()
      }
    }
    button.addAction(close, for: .touchUpInside)
    
    button.layout(in: view) {
      $0.top(12)
        .centerX()
    }
    redCapsule.layout(in: view) {
      $0.width(100)
        .height(200)
        .centerX()
    }
    
    blueTopConstraint = redCapsule.constraintTop(to: button.bottomAnchor, constant: 0)

    
    
    view.bringSubviewToFront(button)
  }
  // MARK: ACTIONS
  
}

