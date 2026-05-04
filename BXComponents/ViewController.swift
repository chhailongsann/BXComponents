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
  lazy var tableView: UITableView = .init(frame: .zero, style: .plain).config {
    $0.dataSource = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
  }
  
  let wheeler = Wheeler()

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
    title = "table"
  }
  override func loadView() {
    super.loadView()
//    
//    ImageResource.warmTextureWallpaper.loadAsync { image in
//      let imageView = UIImageView(image: image)
//      self.view.addSubview(imageView)
//      imageView.layout(in: self.view) {
//        $0.fill() 
//      }
//    }
    
    let image = ImageResource.warmTextureWallpaper
    wheeler.layout(in: view) {
      $0.centerY()
        .leading()
        .trailing()
        .height(40)
    }
  }
  // MARK: ACTIONS
  
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell(style: .subtitle, reuseIdentifier: "cellid")
  }
}
