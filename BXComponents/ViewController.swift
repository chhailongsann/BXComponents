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
  
  let pageControl: BXPageControl = .init(style: .dots)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
  }
  override func loadView() {
    super.loadView()
    
    pageControl.layout(in: view) {
      $0.center()
    }
    
    pageControl.setNumberOfPages(24)

  }
  // MARK: ACTIONS
  
}

