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
  
//  let pageControl: BXPageControl = .init(alignment: .center)
  let sliderView = HorizontalSlideViewController()

  let textView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.isScrollEnabled = false
    let attachment = NSTextAttachment()
//    attachment.image = UIImage(systemName: "star.fill")
    textView.attributedText = NSAttributedString(string: "Hello World", attributes: [.attachment: attachment])
    return textView
  }()

  let liquidGlassContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    let visualEffect: UIVisualEffect

    if #available(iOS 26.0, *) {
      visualEffect = UIGlassContainerEffect()
    } else {
      visualEffect = UIBlurEffect(style: .regular)
    }
    let visualEffectView = UIVisualEffectView(effect: visualEffect)
    view.addSubview(visualEffectView)
    visualEffectView.layout(in: view) {
      $0.fill()
    }
    return view
  }()

  let liquidGlassContainer1: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    let visualEffect: UIVisualEffect

    if #available(iOS 26.0, *) {
      visualEffect = UIGlassContainerEffect()
    } else {
      visualEffect = UIBlurEffect(style: .regular)
    }
    let visualEffectView = UIVisualEffectView(effect: visualEffect)
    view.addSubview(visualEffectView)
    visualEffectView.layout(in: view) {
      $0.fill()
    }
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  override func loadView() {
    super.loadView()

    sliderView.view.layout(in: view) {
      $0.top()
        .leading()
        .trailing()
        .height(200)
    }
//    pageControl.layout(in: view) {
//      $0.top(constraint: sliderView.view.bottomAnchor, 20)
//        .leading()
//        .trailing()
//    }
//    sliderView.didSelectItemAt = { [weak self] index in
//      self?.pageControl.setCurrentPage(index)
//    }
//    sliderView.willChangeFocusItem = { [weak self] movement in
//      if movement == .backward {
//        self?.pageControl.previous()
//      } else {
//        self?.pageControl.next()
//      }
//    }

    let text = UILabel()
    text.text = "Hello World"
    text.layout(in: view) {
      $0.center()
    }
    liquidGlassContainer.layout(in: view) {
      $0.top(constraint: sliderView.view.topAnchor)
        .leading()
        .trailing()
        .height(40)
    }

    liquidGlassContainer1.layout(in: view) {
      $0.top(constraint: liquidGlassContainer.bottomAnchor)
        .leading()
        .trailing()
        .height(40)
    }


  }
  // MARK: ACTIONS
  
}
