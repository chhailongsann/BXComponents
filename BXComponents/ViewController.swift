//
//  ViewController.swift
//  BXComponents
//
//  Created by Chhailong on 7/9/25.
//

import UIKit
import BXAnchor

class ViewController: UIViewController {
  
  var isJiggling: Bool = false
  
  let pageControl: BXPageControl = .init(numberOfPages: 3)
  let redCapsule: Capsule = .init()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    var heightContraint: NSLayoutConstraint!
    let button = UIButton(type: .close)
    let close = UIAction { [unowned self] _ in
     
      heightContraint.constant = 29
      UIView.animate(withDuration: 0.31, delay: 0, options: .overrideInheritedCurve) {
        self.view.layoutSubviews()
        self.pageControl.setNeedsDisplay()
      }
    }
    button.addAction(close, for: .touchUpInside)
    
    button.layout(in: view) {
      $0.top(12)
        .centerX()
    }
    redCapsule.backgroundColor = .red
    redCapsule.layout(in: view) {
      $0.width(20)
        .centerX()
        .constraintTop(to: view.centerYAnchor, constant: 0)
    }
    heightContraint = redCapsule.constraintHeight(100)
    pageControl.backgroundColor = .yellow
    view.bringSubviewToFront(button)
  }
  // MARK: ACTIONS
  
}

