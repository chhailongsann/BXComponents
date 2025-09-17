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
  let sliderView = HorizontalSlideViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
  }
  override func loadView() {
    super.loadView()

    sliderView.view.layout(in: view) {
      $0.top()
        .leading()
        .trailing()
        .height(200)
    }
    pageControl.layout(in: view) {
      $0.top(constraint: sliderView.view.bottomAnchor, 20)
        .leading()
        .trailing()
    }


    pageControl.bind(sliderView.collectionView)

    sliderView.didSelectItemAt = { [weak self] index in
      self?.pageControl.setCurrentPage(index)
    }
    sliderView.willChangeFocusItem = { [weak self] movement in
      if movement == .backward {
        self?.pageControl.previous()
      } else {
        self?.pageControl.next()
      }
    }
  }
  // MARK: ACTIONS
  
}

