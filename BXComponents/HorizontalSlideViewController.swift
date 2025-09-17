//
//  HorizontalSlideViewController.swift
//  BXComponents
//
//  Created by Chhailong Sann on 16/9/25.
//
import UIKit

class HorizontalSlideViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  enum MovementState {
    case forward
    case backward
  }
  var willChangeFocusItem: ((MovementState) -> Void)?
  var didSelectItemAt: ((Int) -> Void)?

  let pageControl: BXPageControl = .init(style: .dots)

  lazy var collectionView: UICollectionView = {
    let layout = SnapToCenterCollectionViewLayout()
    layout.minimumSectionInsetLeft = 16
    layout.minimumSectionInsetRight = 16
    layout.sectionInsetTop = 0
    layout.sectionInsetBottom = 0
    layout.interItemSpacing = 16
    layout.centerFirstItem = false
    layout.focusChangeDelegate = self
    let height: CGFloat = 164+16
    let width: CGFloat = height * 16 / 10
    layout.itemSize = CGSize(width: width, height: height)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.contentInset.left = 16
    collectionView.contentInset.right = 16
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(RandomizedCollection.self, forCellWithReuseIdentifier: "RandomizedCollection")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.clipsToBounds = false
    collectionView.layer.masksToBounds = false
    return collectionView
  }()

  let cellWidth: CGFloat = 250
  let cellSpacing: CGFloat = 16

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    collectionView.layout(in: self.view) {
      $0.top()
        .leading()
        .trailing()
        .height(200)
    }

    pageControl.layout(in: view) {
      $0.top(constraint: collectionView.bottomAnchor, 20)
        .leading()
        .trailing()
    }
    pageControl.bind(collectionView)


    // center first/last by setting inset
//    let inset = (collectionView.bounds.width - cellWidth) / 2
//    collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
  }

  // MARK: - Scroll snapping
//  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
//                                 withVelocity velocity: CGPoint,
//                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//
//    let cellSpace = layout.itemSize.width + layout.minimumLineSpacing
//    // target offset x (proposed)
//    let proposedX = targetContentOffset.pointee.x + collectionView.contentInset.left
//
//    // find nearest index
//    var index = round(proposedX / cellSpace)
//    // optionally bound index to valid range:
//    let maxIndex = max(0, collectionView.numberOfItems(inSection: 0) - 1)
//    index = max(0, min(CGFloat(maxIndex), index))
//
//    // compute new offset to center
//    let newOffsetX = index * cellSpace - collectionView.contentInset.left
//    targetContentOffset.pointee.x = newOffsetX
//  }

  // MARK: - DataSource (example)
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 12 }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // dequeue configured cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomizedCollection", for: indexPath) as! RandomizedCollection
    return cell
  }
  
}


// MARK: - FocusChangeDelegate

extension HorizontalSlideViewController: FocusChangeDelegate {
  func focusContainer(_ container: FocusedContaining, willChangeElement inFocus: Int, to newInFocus: Int) {
    let movement: MovementState = inFocus < newInFocus ? .backward : .forward
    if movement == .forward {
      pageControl.previous()
    } else {
      pageControl.next()
    }
  }

  func focusContainer(_ container: FocusedContaining, didChangeElement inFocus: Int) {

  }
}

class RandomizedCollection: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .red
    contentView.layer.cornerRadius = 8
    contentView.clipsToBounds = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIColor {
  static var random: UIColor {
    return UIColor(
      red:   .random(in: 0...1),
      green: .random(in: 0...1),
      blue:  .random(in: 0...1),
      alpha: 1.0
    )
  }
}
