//
//  BXPageControl.swift
//  BXComponents
//
//  Created by Chhailong on 9/9/25.
//

import UIKit

class BXPageControl: UIControl {
  
  
  var currentPageIndicatorTintColor: UIColor = .label
   
  var pageIndicatorTintColor: UIColor = .secondaryLabel
  
  let numberOfPages: Int
  
  init(numberOfPages: Int) {
    self.numberOfPages = numberOfPages
    super.init(frame: .zero)
    self.width(100)
    self.height(20)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
