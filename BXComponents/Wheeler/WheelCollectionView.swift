//
//  WheelCollectionView.swift
//  BXComponents
//
//  Created by Chhailong Sann on 13/5/26.
//

import UIKit

open class WheelCollectionView: UICollectionView {

  init() {
    super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func reloadLayout() {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
      switch sectionIndex {
        case 0:
        return self.foodBannerSection()
      default:
        fatalError("Unhandled section")
      }
    }
    self.setCollectionViewLayout(layout, animated: true)
  }

  public func foodBannerSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension:        .fractionalWidth(0.7), heightDimension: .absolute(225))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    return section
  }

}
