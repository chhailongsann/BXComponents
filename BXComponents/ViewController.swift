//
//  ViewController.swift
//  BXComponents
//
//  Created by Chhailong on 7/9/25.
//

import UIKit
import BXAnchor

class ViewController: UIViewController {

  private var searchTask: Task<Void, Never>?

  private let label = UILabel().config {
    $0.text = ""
    $0.numberOfLines = 0
  }

  private lazy var button = UIButton(type: .system).config {
    $0.setTitle("Search", for: .normal)
    let action = UIAction { _ in
      self.search("keyword")
    }
    $0.addAction(action, for: .touchUpInside)
  }

  private var displayLink: CADisplayLink?
  private var lastTimestamp: CFTimeInterval = 0
  private var accumulatedTime: CFTimeInterval = 0

  private let textToAnimate = "Here’s a clear, practical UIKit example showing how to use CADisplayLink to run code once per screen refresh (typically 60 Hz or 120 Hz on ProMotion). This is useful for animations that need to update at a fixed interval, regardless of the user's frame rate. In this example, we're animating a label to type out a string one character at a time. You can modify the string and the animation speed by changing the `textToAnimate` and `characterInterval` constants. Happy coding!"
  private var currentIndex = 0

  // Adjust this to control speed (seconds per character)
  private let characterInterval: CFTimeInterval = 0.08

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    let wheeler = Wheeler()
    wheeler.layout(in: self.view) {
      $0.centerY()
        .leading(100)
        .trailing(100)
        .height(40)
    }
  }

  deinit {
    displayLink?.invalidate()
  }
  private func startAnimation() {
    displayLink = CADisplayLink(target: self, selector: #selector(update))
    displayLink?.add(to: .main, forMode: .common)
  }

  @objc private func update(link: CADisplayLink) {
    if lastTimestamp == 0 {
      lastTimestamp = link.timestamp
      return
    }

    let delta = link.timestamp - lastTimestamp
    lastTimestamp = link.timestamp
    accumulatedTime += delta

    while accumulatedTime >= characterInterval {
      accumulatedTime -= characterInterval
      appendNextCharacter()
    }
  }

  private func appendNextCharacter() {
    guard currentIndex < textToAnimate.count else {
      displayLink?.invalidate()
      displayLink = nil
      return
    }

    let index = textToAnimate.index(
      textToAnimate.startIndex,
      offsetBy: currentIndex
    )

    label.text?.append(textToAnimate[index])
    currentIndex += 1
  }


  func search(_ query: String) {
    searchTask?.cancel()
    searchTask = Task {
      for _ in 1...3 {
        try? await Task.sleep(nanoseconds: 500_000_000)
      }
      print("Search results for: \(query)")
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
