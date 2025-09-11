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
  }
  override func loadView() {
    super.loadView()
    
    pageControl.layout(in: view) {
      $0.center()
    }
    
    pageControl.setNumberOfPages(4)
    pageControl.pageIndicatorTintColor = .yellow
    pageControl.currentPageIndicatorTintColor = .red
  }
  // MARK: ACTIONS
  
}

